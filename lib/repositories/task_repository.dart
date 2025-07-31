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
  }

  Future<List<Task>> getAllTasks() async {
    try {
      // Always try to get fresh data from API if online
      if (await _isOnline()) {
        try {
          final apiTasks = await _apiService.getTasks();

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
      final apiTask = await _apiService.addTask(task);
      return apiTask;
    } catch (e) {
      throw Exception("Error in addTask $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final apiTask = await _apiService.updateTask(task);
      return apiTask;
    } catch (e) {
      throw Exception("Error in updateTask $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _apiService.deleteTask(taskId);
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

      /// Double check with API
      return await _apiService.isApiReachable();
    } catch (e) {
      return false;
    }
  }
}
