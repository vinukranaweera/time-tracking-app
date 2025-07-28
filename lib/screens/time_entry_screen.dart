import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../provider/time_entry_provider.dart';
import '../provider/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _projectId;
  String? _taskId;
  double _totalTime = 0.0;
  DateTime _date = DateTime.now();
  String _notes = '';

  final TextEditingController _totalTimeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _totalTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<ProjectTaskProvider>(context).projects;
    final tasks = Provider.of<ProjectTaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _projectId,
                items: projects.map((p) {
                  return DropdownMenuItem(value: p.id, child: Text(p.name));
                }).toList(),
                onChanged: (val) => setState(() => _projectId = val),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) => value == null ? 'Select a project' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _taskId,
                items: tasks.map((t) {
                  return DropdownMenuItem(value: t.id, child: Text(t.name));
                }).toList(),
                onChanged: (val) => setState(() => _taskId = val),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) => value == null ? 'Select a task' : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Date: ${_date.toLocal().toString().split(' ')[0]}',
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _pickDate,
                  child: const Text(
                    'Select Date',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              TextFormField(
                controller: _totalTimeController,
                decoration: const InputDecoration(
                  labelText: 'Total Time (hours)',
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter time';
                  if (double.tryParse(value) == null)
                    return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: _saveTimeEntry,
                child: const Text(
                  'Save Time Entry',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _saveTimeEntry() {
    if (_formKey.currentState!.validate()) {
      _totalTime = double.parse(_totalTimeController.text);
      _notes = _noteController.text;

      final timeEntry = TimeEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: _projectId!,
        taskId: _taskId!,
        totalTime: _totalTime,
        date: _date,
        notes: _notes,
      );

      Provider.of<TimeEntryProvider>(
        context,
        listen: false,
      ).addTimeEntry(timeEntry);
      Navigator.pop(context);
    }
  }
}
