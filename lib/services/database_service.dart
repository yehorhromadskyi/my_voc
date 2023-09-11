import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/entry.dart';

class DatabaseService {
  Isar? _isar;

  Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([EntrySchema], directory: dir.path);
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
