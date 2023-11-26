import 'package:my_voc/models/card.dart';

class IntroductionCard extends Card {
  String definition;
  List<String> examples;

  IntroductionCard(
      super.word, super.cachedPronunciation, this.definition, this.examples);
}
