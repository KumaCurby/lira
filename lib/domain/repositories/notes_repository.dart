import '../notes/text_note.dart';

/// LR16 — Stockage des notes personnelles liées aux textes lus.
abstract class NotesRepository {
  /// Toutes les notes, du plus récent au plus ancien.
  Future<List<TextNote>> all();

  /// Notes attachées à un texte donné.
  Future<List<TextNote>> forText(String textId);

  /// Ajoute ou remplace la note par son id.
  Future<void> upsert(TextNote note);

  /// Supprime la note par id.
  Future<void> remove(String id);

  /// Supprime toutes les notes.
  Future<void> clear();
}
