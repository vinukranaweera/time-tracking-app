import 'package:flutter/material.dart';
import '../models/time_entry.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  TimeEntryProvider(this.storage) {
    _initStorage();
    _loadTimeEntryFromStorage();
  }

  Future<void> _initStorage() async {
    // await storage.ready;
    final stored = storage.getItem('timeEntries');

    if (stored == null) {
      storage.setItem('timeEntries', jsonEncode([]));
      _entries = [];
    } else {
      try {
        List<dynamic> decoded = jsonDecode(stored);
        _entries = decoded.map((e) => TimeEntry.fromJson(e)).toList();
      } catch (e) {
        print('Failed to decode timeEntries: $e');
        _entries = [];
      }
    }
    notifyListeners();
  }

  void _loadTimeEntryFromStorage() {
    var storedEntries = storage.getItem('timeEntries');

    if (storedEntries != null) {
      final List decoded = jsonDecode(storedEntries); // String -> List
      _entries = decoded.map((item) => TimeEntry.fromJson(item)).toList();
    } else {
      storage.setItem('timeEntries', jsonEncode([])); // Initialize empty list
      _entries = [];
    }

    notifyListeners();
  }

  void _saveTimeEntryToStorage() {
    final encoded = jsonEncode(_entries.map((e) => e.toJson()).toList());
    storage.setItem('timeEntries', encoded);
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntryToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryToStorage();
    notifyListeners();
  }
}
