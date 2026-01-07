import 'package:flutter/foundation.dart';
import 'task_model.dart';
import '../services/supabase_service.dart';

class TaskProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  bool _isSubscribed = false;

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

      // Subscribe to realtime updates if not already subscribed
      if (!_isSubscribed) {
        _subscribeToRealtimeUpdates();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void _subscribeToRealtimeUpdates() {
    try {
      _supabaseService.subscribeToTasks(
        onInsert: (payload) {
          try {
            final newTask = Task.fromJson(payload.newRecord);
            // Check if task already exists (avoid duplicates)
            if (!_tasks.any((task) => task.id == newTask.id)) {
              _tasks.insert(0, newTask);
              notifyListeners();
            }
          } catch (e) {
            debugPrint('Error handling realtime insert: $e');
          }
        },
        onUpdate: (payload) {
          try {
            final updatedTask = Task.fromJson(payload.newRecord);
            final index = _tasks.indexWhere(
              (task) => task.id == updatedTask.id,
            );
            if (index != -1) {
              _tasks[index] = updatedTask;
              notifyListeners();
            }
          } catch (e) {
            debugPrint('Error handling realtime update: $e');
          }
        },
        onDelete: (payload) {
          try {
            final deletedId = payload.oldRecord['id'] as String;
            _tasks.removeWhere((task) => task.id == deletedId);
            notifyListeners();
          } catch (e) {
            debugPrint('Error handling realtime delete: $e');
          }
        },
      );
      _isSubscribed = true;
    } catch (e) {
      debugPrint('Error subscribing to realtime updates: $e');
    }
  }

  void unsubscribeFromRealtimeUpdates() {
    _supabaseService.unsubscribeFromTasks();
    _isSubscribed = false;
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

  @override
  void dispose() {
    unsubscribeFromRealtimeUpdates();
    super.dispose();
  }
}
