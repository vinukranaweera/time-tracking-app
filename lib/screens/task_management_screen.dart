import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/project_task_provider.dart';
import '../dialogs/add_task_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final tasks = provider.tasks[index];
              return ListTile(
                title: Text(tasks.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteTask(tasks.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent[700],
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newTask) {
                Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                ).addTask(newTask);
                Navigator.pop(
                  context,
                ); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
