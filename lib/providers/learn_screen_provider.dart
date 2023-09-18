import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/entry.dart';
import '../services/database_service.dart';

class LearnScreenProvider extends ChangeNotifier {
  final DatabaseService _databaseService;

  AudioPlayer _player = AudioPlayer();

  final List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  LearnScreenProvider(this._databaseService);

  Future<void> load() async {
    var entries = await _databaseService.getAll();

    _entries.addAll(entries);
    play(0);

    notifyListeners();
  }

  Future<void> play(int index) async {
    await _player.setFilePath(entries[index].cachedPronunciation!);
    _player.play();
  }
}
