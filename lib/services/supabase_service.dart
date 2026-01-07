import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;
  RealtimeChannel? _tasksChannel;

  // Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Get current user ID
  String? get currentUserId => currentUser?.id;

  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<bool> signInWithGoogle() async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.taskhub://login-callback/',
        // Use in-app webview instead of external browser for better redirect handling
        authScreenLaunchMode: LaunchMode.inAppWebView,
      );
      return true;
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Task methods
  Future<List<Task>> getTasks() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Task> createTask({required String title, String? description}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now().toIso8601String();
    final response = await client
        .from('tasks')
        .insert({
          'user_id': userId,
          'title': title,
          'description': description,
          'status': 'pending',
          'created_at': now,
          'updated_at': now,
        })
        .select()
        .single();

    return Task.fromJson(response);
  }

  Future<Task> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? status,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (status != null) updates['status'] = status;

    final response = await client
        .from('tasks')
        .update(updates)
        .eq('id', taskId)
        .eq('user_id', userId)
        .select()
        .single();

    return Task.fromJson(response);
  }

  Future<void> deleteTask(String taskId) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await client.from('tasks').delete().eq('id', taskId).eq('user_id', userId);
  }

  Future<Task> toggleTaskStatus(String taskId) async {
    final tasks = await getTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == 'completed' ? 'pending' : 'completed';
    return await updateTask(taskId: taskId, status: newStatus);
  }

  // Realtime subscription methods
  void subscribeToTasks({
    required Function(PostgresChangePayload) onInsert,
    required Function(PostgresChangePayload) onUpdate,
    required Function(PostgresChangePayload) onDelete,
  }) {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Unsubscribe from existing channel if any
    unsubscribeFromTasks();

    // Create new channel for tasks
    _tasksChannel = client
        .channel('tasks_channel_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: onInsert,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: onUpdate,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: onDelete,
        )
        .subscribe();
  }

  void unsubscribeFromTasks() {
    if (_tasksChannel != null) {
      _tasksChannel!.unsubscribe();
      _tasksChannel = null;
    }
  }
}
