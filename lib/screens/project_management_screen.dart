import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/project_task_provider.dart';
import '../dialogs/add_project_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final projects = provider.projects[index];
              return ListTile(
                title: Text(projects.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteProject(projects.id);
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
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<ProjectTaskProvider>(
                  context,
                  listen: false,
                ).addProject(newProject);
                Navigator.pop(
                  context,
                ); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add New Project',
        child: Icon(Icons.add),
      ),
    );
  }
}
