import 'effective_wpm.dart' as measure;

/// Famille d'exercice réalisée dans une session.
enum ExerciseType {
  speedTest,
  rsvp,
  pacer,
  skimming,
  scanning,
  schulte,
  scramble,
  wordScramble,
  keywords,
  columns,
  noSubvocal,
}

/// LR2 — Trace d'une session de lecture/exercice mesurée.
///
/// Objet-valeur alimentant le suivi de progression (LR9) et la persistance
/// (Phase 1). [comprehension] et [textId] sont optionnels (certains exercices
/// n'ont pas de quiz ni de texte associé).
class ReadingSession {
  const ReadingSession({
    required this.type,
    required this.wordCount,
    required this.elapsed,
    required this.wpm,
    required this.date,
    this.comprehension,
    this.textId,
  });

  final ExerciseType type;
  final int wordCount;
  final Duration elapsed;
  final int wpm;
  final DateTime date;
  final double? comprehension;
  final String? textId;

  /// mpm effective si un quiz de compréhension a été passé, sinon `null`.
  int? get effectiveWpm => comprehension == null
      ? null
      : measure.effectiveWpm(wpm: wpm, comprehension: comprehension!);
}
