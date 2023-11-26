import 'package:my_voc/models/card.dart';

class ShadowTypingCard extends Card {
  String definition;

  ShadowTypingCard(super.word, super.cachedPronunciation, this.definition);
}
