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

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    debugPrint('Task deleted from local storage: $id');
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) return;

    await _taskBox.put(task.id, task);
    debugPrint('Task updated in local storage: ${task.id}');
  }

  Future<void> saveTask(Task task) async {
    final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await _taskBox.put(key, task.copyWith(id: key));
    debugPrint('Task saved in local storage: $key');
  }

  Future<void> clearAllTasks() async {
    await _taskBox.clear();
    debugPrint('All tasks cleared from local storage');
  }

  // Sync queue operations for offline functionality
  // create, update, delete
  Future<void> addToSyncQueue({
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    final queueItem = {
      'operation': operation, // operation: 'create', 'update', 'delete'
      'data': data, // Task Data
      'timestamp':
          DateTime.now().millisecondsSinceEpoch, // Time to save task into queue
    };

    /// Save data to _syncQueueBox
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _syncQueueBox.put(key, queueItem);
    debugPrint('Add to sync queue: $operation');
  }

  /// remove from sync queue
  Future<void> removeFromSyncQueue(String timestamp) async {
    // Find the item with the matching timestamp
    final keys =
        _syncQueueBox.keys.where((key) {
          final item = _syncQueueBox.get(key);
          return item != null && item['timestamp'] == timestamp;
        }).toList();

    // Delete all matching items
    for (final key in keys) {
      await _syncQueueBox.delete(key);
      debugPrint('Remove from sync queue: $key');
    }
  }

  /// Get sync queue
  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    return _syncQueueBox.values.map<Map<String, dynamic>>((item) {
      final map = <String, dynamic>{};
      (item).forEach((key, value) {
        map[key.toString()] = value;
      });
      return map;
    }).toList();
  }
}
