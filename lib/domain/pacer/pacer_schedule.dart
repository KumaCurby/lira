import 'chunker.dart';

/// LR5 — Une étape du guidage : le bloc de mots à surligner, son instant de
/// début et sa durée d'affichage.
class PacerStep {
  const PacerStep({
    required this.words,
    required this.start,
    required this.duration,
  });

  final List<String> words;
  final Duration start;
  final Duration duration;

  int get wordCount => words.length;
}

/// LR5 — Construit le planning de guidage : chaque bloc reste affiché un temps
/// proportionnel à son nombre de mots, de sorte que la vitesse globale respecte
/// [wpm]. Les débuts sont cumulés.
List<PacerStep> buildPacerSchedule(
  List<String> words, {
  required int wpm,
  required int chunkSize,
}) {
  if (wpm <= 0) {
    throw ArgumentError('wpm doit être > 0 (reçu $wpm)');
  }
  final groups = chunk(words, chunkSize: chunkSize);
  final perWordMs = 60000 / wpm;

  final steps = <PacerStep>[];
  var cursorMs = 0.0;
  for (final group in groups) {
    final durationMs = perWordMs * group.length;
    steps.add(
      PacerStep(
        words: group,
        start: Duration(milliseconds: cursorMs.round()),
        duration: Duration(milliseconds: durationMs.round()),
      ),
    );
    cursorMs += durationMs;
  }
  return steps;
}
