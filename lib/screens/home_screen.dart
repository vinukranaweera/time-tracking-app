import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../provider/time_entry_provider.dart';
import '../provider/project_task_provider.dart';
import 'package:collection/collection.dart';
// import '../models/task.dart';
// import '../models/project.dart';
// import '../screens/project_management_screen.dart';
// import '../screens/task_management_screen.dart';
import 'time_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracking'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.yellowAccent[700],
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'All Entries'),
            Tab(text: 'Grouped By Projects'),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Colors.grey[900]),
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.grey[900]),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllEntries(timeEntryProvider, projectTaskProvider),
          _buildEntriesGroupedByProject(timeEntryProvider, projectTaskProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent[700],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTimeEntryScreen()),
          );
        },
        tooltip: 'Add Time Entry',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllEntries(
    TimeEntryProvider provider,
    ProjectTaskProvider taskProvider,
  ) {
    final entries = provider.entries;

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // keeps content centered
          children: <Widget>[
            Icon(Icons.hourglass_empty, color: Colors.grey[400], size: 100.0),
            SizedBox(height: 8),
            Text(
              'No time entries yet!',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first entry.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final formattedDate =
            "${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}-${entry.date.year}";

        // NEW: Lookup names using IDs
        final project = taskProvider.projects.firstWhereOrNull(
          (p) => p.id == entry.projectId,
        );

        final task = taskProvider.tasks.firstWhereOrNull(
          (t) => t.id == entry.taskId,
        );

        final projectName = project?.name ?? entry.projectId;
        final taskName = task?.name ?? entry.taskId;

        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            title: Text(
              '$projectName - $taskName',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.teal[800],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(
                  'Total Time: ${entry.totalTime} hrs',
                  style: TextStyle(color: Colors.grey[850]),
                ),
                Text(
                  'Date: $formattedDate',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Notes: ${entry.notes.isNotEmpty ? entry.notes : "—"}',
                  style: TextStyle(color: Colors.grey[850]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: () => provider.deleteTimeEntry(entry.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEntriesGroupedByProject(
    TimeEntryProvider provider,
    ProjectTaskProvider taskProvider,
  ) {
    final entries = provider.entries;

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.hourglass_empty, color: Colors.grey[400], size: 100.0),
            SizedBox(height: 8),
            Text(
              'No time entries yet!',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first entry.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    // Group entries by projectId using the collection package
    final grouped = groupBy(entries, (TimeEntry e) => e.projectId);

    return ListView(
      children: grouped.entries.map((entryGroup) {
        final projectId = entryGroup.key;
        final projectEntries = entryGroup.value;

        final project = taskProvider.projects.firstWhereOrNull(
          (p) => p.id == projectId,
        );
        final projectName = project?.name ?? projectId;

        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 8),
                ...projectEntries.map((entry) {
                  final task = taskProvider.tasks.firstWhereOrNull(
                    (t) => t.id == entry.taskId,
                  );
                  final taskName = task?.name ?? entry.taskId;
                  final formattedDate =
                      "${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}-${entry.date.year}";

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '– $taskName: ${entry.totalTime} hrs ($formattedDate)',
                          style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        // if (entry.notes.isNotEmpty)
                        //     Padding(
                        //     padding: const EdgeInsets.only(top: 2.0),
                        //     child: Text(
                        //         entry.notes,
                        //         style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        //     ),
                        //     ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
