import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/text_repository.dart';
import '../../domain/text/reading_text.dart';
import '../mappers/reading_text_mapper.dart';

/// Dépôt de textes combinant le corpus intégré (lecture seule) et les textes
/// importés par l'utilisateur (persistés dans `shared_preferences`).
class LocalTextRepository implements TextRepository {
  LocalTextRepository({
    required List<ReadingText> corpus,
    required SharedPreferences prefs,
  }) : _corpus = corpus,
       _prefs = prefs;

  final List<ReadingText> _corpus;
  final SharedPreferences _prefs;
  static const String _key = 'user_texts.v1';

  @override
  Future<List<ReadingText>> all() async => [..._corpus, ..._userTexts()];

  @override
  Future<ReadingText?> byId(String id) async {
    for (final text in await all()) {
      if (text.id == id) return text;
    }
    return null;
  }

  @override
  Future<void> save(ReadingText text) async {
    final userTexts = _userTexts()..removeWhere((t) => t.id == text.id);
    userTexts.add(text);
    await _persist(userTexts);
  }

  @override
  Future<void> delete(String id) async {
    final userTexts = _userTexts()..removeWhere((t) => t.id == id);
    await _persist(userTexts);
  }

  @override
  Future<void> deleteAll(Iterable<String> ids) async {
    final set = ids.toSet();
    final userTexts = _userTexts()..removeWhere((t) => set.contains(t.id));
    await _persist(userTexts);
  }

  List<ReadingText> _userTexts() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => readingTextFromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _persist(List<ReadingText> texts) async {
    await _prefs.setString(
      _key,
      jsonEncode(texts.map(readingTextToJson).toList()),
    );
  }
}
