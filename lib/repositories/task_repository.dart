import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/services/api_service.dart';
import 'package:todo_app_with_rest_api/services/storage_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    await _storageService.init();
    _setupConnectivityListener();
  }

  // Set up connectivity listener to trigger sync when online
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((// lắng nghe sự thay đổi kết nối
      List<ConnectivityResult> results,
    ) async {
      if (!results.contains(ConnectivityResult.none)) {// nếu có kết nối mạng
        /// Sync with server
        if (await hasPendingSyncOperation()) {// check xem có bất kỳ thao tác đồng bộ nào đang được chờ xử lí hay không
          try {
            await syncWithServer();// nếu có thì sẽ đồng bộ với server
          } catch (e) {
            debugPrint("Error in syncWithServer $e");
          }
        }
      }
    });
  }

  // Check if there are pending sync operation
  // hàm này sẽ check xem có bất kỳ thao tác nào đang chờ đồng bộ hay không
  Future<bool> hasPendingSyncOperation() async {
    final syncQueue = await _storageService.getSyncQueueBox();
    return syncQueue.isNotEmpty;
  }

  /// Sync pending operations with server
  // hàm này sẽ đồng bộ các thao tác đang chờ xử lí trong syncQueueBox với server như thêm , sửa, xoá
  Future<void> syncWithServer() async {
    if (!await _isOnline()) {// nếu không có kết nối mạng
      throw Exception("No internet connection");
    }
    try {
      // chọc vào kho lưu trữ để lấy danh sách các thao tác đang chờ đồng bộ
      final syncQueue = await _storageService.getSyncQueueBox();
      if (syncQueue.isEmpty) {
        debugPrint("Sync queue is empty");// nếu không có thao tác nào đang chờ đồng bộ
        return;// không cần đồng bộ
      }
      // nếu có thì duyệt qua từng thao tác trong hàng đợi đồng bộ
      for (final item in syncQueue) {
        final operation = item['operation'] as String;// lấy loại thao tác (create, update, delete)
        final dynamic rawData = item['data'];// lấy dữ liệu thô từ thao tác (Map<dynamic, dynamic>)
        final timestamp = item['timestamp'] as int;// lấy thời gian của thao tác

        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        // chuyển đổi dữ liệu thô thành Map<String, dynamic>
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

        try {
          /// Sync with operation create, update, delete
          // tùy thuộc vào loại thao tác, sẽ thực hiện các thao tác tương ứng với API
          switch (operation) {
            case 'create':
              final task = Task.fromJson(data);
              await _apiService.addTask(task);
              break;

            case 'update':
              final task = Task.fromJson(data);
              await _apiService.updateTask(task);
              break;

            case 'delete':
              final taskId = data['id'] as String;
              await _apiService.deleteTask(taskId);
              break;
          }

          // Remove from sync queue after successful operation
          // sau khi đã thực hiện thành công thao tác, sẽ xoá thao tác đó khỏi hàng đợi đồng bộ
          await _storageService.removeFromSyncQueueBox(timestamp.toString());
          debugPrint("Sync operation $operation successful");
        } catch (e) {
          debugPrint("Failed to sync operation $operation $e");
        }
      }
    } catch (e) {
      debugPrint("Error in syncWithServer $e");
      throw Exception("Error in syncWithServer $e");
    }
  }
// hàm này sẽ lấy tất cả các tác vụ từ API hoặc từ local storage nếu không có kết nối mạng
  Future<List<Task>> getAllTasks() async {
    try {
      // Always try to get fresh data from API if online
      if (await _isOnline()) {
        try {
          // nếu có kết nối mạng, sẽ lấy dữ liệu từ API
          final apiTasks = await _apiService.getAllTasks();
          // đồng thời xoá các task cũ dưới local và lưu các task mới nhất từ api vào local storage
          await _storageService.clearAllTasks();
          await _storageService.saveAllTasks(apiTasks);

          return apiTasks;
        } catch (e) {
          /// API fails , get local data
          return await _storageService.getAllTasks();
        }
      } else {
        // If offline, return local data
        debugPrint("API fetch failed, falling back to local data");
        // nếu không có kết nối mạng, sẽ lấy dữ liệu từ local storage
        // dữ liệu này sẽ là những tác vụ đã được lưu trữ trước đó
        return await _storageService.getAllTasks();
      }
    } catch (e) {
      debugPrint("Error in getAllTasks $e");
      return await _storageService.getAllTasks();
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      if (await _isOnline()) {
        final apiTask = await _apiService.addTask(task);
        await _storageService.saveTask(task);
        return apiTask;
      } else {
        /// If offline, save to local storage and queue for sync
        await _storageService.saveTask(task);
        await _storageService.addToSyncQueueBox(
          operation: 'create',
          data: task.toJson(),
        );
        return task;
      }
    } catch (e) {
      throw Exception("Error in addTask $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      if (await _isOnline()) {
        await _apiService.updateTask(task);
        await _storageService.updateTask(task);
      } else {
        await _storageService.updateTask(task);
        await _storageService.addToSyncQueueBox(
          operation: 'update',
          data: task.toJson(),
        );
      }
    } catch (e) {
      throw Exception("Error in updateTask $e");
    }
  }

  /// Delete task from both API and local storage
  Future<void> deleteTask(String taskId) async {
    try {
      if (await _isOnline()) {
        await _apiService.deleteTask(taskId);
        await _storageService.deleteTask(taskId);
      } else {
        await _storageService.deleteTask(taskId);
        await _storageService.addToSyncQueueBox(// add vào hàng đợi đồng bộ với server khi online
          operation: 'delete',
          data: {'id': taskId},
        );
      }
    } catch (e) {
      throw Exception("Error in deleteTask $e");
    }
  }

  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {// không có kết nối mạng
        return false;
      }

      return true;

      /// Double check with API
      /// return await _apiService.isApiReachable();
    } catch (e) {
      return false;
    }
  }
}
