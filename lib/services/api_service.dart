import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com';
  static const String _apiKey =
      'cdc1d88752mshe097344adee9d32p1a5063jsnfc190737c508';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  // Get All Tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      debugPrint('API Response Status Code: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        /// json api trả về dạng '{id, title, description, status}';
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if the response has the expected structure
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final List<dynamic> taskList = jsonResponse['data'] as List;// convert dynamic to List
          return taskList.map((taskJson) {//
            // Add default fields if missing from API response
            final taskData = Map<String, dynamic>.from(taskJson);

            taskData['isLocalOnly'] = false;
            taskData['needsSync'] = false;
            // gán vào model Task
            return Task.fromJson(taskData);
          }).toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      debugPrint("Error fetching tasks $e");
      throw Exception('Failed to fetch tasks $e');
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode(task.toJson()),
      );
      debugPrint('API Response Status Code (Post) : ${response.statusCode}');
      debugPrint('API Response Body (Post) : ${response.body}');
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to add task");
      }
    } catch (e) {
      debugPrint("Error adding task $e");
      throw Exception('Failed to add task $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${task.id}'),
        headers: _headers,
        body: json.encode(task.toJson()),
      );
      debugPrint('API Response Status Code (Put) : ${response.statusCode}');
      debugPrint('API Response Body (Put) : ${response.body}');
      if(response.statusCode != 200){
        throw Exception("Failed to update task");
      }
    } catch (e) {
      debugPrint("Error updating task $e");
      throw Exception('Failed to update task $e');
    }
  }
  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );
      debugPrint('API Response Status Code (Delete) : ${response.statusCode}');
      if(response.statusCode != 204){
        throw Exception("Failed to delete task");
      }
    } catch (e) {
      debugPrint("Error deleting task $e");
      throw Exception('Failed to delete task $e');
    }
  }
}
