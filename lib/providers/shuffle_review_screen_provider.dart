import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_voc/services/database_service.dart';

import '../models/entry.dart';

class ShuffleReviewScreenProvider extends ChangeNotifier {
  final List<Entry> _forReview = [];
  List<Entry> get forReview => _forReview;

  final DatabaseService _databaseService;

  final HashMap<int, bool> _results = HashMap();
  HashMap<int, bool> get results => _results;

  double progress = 0.0;

  ShuffleReviewScreenProvider(this._databaseService) {}

  Future<void> load() async {
    var entries = await _databaseService.getAll();
    for (var entry in entries) {
      entry.shuffled.shuffle(Random());
    }

    _forReview.addAll(entries);

    notifyListeners();
  }

  void check(int index) {
    results[index] = forReview[index].guess.join().toLowerCase() ==
        forReview[index].word.toLowerCase();
    progress = (index + 1) / forReview.length;

    notifyListeners();
  }
}
