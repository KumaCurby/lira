import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/progress/book_resume.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

ReadingText _part(int i, {int words = 100}) => ReadingText(
  id: 'b-$i',
  title: 'L · $i',
  body: List.filled(words, 'mot').join(' '),
  source: TextSource.user,
  bookId: 'b',
  bookTitle: 'L',
  partIndex: i,
);

ReadingProgress _prog(String id, int idx, {int count = 100}) => ReadingProgress(
  textId: id,
  wordIndex: idx,
  wordCount: count,
  updatedAt: DateTime(2026),
);

void main() {
  final parts = [_part(1), _part(2), _part(3)];

  group('bookResume', () {
    test('sans progression : premier extrait, index 0, pas commencé', () {
      final r = bookResume(parts, const {});
      expect(r.passage.id, 'b-1');
      expect(r.wordIndex, 0);
      expect(r.hasStarted, isFalse);
    });

    test('reprend le premier extrait non terminé, à sa position', () {
      final r = bookResume(parts, {
        'b-1': _prog('b-1', 100), // terminé
        'b-2': _prog('b-2', 40), // en cours
      });
      expect(r.passage.id, 'b-2');
      expect(r.wordIndex, 40);
      expect(r.hasStarted, isTrue);
    });

    test(
      'reste sur un extrait partiellement lu même si le suivant est vierge',
      () {
        final r = bookResume(parts, {'b-1': _prog('b-1', 30)});
        expect(r.passage.id, 'b-1');
        expect(r.wordIndex, 30);
      },
    );

    test('tout terminé : repart du premier extrait', () {
      final r = bookResume(parts, {
        'b-1': _prog('b-1', 100),
        'b-2': _prog('b-2', 100),
        'b-3': _prog('b-3', 100),
      });
      expect(r.passage.id, 'b-1');
      expect(r.wordIndex, 0);
      expect(r.hasStarted, isTrue);
    });

    test('refuse une liste vide', () {
      expect(() => bookResume(const [], const {}), throwsArgumentError);
    });
  });

  group('bookProgressFraction', () {
    test('moyenne pondérée par le nombre de mots', () {
      final two = [_part(1, words: 100), _part(2, words: 100)];
      // b-1 lu entièrement (100), b-2 non lu -> 100/200 = 0.5
      final f = bookProgressFraction(two, {'b-1': _prog('b-1', 100)});
      expect(f, closeTo(0.5, 1e-9));
    });

    test('0 sans progression', () {
      expect(bookProgressFraction(parts, const {}), 0);
    });
  });
}
