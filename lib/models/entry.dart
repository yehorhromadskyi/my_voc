import 'package:isar/isar.dart';

part 'entry.g.dart';

@collection
class Entry {
  Id id = Isar.autoIncrement;

  String word;
  String definition;
  String pronunciation;

  Entry(
      {required this.word,
      required this.definition,
      required this.pronunciation});
  }
