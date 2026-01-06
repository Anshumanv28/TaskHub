import 'package:flutter/foundation.dart';
import 'task_model.dart';
import '../services/supabase_service.dart';

class TaskProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.status == 'pending').toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == 'completed').toList();

  Future<void> loadTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _tasks = await _supabaseService.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask({required String title, String? description}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newTask = await _supabaseService.createTask(
        title: title,
        description: description,
      );

      _tasks.insert(0, newTask);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? status,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedTask = await _supabaseService.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        status: status,
      );

      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Optimistically remove task from list (for Dismissible widget)
  void removeTaskOptimistically(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabaseService.deleteTask(taskId);
      // Task already removed optimistically, just update loading state
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTaskStatus(String taskId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedTask = await _supabaseService.toggleTaskStatus(taskId);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
