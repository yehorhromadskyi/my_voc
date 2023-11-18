import 'package:isar/isar.dart';

part 'entry.g.dart';

@collection
class Entry {
  Id id = Isar.autoIncrement;

  String word;
  String definition;
  String pronunciation;
  List<String> examples;

  String? cachedPronunciation;

  @ignore
  late List<String> guess;
  @ignore
  late List<int> sequence;
  @ignore
  late List<String> shuffled;

  Entry(
      {required this.word,
      required this.definition,
      required this.pronunciation,
      required this.examples}) {
    guess = List.filled(word.length, '');
    shuffled = word.split('');
    sequence = List.empty(growable: true);
  }
}
