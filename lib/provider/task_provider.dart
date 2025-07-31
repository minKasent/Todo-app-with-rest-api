import 'package:flutter/widgets.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedTasks = await _taskRepository.getAllTasks();
      _tasks = loadedTasks;
    } catch (e) {
      debugPrint("Error in loadTasks $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(String title, String description) async {
    try {
      final newTask = await _taskRepository.addTask(
        Task(title: title, description: description, status: 'pendiente'),
      );
      _tasks.add(newTask);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error in addTask $e");
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((element) => element.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint("Error in updateTask $e");
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _taskRepository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error in deleteTask $e");
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
