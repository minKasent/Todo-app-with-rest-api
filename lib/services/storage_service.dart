import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_with_rest_api/models/task.dart';

class StorageService {
  static const String _taskBoxName = 'tasks';
  static const String _syncQueueBoxName = 'sync_queue';
  // có 2 kho lưu trữ chính:
  late Box<Task> _taskBox; // kho lưu trữ các task khi offline
  late Box<Map>
  _syncQueueBox; // kho lưu trữ các thao tác cần đồng bộ khi offline

  // Initialize Hive boxes
  // hàm này sẽ khởi tạo các kho lưu trữ Hive
  Future<void> init() async {
    debugPrint('Initializing Hive Storage...');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    debugPrint(
      'Storage service initialized successfully: Existing tasks: ${_taskBox.length}',
    );
  }

  // task là online và taskbox là offline
  // hàm này sẽ lưu tất cả các task từ server vào _taskBox
  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving ${tasks.length} tasks to local storage...');
    //key   value
    final Map<String, Task> taskMap = {};
    for (final task in tasks) {
      final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      taskMap[key] = task.copyWith(id: key);
    }

    await _taskBox.putAll(taskMap);
    debugPrint('All tasks saved to local storage successfully');
  }

  // hàm này sẽ lấy tất cả các task từ _taskBox và trả về dưới dạng List<Task>
  Future<List<Task>> getAllTasks() async {
    final tasks = _taskBox.values.toList(); // get all values from the box
    debugPrint('Retrieved ${tasks.length} tasks from local storage');
    return tasks;
  }

  // hàm này sẽ xoá một task khỏi _taskBox dựa trên id
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    debugPrint('Task deleted from local storage: $id');
  }

  // hàm này sẽ cập nhật một task trong _taskBox nếu task có id thì cập nhật , không thì không làm gì cả
  Future<void> updateTask(Task task) async {
    if (task.id == null) return;

    await _taskBox.put(task.id, task);
    debugPrint('Task updated in local storage: ${task.id}');
  }

  // hàm này sẽ lưu một task vào _taskBox với id là key
  Future<void> saveTask(Task task) async {
    final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await _taskBox.put(key, task.copyWith(id: key));
    debugPrint('Task saved in local storage: $key');
  }

  // hàm này sẽ xóa tất cả các phần tử trong _taskBox
  Future<void> clearAllTasks() async {
    await _taskBox.clear();
    debugPrint('All tasks cleared from local storage');
  }

  // Sync queue operations for offline functionality
  // create, update, delete
  // hàm này sẽ thêm một phần tử vào _syncQueueBox với thông tin về thao tác (operation) và dữ liệu (data)
  Future<void> addToSyncQueueBox({
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    final queueItem = {
      'operation': operation, // operation: 'create', 'update', 'delete'
      'data': data, // Task Data
      'timestamp':
          DateTime.now()
              .millisecondsSinceEpoch, //(int) Time to save task into queue
    };

    /// Save data to _syncQueueBox
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _syncQueueBox.put(key, queueItem);
    debugPrint('Add to sync queue: $operation');
  }

  /// remove from sync queue
  // hàm này sẽ xóa một phần tử khỏi _syncQueueBox dựa trên timestamp
  Future<void> removeFromSyncQueueBox(String timestamp) async {
    // Convert timestamp string to int for comparison
    final timestampInt = int.tryParse(timestamp);
    if (timestampInt == null) {
      debugPrint('Invalid timestamp format: $timestamp');
      return;
    }
    // Find the item with the matching timestamp
    final keys =
        _syncQueueBox.keys.where((dynamic key) {
          final item = _syncQueueBox.get(key);
          return item != null && item['timestamp'] == timestampInt;
        }).toList();

    // Delete all matching items
    for (final key in keys) {
      await _syncQueueBox.delete(key);
      debugPrint('Remove from sync queue: $key');
    }
  }

  /// Get sync queue
  // hàm này sẽ trả về danh sách các phần tử trong _syncQueueBox
  Future<List<Map<String, dynamic>>> getSyncQueueBox() async {
    //item sẽ đại diện cho từng giá trị phần tử ,
    // .map sẽ duyệt qua từng item đồng thời chuyển đổi các item thành Map<String, dynamic>
    return _syncQueueBox.values.map<Map<String, dynamic>>((item) {
      final map = <String, dynamic>{};
      (item).forEach((key, value) {
        map[key.toString()] = value;
      });
      return map;
    }).toList();
  }
}
