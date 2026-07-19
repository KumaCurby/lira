import '../text/reading_text.dart';
import 'book_resume.dart';
import 'reading_progress.dart';

/// Un élément de lecture à reprendre : l'extrait à ouvrir, un libellé, l'état.
class ResumableItem {
  const ResumableItem({
    required this.passage,
    required this.label,
    required this.fraction,
    required this.updatedAt,
  });

  final ReadingText passage;
  final String label;
  final double fraction;
  final DateTime updatedAt;
}

/// Liste des textes/livres **en cours** (0 < progression < 100 %), les plus
/// récemment lus d'abord. Pour un livre, renvoie son point de reprise et sa
/// progression globale.
List<ResumableItem> resumableTexts(
  List<ReadingText> texts,
  Map<String, ReadingProgress> progress,
) {
  final items = <ResumableItem>[];

  // Textes autonomes en cours.
  for (final text in texts.where((t) => t.bookId == null)) {
    final prog = progress[text.id];
    if (prog != null && prog.fraction > 0 && !prog.isComplete) {
      items.add(
        ResumableItem(
          passage: text,
          label: text.title,
          fraction: prog.fraction,
          updatedAt: prog.updatedAt,
        ),
      );
    }
  }

  // Livres en cours.
  final books = <String, List<ReadingText>>{};
  for (final text in texts.where((t) => t.bookId != null)) {
    books.putIfAbsent(text.bookId!, () => <ReadingText>[]).add(text);
  }
  books.forEach((_, parts) {
    final fraction = bookProgressFraction(parts, progress);
    if (fraction <= 0 || fraction >= 1) return;

    final resume = bookResume(parts, progress);
    var latest = DateTime.fromMillisecondsSinceEpoch(0);
    for (final part in parts) {
      final prog = progress[part.id];
      if (prog != null && prog.updatedAt.isAfter(latest)) {
        latest = prog.updatedAt;
      }
    }
    final bookTitle = parts.first.bookTitle ?? 'Livre importé';
    items.add(
      ResumableItem(
        passage: resume.passage,
        label: '$bookTitle · extrait ${resume.passage.partIndex}',
        fraction: fraction,
        updatedAt: latest,
      ),
    );
  });

  items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return items;
}
