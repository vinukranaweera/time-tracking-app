import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../provider/project_task_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  AddProjectDialog({required this.onAdd});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Project'),
      backgroundColor: Colors.white,
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Project Name',
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

            final newProject = Project(id: input, name: input);
            widget.onAdd(newProject);
            Provider.of<ProjectTaskProvider>(
              context,
              listen: false,
            ).addProject(newProject);
            _controller.clear(); // Clear the input field
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
