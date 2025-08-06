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
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      if (!results.contains(ConnectivityResult.none)) {
        /// Sync with server
        if (await hasPendingSyncOperation()) {
          try {
            await syncWithServer();
          } catch (e) {
            debugPrint("Error in syncWithServer $e");
          }
        }
      }
    });
  }

  // Check if there are pending sync operation
  Future<bool> hasPendingSyncOperation() async {
    final syncQueue = await _storageService.getSyncQueueBox();
    return syncQueue.isNotEmpty;
  }

  /// Sync pending operations with server
  Future<void> syncWithServer() async {
    if (!await _isOnline()) {
      throw Exception("No internet connection");
    }

    try {
      final syncQueue = await _storageService.getSyncQueueBox();
      if (syncQueue.isEmpty) {
        debugPrint("Sync queue is empty");
        return;
      }

      for (final item in syncQueue) {
        final operation = item['operation'] as String;
        final dynamic rawData = item['data'];
        final timestamp = item['timestamp'] as int;

        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

        try {
          /// Sync with operation create, update, delete
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

  Future<List<Task>> getAllTasks() async {
    try {
      // Always try to get fresh data from API if online
      if (await _isOnline()) {
        try {
          final apiTasks = await _apiService.getAllTasks();

          // Save API tasks to local storage
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
        await _storageService.addToSyncQueueBox(
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
      if (connectivityResult.contains(ConnectivityResult.none)) {
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
