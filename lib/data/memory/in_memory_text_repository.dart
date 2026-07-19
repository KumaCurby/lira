import '../../domain/repositories/text_repository.dart';
import '../../domain/text/reading_text.dart';

/// Dépôt de textes en mémoire (tests, prévisualisation, démarrage rapide).
class InMemoryTextRepository implements TextRepository {
  InMemoryTextRepository([List<ReadingText> seed = const []])
    : _texts = [...seed];

  final List<ReadingText> _texts;

  @override
  Future<List<ReadingText>> all() async => List.unmodifiable(_texts);

  @override
  Future<ReadingText?> byId(String id) async {
    for (final text in _texts) {
      if (text.id == id) return text;
    }
    return null;
  }

  @override
  Future<void> save(ReadingText text) async {
    _texts.removeWhere((t) => t.id == text.id);
    _texts.add(text);
  }

  @override
  Future<void> delete(String id) async => _texts.removeWhere((t) => t.id == id);

  @override
  Future<void> deleteAll(Iterable<String> ids) async {
    final set = ids.toSet();
    _texts.removeWhere((t) => set.contains(t.id));
  }
}
