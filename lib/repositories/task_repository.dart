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
  Future<Task> addTask(Task task ) async {
    try{
      final apiTask = await _apiService.addTask(task);
      return apiTask;
    }catch(e){
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
  Future<void> deleteTask(String id) async {
    try {
      await _apiService.deleteTask(id);
    } catch (e) {
      throw Exception("Error in deleteTask $e");
    }
  }
}
