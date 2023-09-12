import 'dart:async';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Isar? _isar;

  Completer? _completer;

  Future<void> init() async {
    if (_completer != null) {
      await _completer!.future;
    }

    if (_completer == null) {
      _completer = Completer();
    }

    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([EntrySchema], directory: dir.path);

      if (!_completer!.isCompleted) {
        _completer!.complete();
      }
    }
  }

  Future<List<Entry>> get(String word) async {
    await init();

    var existing =
        await _isar!.entrys.where().filter().wordEqualTo(word).findAll();

    return existing;
  }

  Future<void> add(Entry record) async {
    await init();

    await _isar!.writeTxn(() async {
      await _isar!.entrys.put(record);
    });
  }

  Future<bool> remove(Entry entry) async {
    await init();

    bool success = false;

    await _isar!.writeTxn(() async {
      success = await _isar!.entrys.delete(entry.id);
    });

    return success;
  }

  Future<List<Entry>> getAll() async {
    await init();

    var entries = await _isar!.entrys.where().findAll();

    return entries;
  }
}
