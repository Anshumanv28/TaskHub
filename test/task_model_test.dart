import 'package:flutter_test/flutter_test.dart';
import 'package:taskhub/dashboard/task_model.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should be created from JSON correctly', () {
      final json = {
        'id': '123',
        'user_id': 'user-123',
        'title': 'Test Task',
        'description': 'Test Description',
        'status': 'pending',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final task = Task.fromJson(json);

      expect(task.id, '123');
      expect(task.userId, 'user-123');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.status, 'pending');
      expect(task.isCompleted, false);
    });

    test('Task should convert to JSON correctly', () {
      final task = Task(
        id: '123',
        userId: 'user-123',
        title: 'Test Task',
        description: 'Test Description',
        status: 'pending',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final json = task.toJson();

      expect(json['id'], '123');
      expect(json['user_id'], 'user-123');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['status'], 'pending');
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-01-01T00:00:00.000Z');
    });

    test('Task copyWith should create a new task with updated fields', () {
      final originalTask = Task(
        id: '123',
        userId: 'user-123',
        title: 'Original Task',
        description: 'Original Description',
        status: 'pending',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated Task',
        status: 'completed',
      );

      expect(updatedTask.id, '123');
      expect(updatedTask.userId, 'user-123');
      expect(updatedTask.title, 'Updated Task');
      expect(updatedTask.description, 'Original Description');
      expect(updatedTask.status, 'completed');
      expect(updatedTask.isCompleted, true);
      expect(originalTask.title, 'Original Task'); // Original unchanged
    });

    test('Task isCompleted should return true for completed status', () {
      final pendingTask = Task(
        id: '1',
        userId: 'user-1',
        title: 'Pending Task',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final completedTask = Task(
        id: '2',
        userId: 'user-1',
        title: 'Completed Task',
        status: 'completed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(pendingTask.isCompleted, false);
      expect(completedTask.isCompleted, true);
    });

    test('Task should handle null description', () {
      final json = {
        'id': '123',
        'user_id': 'user-123',
        'title': 'Test Task',
        'description': null,
        'status': 'pending',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final task = Task.fromJson(json);

      expect(task.description, null);
    });
  });
}
