import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];

  List<Task> get allTasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasError => _error != null;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('TaskProvider already initialized');
      return;
    }
    debugPrint('Initializing TaskProvider.....');
    try {
      _setLoading(true);

      debugPrint('Initializing Repository...');
      await _taskRepository.init();

      debugPrint('Loading tasks...');
      await loadTasks();

      _isInitialized = true;
      debugPrint(
        'TaskProvider initialized successfully. Tasks loaded: ${_tasks.length}',
      );
    } catch (e) {
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTasks({bool forceRefresh = false}) async {
    try {
      _clearError();
      if (!forceRefresh) _setLoading(true);

      final loadedTasks = await _taskRepository.getAllTasks();
      debugPrint("Tasks loaded: ${loadedTasks.length}");
      _tasks = loadedTasks;
      notifyListeners();
    } catch (e) {
      debugPrint("Error in loadTasks $e");
      _setError('Failed to load tasks: $e');
    } finally {
      if (!forceRefresh) _setLoading(false);
    }
  }

  // Refresh from server
  Future<void> refresh() async {
    await loadTasks(forceRefresh: true);
  }

  Future<void> addTask(String title, String description) async {
    try {
      final newTask = await _taskRepository.addTask(
        Task(title: title, description: description, status: 'pendiente'),
      );
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      debugPrint("Error in addTask $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((element) => element.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in updateTask $e");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      _clearError();
      _setLoading(true);

      await _taskRepository.deleteTask(id);

      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error in deleteTask $e");
      _setError("Error in deleteTask $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      debugPrint('Loading state changed: $loading');
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    debugPrint("Error set: $error");
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      debugPrint("Error cleared");
      notifyListeners();
    }
  }
}
