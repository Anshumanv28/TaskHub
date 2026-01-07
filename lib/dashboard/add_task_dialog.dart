import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../app/theme.dart';
import 'task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final success = await taskProvider.addTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            taskProvider.error ?? 'Failed to create task',
            style: const TextStyle(color: AppTheme.textWhiteColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.pageBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create New Task',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textWhiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                // Task Title label
                Text(
                  'Task Title',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDarkColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: AppTheme.textWhiteColor),
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    hintStyle: const TextStyle(color: AppTheme.textDarkColor),
                    filled: true,
                    fillColor: AppTheme.inputFieldBgColor,
                    prefixIcon: const Icon(
                      Icons.title,
                      color: AppTheme.textWhiteColor,
                    ),
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
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                // Description label
                Text(
                  'Description (Optional)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textDarkColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: AppTheme.textWhiteColor),
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    hintStyle: const TextStyle(color: AppTheme.textDarkColor),
                    filled: true,
                    fillColor: AppTheme.inputFieldBgColor,
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: AppTheme.textWhiteColor,
                    ),
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
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, _) {
                    return CustomButton(
                      text: 'Create Task',
                      isLoading: taskProvider.isLoading,
                      onPressed: _handleSubmit,
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textDarkColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
