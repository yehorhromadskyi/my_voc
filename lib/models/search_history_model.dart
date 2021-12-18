import 'package:flutter/material.dart';

class SearchHistoryModel extends ChangeNotifier {
  final List<String> _history = [];

  List<String> get history => _history;

  void add(String record) {
    history.add(record);

    notifyListeners();
  }

  void remove(String record) {
    history.remove(record);

    notifyListeners();
  }
}
