import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../provider/project_task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      backgroundColor: Colors.white,
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Task Name',
          labelStyle: TextStyle(
            color: Colors.blue, // Sets the label text color to blue
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.blue)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            final input = _controller.text.trim();
            if (input.isEmpty) return;

            final newTask = Task(id: input, name: input);
            widget.onAdd(newTask);
            // Update the provider and UI
            Provider.of<ProjectTaskProvider>(
              context,
              listen: false,
            ).addTask(newTask);
            // Clear the input field for next input
            _controller.clear();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
