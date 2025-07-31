import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/services/api_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  Future<List<Task>> getAllTasks() async {
    try {
      final apiGetTasks = await _apiService.getTasks();
      return apiGetTasks;
    } catch (e) {
      debugPrint("Error in getAllTasks $e");
      // handle local storage
      return [];
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      final apiAddTask = await _apiService.addTask(task);
      return apiAddTask;
    } catch (e) {
      throw Exception("Error in addTask $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final apiUpdateTask = await _apiService.updateTask(task);
      return apiUpdateTask;
    } catch (e) {
      throw Exception("Error in updateTask $e");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final apiDeleteTask = await _apiService.deleteTask(id);
      return apiDeleteTask;
    } catch (e) {
      throw Exception("Error in deleteTask $e");
    }
  }
}
