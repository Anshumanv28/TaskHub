import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import '../widgets/custom_button.dart';
import '../utils/validators.dart';
import 'task_model.dart';
import 'task_provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task _currentTask;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _titleController = TextEditingController(text: _currentTask.title);
    _descriptionController = TextEditingController(
      text: _currentTask.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final success = await taskProvider.updateTask(
      taskId: _currentTask.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _isEditing = false;
        _currentTask = taskProvider.tasks.firstWhere(
          (t) => t.id == _currentTask.id,
        );
        _titleController.text = _currentTask.title;
        _descriptionController.text = _currentTask.description ?? '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            taskProvider.error ?? 'Failed to update task',
            style: const TextStyle(color: AppTheme.textWhiteColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final success = await taskProvider.deleteTask(_currentTask.id);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taskProvider.error ?? 'Failed to delete task',
              style: const TextStyle(color: AppTheme.textWhiteColor),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleToggleStatus() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final success = await taskProvider.toggleTaskStatus(_currentTask.id);

    if (!mounted) return;

    if (success) {
      setState(() {
        _currentTask = taskProvider.tasks.firstWhere(
          (t) => t.id == _currentTask.id,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'Edit',
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _handleDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Toggle
              Card(
                color:
                    AppTheme.inputFieldBgColor, // 455A64 - match input field bg
                child: SwitchListTile(
                  title: Text(
                    'Status',
                    style: TextStyle(color: AppTheme.textWhiteColor),
                  ),
                  subtitle: Text(
                    _currentTask.isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: AppTheme
                          .buttonBgColor, // FED36A - button bg / app yellow
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: _currentTask.isCompleted,
                  onChanged: _isEditing
                      ? null
                      : (value) => _handleToggleStatus(),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'Title',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textDarkColor,
                ),
              ),
              const SizedBox(height: 8),
              _isEditing
                  ? TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: AppTheme.textWhiteColor),
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        hintStyle: const TextStyle(
                          color: AppTheme.textDarkColor,
                        ),
                        filled: true,
                        fillColor: AppTheme.inputFieldBgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero, // Square corners
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.buttonBgColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) =>
                          Validators.required(value, fieldName: 'Task title'),
                      textCapitalization: TextCapitalization.sentences,
                    )
                  : Card(
                      color: AppTheme
                          .inputFieldBgColor, // 455A64 - match input field bg
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _currentTask.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppTheme.textWhiteColor),
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textDarkColor,
                ),
              ),
              const SizedBox(height: 8),
              _isEditing
                  ? TextFormField(
                      controller: _descriptionController,
                      style: const TextStyle(color: AppTheme.textWhiteColor),
                      decoration: InputDecoration(
                        hintText: 'Enter task description (optional)',
                        hintStyle: const TextStyle(
                          color: AppTheme.textDarkColor,
                        ),
                        filled: true,
                        fillColor: AppTheme.inputFieldBgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero, // Square corners
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: AppTheme.buttonBgColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                    )
                  : Card(
                      color: AppTheme
                          .inputFieldBgColor, // 455A64 - match input field bg
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _currentTask.description ?? 'No description',
                          style: _currentTask.description == null
                              ? Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textDarkColor,
                                )
                              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textWhiteColor,
                                ),
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
              // Created Date
              Text(
                'Created',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textDarkColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color:
                    AppTheme.inputFieldBgColor, // 455A64 - match input field bg
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _formatDate(_currentTask.createdAt),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textWhiteColor,
                    ),
                  ),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 32),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, _) {
                    return CustomButton(
                      text: 'Save Changes',
                      isLoading: taskProvider.isLoading,
                      onPressed: _handleUpdate,
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _titleController.text = _currentTask.title;
                      _descriptionController.text =
                          _currentTask.description ?? '';
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textDarkColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
