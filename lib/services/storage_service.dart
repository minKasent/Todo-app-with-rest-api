import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_with_rest_api/models/task.dart';

class StorageService {
  static const String _taskBoxName = 'tasks';
  static const String _syncQueueBoxName = 'sync_queue';

  late Box<Task> _taskBox;
  late Box<Map> _syncQueueBox;

  // Initialize Hive boxes
  Future<void> init() async {
    debugPrint('Initializing Hive Storage...');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    debugPrint(
      'Storage service initialized successfully: Existing tasks: ${_taskBox.length}',
    );
  }

  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving ${tasks.length} tasks to local storage...');

    final Map<String, Task> taskMap = {};
    for (final task in tasks) {
      final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      taskMap[key] = task.copyWith(id: key);
    }

    await _taskBox.putAll(taskMap);
    debugPrint('All tasks saved to local storage successfully');
  }

  Future<List<Task>> getAllTasks() async {
    final tasks = _taskBox.values.toList();
    debugPrint('Retrieved ${tasks.length} tasks from local storage');
    return tasks;
  }

  Future<void> clearAllTasks() async {
    await _taskBox.clear();
    debugPrint('All tasks cleared from local storage');
  }
}
