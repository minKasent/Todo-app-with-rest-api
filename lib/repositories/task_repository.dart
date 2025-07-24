import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/services/api_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  Future<List<Task>> getAllTasks() async {
    try {
      final apiTasks = await _apiService.getTasks();

      return apiTasks;
    } catch (e) {
      debugPrint("Error in getAllTasks $e");
      return [];
    }
  }
}
