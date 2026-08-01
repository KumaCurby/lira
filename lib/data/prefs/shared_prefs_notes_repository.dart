import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/notes/text_note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../mappers/text_note_mapper.dart';

/// Notes persistées via `shared_preferences` (cross-platform).
class SharedPrefsNotesRepository implements NotesRepository {
  SharedPrefsNotesRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'notes.v1';

  @override
  Future<List<TextNote>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final notes =
        list.map((e) => textNoteFromJson(e as Map<String, dynamic>)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<List<TextNote>> forText(String textId) async {
    final notes = await all();
    return notes.where((n) => n.textId == textId).toList();
  }

  @override
  Future<void> upsert(TextNote note) async {
    final notes = await all();
    notes.removeWhere((n) => n.id == note.id);
    notes.add(note);
    await _save(notes);
  }

  @override
  Future<void> remove(String id) async {
    final notes = await all();
    notes.removeWhere((n) => n.id == id);
    await _save(notes);
  }

  @override
  Future<void> clear() async => _prefs.remove(_key);

  Future<void> _save(List<TextNote> notes) =>
      _prefs.setString(_key, jsonEncode(notes.map(textNoteToJson).toList()));
}
