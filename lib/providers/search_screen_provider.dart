import 'package:flutter/material.dart';
import 'package:my_voc/services/database_service.dart';

import '../models/entry.dart';
import '../services/api_service.dart';

class SearchScreenProvider extends ChangeNotifier {
  final List<Entry> _history = [];
  List<Entry> get history => _history;

  Entry? _selectedEntry;
  Entry? get selectedEntry => _selectedEntry;
  set selectedEntry(Entry? entry) {
    _selectedEntry = entry;
    notifyListeners();
  }

  final DatabaseService _databaseService;
  final ApiService _apiService;

  SearchScreenProvider(this._databaseService, this._apiService);

  Future<Entry> get(String word) async {
    var existing = await _databaseService.get(word);

    if (existing.isEmpty) {
      var entry = await _apiService.getEntry(word);
      existing.add(entry);
      add(entry);
    }

    return existing.first;
  }

  Future<void> add(Entry entry) async {
    await _databaseService.add(entry);

    _history.insert(0, entry);
    notifyListeners();
  }

  Future<void> remove(Entry entry) async {
    bool success = await _databaseService.remove(entry);

    if (success) {
      _history.remove(entry);
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    var entries = await _databaseService.getAll();

    _history.addAll(entries.reversed);
    notifyListeners();
  }
}
