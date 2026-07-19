import '../progress/reading_progress.dart';

/// Persistance de la progression de lecture, indexée par identifiant de texte.
abstract class ProgressRepository {
  /// Toutes les progressions connues (textId → progression).
  Future<Map<String, ReadingProgress>> all();

  /// Enregistre (ou remplace) la progression d'un texte.
  Future<void> save(ReadingProgress progress);

  /// Efface toute la progression.
  Future<void> clear();
}
