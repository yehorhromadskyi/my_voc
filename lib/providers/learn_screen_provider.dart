import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_voc/models/introduction_card.dart';
import 'package:my_voc/models/multiple_options_card.dart';

import '../models/card.dart' as models;
import '../services/database_service.dart';

class LearnScreenProvider extends ChangeNotifier {
  final DatabaseService _databaseService;

  AudioPlayer _player = AudioPlayer();

  final List<models.Card> _cards = [];
  List<models.Card> get cards => _cards;

  LearnScreenProvider(this._databaseService);

  Future<void> load() async {
    var entries = await _databaseService.getAll();

    _cards.addAll(entries.map((e) {
      if (e.word == 'car')
        return IntroductionCard(e.word, e.cachedPronunciation, e.definition);
      else
        return MultipleOptionsCard(e.word, e.cachedPronunciation);
    }));

    play(0);

    notifyListeners();
  }

  Future<void> play(int index) async {
    await _player.setFilePath(cards[index].cachedPronunciation!);
    _player.play();
  }
}
