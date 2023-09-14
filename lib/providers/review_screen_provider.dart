import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_voc/services/database_service.dart';

import '../models/entry.dart';

class ReviewScreenProvider extends ChangeNotifier {
  late final List<String> _alphabet;

  final List<Entry> _forReview = [];
  List<Entry> get forReview => _forReview;

  final DatabaseService _databaseService;

  final HashMap<int, bool> _results = HashMap();
  HashMap<int, bool> get results => _results;

  ReviewScreenProvider(this._databaseService) {
    _alphabet = List.generate(
        26, (index) => String.fromCharCode('a'.codeUnitAt(0) + index));
  }

  Future<void> load() async {
    var entries = await _databaseService.getAll();

    for (var entry in entries) {
      var diff = 12 - entry.word.length;
      if (diff > 0) {
        _alphabet.shuffle(Random());
        entry.shuffled.addAll(_alphabet.take(diff));
      }
      entry.shuffled.addAll(entry.word.split(''));
      entry.shuffled.shuffle(Random());
    }

    _forReview.addAll(entries);
    notifyListeners();
  }
}
