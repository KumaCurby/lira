import '../../domain/notes/text_note.dart';
import '../../domain/repositories/notes_repository.dart';

class InMemoryNotesRepository implements NotesRepository {
  final List<TextNote> _notes = [];

  @override
  Future<List<TextNote>> all() async {
    final sorted = [..._notes]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<List<TextNote>> forText(String textId) async {
    final all = await this.all();
    return all.where((n) => n.textId == textId).toList();
  }

  @override
  Future<void> upsert(TextNote note) async {
    _notes.removeWhere((n) => n.id == note.id);
    _notes.add(note);
  }

  @override
  Future<void> remove(String id) async {
    _notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> clear() async => _notes.clear();
}
