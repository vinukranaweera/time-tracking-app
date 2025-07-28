import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import '../models/project.dart';
import '../models/task.dart';
import 'dart:convert';

class ProjectTaskProvider with ChangeNotifier {
  final LocalStorage storage;

  // List of projects
  List<Project> _projects = [
    Project(id: '1', name: 'Project Alpha', isDefault: true),
    Project(id: '2', name: 'Project Beta', isDefault: true),
    Project(id: '3', name: 'Project Gamma', isDefault: true),
  ];

  // List of tasks
  List<Task> _tasks = [
    Task(id: '1', name: 'Task A'),
    Task(id: '2', name: 'Task B'),
    Task(id: '3', name: 'Task C'),
  ];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  ProjectTaskProvider(this.storage) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    // await storage.ready;
    await _loadProjectsFromStorage();
    await _loadTasksFromStorage();
    notifyListeners();
  }

  Future<void> _loadProjectsFromStorage() async {
    var storedProjects = storage.getItem('projects');

    if (storedProjects != null) {
      _projects = List<Project>.from(
        (jsonDecode(storedProjects) as List).map(
          (item) => Project.fromJson(item),
        ),
      );
    } else {
      // Save default projects to storage
      _saveProjectsToStorage();
    }
  }

  Future<void> _loadTasksFromStorage() async {
    var storedTasks = storage.getItem('tasks');

    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (jsonDecode(storedTasks) as List).map((item) => Task.fromJson(item)),
      );
    } else {
      // Save default tasks to storage
      _saveTasksToStorage();
    }
  }

  // Add a Project
  void addProject(Project project) {
    if (!_projects.any((proj) => proj.name == project.name)) {
      _projects.add(project);
      notifyListeners();
    }
  }

  // Add a task
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  void _saveProjectsToStorage() {
    storage.setItem(
      'projects',
      jsonEncode(_projects.map((e) => e.toJson()).toList()),
    );
  }

  void _saveTasksToStorage() {
    storage.setItem(
      'tasks',
      jsonEncode(_tasks.map((e) => e.toJson()).toList()),
    );
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }
}
