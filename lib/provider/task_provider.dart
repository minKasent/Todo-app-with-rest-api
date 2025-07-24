import 'package:flutter/widgets.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];

  List<Task> get allTasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  // Load tasks from repository
  Future<void> loadTasks() async {
    try {
      final loadedTasks = await _taskRepository.getAllTasks();
      _tasks = loadedTasks;
      notifyListeners();
    } catch (e) {
      debugPrint("Error in loadTasks $e");
    }
  }
}
