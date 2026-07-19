import '../measure/reading_session.dart';

/// Historique des sessions de lecture/exercice, source du suivi de progression.
abstract class SessionRepository {
  /// Toutes les sessions enregistrées.
  Future<List<ReadingSession>> all();

  /// Ajoute une session à l'historique.
  Future<void> add(ReadingSession session);

  /// Efface tout l'historique.
  Future<void> clear();
}
