import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/text/reading_text.dart';
import '../mappers/reading_text_mapper.dart';

/// Chemin de l'asset du corpus intégré.
const String corpusAssetPath = 'assets/corpus/corpus_fr.json';

/// Transforme le contenu JSON du corpus en liste de [ReadingText] (builtin).
List<ReadingText> parseCorpus(String jsonString) {
  final list = jsonDecode(jsonString) as List;
  return list
      .map((e) => readingTextFromJson(e as Map<String, dynamic>))
      .toList();
}

/// Charge le corpus FR intégré depuis les assets de l'application.
Future<List<ReadingText>> loadBuiltinCorpus() async {
  final jsonString = await rootBundle.loadString(corpusAssetPath);
  return parseCorpus(jsonString);
}
