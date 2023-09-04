import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/entry.dart';

class SearchHistoryProvider extends ChangeNotifier {
  final List<Entry> _history = [];

  List<Entry> get history => _history;

  Isar? _isar;

  Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([EntrySchema], directory: dir.path);
    }
  }

  Future<void> add(Entry record) async {
    await init();

    var existing =
        await _isar!.entrys.where().filter().wordEqualTo(record.word).findAll();

    if (existing.isEmpty) {
      await _isar!.writeTxn(() async {
        await _isar!.entrys.put(record);
      });

      _history.add(record);
      notifyListeners();
    }
  }

  Future<void> remove(Entry entry) async {
    await init();

    _history.remove(entry);
    notifyListeners();

    await _isar!.writeTxn(() async {
      final success = await _isar!.entrys.delete(entry.id);
    });
  }

  Future<void> loadHistory() async {
    await init();

    var entries = await _isar!.entrys.where().findAll();

    _history.addAll(entries);

    notifyListeners();
  }
}
