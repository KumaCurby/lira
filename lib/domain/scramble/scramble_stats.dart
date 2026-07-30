import '../measure/reading_session.dart';

/// LR10 — Vitesse de lecture « normale » de référence, pour situer la vitesse
/// obtenue en lecture mélangée (typoglycémie).
///
/// C'est la moyenne des sessions de lecture chronométrée « classiques »
/// (on écarte les exercices aidés — « mots mélangés », « mots-clés » — et les
/// sessions sans vitesse mesurée,
/// comme les tables de Schulte). Si aucune donnée n'est disponible, on retombe
/// sur [fallback] (typiquement la vitesse par défaut des réglages).
int referenceReadingWpm(
  List<ReadingSession> sessions, {
  required int fallback,
}) {
  final normal = sessions
      .where(
        (s) =>
            s.type != ExerciseType.scramble &&
            s.type != ExerciseType.wordScramble &&
            s.type != ExerciseType.keywords &&
            s.wpm > 0,
      )
      .toList();
  if (normal.isEmpty) return fallback;
  final total = normal.fold<int>(0, (sum, s) => sum + s.wpm);
  return (total / normal.length).round();
}
