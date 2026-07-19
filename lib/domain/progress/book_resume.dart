import '../text/reading_text.dart';
import 'reading_progress.dart';

/// Point de reprise d'un livre : l'extrait à ouvrir et l'indice de mot où reprendre.
class BookResumePoint {
  const BookResumePoint({
    required this.passage,
    required this.wordIndex,
    required this.hasStarted,
  });

  final ReadingText passage;
  final int wordIndex;

  /// Vrai si la lecture du livre a déjà commencé (au moins un extrait entamé).
  final bool hasStarted;
}

/// Détermine où reprendre la lecture d'un livre : le premier extrait non terminé
/// (dans l'ordre des parties), à sa position sauvegardée. Si tout est terminé,
/// on repart du premier extrait.
BookResumePoint bookResume(
  List<ReadingText> parts,
  Map<String, ReadingProgress> progress,
) {
  if (parts.isEmpty) {
    throw ArgumentError('parts ne doit pas être vide');
  }
  final sorted = [...parts]
    ..sort((a, b) => (a.partIndex ?? 0).compareTo(b.partIndex ?? 0));
  final hasStarted = sorted.any((p) => progress.containsKey(p.id));

  for (final passage in sorted) {
    final prog = progress[passage.id];
    if (prog == null || !prog.isComplete) {
      return BookResumePoint(
        passage: passage,
        wordIndex: prog?.wordIndex ?? 0,
        hasStarted: hasStarted,
      );
    }
  }
  return BookResumePoint(
    passage: sorted.first,
    wordIndex: 0,
    hasStarted: hasStarted,
  );
}

/// Fraction lue de l'ensemble du livre (0..1), pondérée par le nombre de mots.
double bookProgressFraction(
  List<ReadingText> parts,
  Map<String, ReadingProgress> progress,
) {
  var total = 0;
  var read = 0;
  for (final passage in parts) {
    final words = passage.wordCount;
    total += words;
    final prog = progress[passage.id];
    read += prog == null ? 0 : prog.wordIndex.clamp(0, words);
  }
  return total == 0 ? 0 : (read / total).clamp(0.0, 1.0).toDouble();
}
