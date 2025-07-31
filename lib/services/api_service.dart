import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com';
  static const String _apiKey =
      '73f36bbf3emsh0485c276574c141p16ec83jsne2d270cfbfc0';
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
          final List<dynamic> taskListJson = jsonResponse['data'] as List;

          return taskListJson
              .map((taskJson) {
                final taskData = Map<String, dynamic>.from(taskJson);
                if (taskData['id'] != null) {
                  taskData['id'] = taskData['id'].toString();
                }
                taskData['isLocalOnly'] = false;
                taskData['needsSync'] = false;
                return Task.fromJson(taskData);
              })
              .where((task) => task.id != null) // Lọc ra các task có id là null
              .toList();
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
      final Map<String, dynamic> taskdata = {
        'title': task.title,
        'description': task.description,
        'status': task.status,
      };
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode(taskdata),
      );
      debugPrint('API Response Status Code (Post) : ${response.statusCode}');
      debugPrint('API Response Body (Post) : ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        Map<String, dynamic> taskData;

        // Xử lý response có thể có cấu trúc khác nhau
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          taskData = Map<String, dynamic>.from(jsonResponse['data']);
        } else {
          // Nếu response trực tiếp là task data
          taskData = Map<String, dynamic>.from(jsonResponse);
        }

        // Xử lý id an toàn - convert sang string nếu cần
        if (taskData['id'] != null) {
          taskData['id'] = taskData['id'].toString();
        } else {
          // Nếu không có id, tạo một id tạm thời
          taskData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        }

        // Đảm bảo các field cần thiết tồn tại
        taskData['title'] = taskData['title'] ?? task.title;
        taskData['description'] = taskData['description'] ?? task.description;
        taskData['status'] = taskData['status'] ?? task.status;
        taskData['isLocalOnly'] = false;
        taskData['needsSync'] = false;

        return Task.fromJson(taskData);
      } else {
        throw Exception(
          "Failed to add task: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error adding task $e");
      throw Exception('Failed to add task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final Map<String, dynamic> taskdata = {
        'title': task.title,
        'description': task.description,
        'status': task.status,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/${task.id}'),
        headers: _headers,
        body: json.encode(taskdata),
      );
      debugPrint('API Response Status Code (Put) : ${response.statusCode}');
      debugPrint('API Response Body (Put) : ${response.body}');

      if (response.statusCode != 200) {
        throw Exception("Failed to update task: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating task $e");
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );
      debugPrint('API Response Status Code (Delete) : ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete task");
      }
    } catch (e) {
      debugPrint("Error deleting task $e");
      throw Exception('Failed to delete task: $e');
    }
  }
}
