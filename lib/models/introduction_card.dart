import 'package:my_voc/models/card.dart';

class IntroductionCard extends Card {
  String definition;

  IntroductionCard(super.word, super.cachedPronunciation, this.definition);
}
