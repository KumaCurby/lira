import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';
import 'package:lecture_rapide/domain/progress/resumable.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

ReadingText _text(
  String id, {
  String? bookId,
  String? bookTitle,
  int? partIndex,
}) => ReadingText(
  id: id,
  title: id,
  body: List.filled(100, 'mot').join(' '),
  source: TextSource.user,
  bookId: bookId,
  bookTitle: bookTitle,
  partIndex: partIndex,
);

ReadingProgress _p(String id, int idx, {DateTime? at}) => ReadingProgress(
  textId: id,
  wordIndex: idx,
  wordCount: 100,
  updatedAt: at ?? DateTime(2026, 1, 1),
);

void main() {
  group('resumableTexts', () {
    test('inclut un texte autonome en cours', () {
      final items = resumableTexts([_text('t1')], {'t1': _p('t1', 40)});
      expect(items, hasLength(1));
      expect(items.single.passage.id, 't1');
      expect(items.single.fraction, closeTo(0.4, 1e-9));
    });

    test('exclut les textes non commencés ou terminés', () {
      final texts = [_text('t1'), _text('t2'), _text('t3')];
      final items = resumableTexts(texts, {'t2': _p('t2', 100)}); // t2 terminé
      expect(items, isEmpty);
    });

    test('représente un livre par son point de reprise', () {
      final texts = [
        _text('b-1', bookId: 'b', bookTitle: 'Livre', partIndex: 1),
        _text('b-2', bookId: 'b', bookTitle: 'Livre', partIndex: 2),
      ];
      // b-1 terminé, b-2 à 30 % -> reprise sur b-2.
      final items = resumableTexts(texts, {
        'b-1': _p('b-1', 100),
        'b-2': _p('b-2', 30),
      });
      expect(items, hasLength(1));
      expect(items.single.passage.id, 'b-2');
      expect(items.single.label, contains('Livre'));
      expect(items.single.label, contains('extrait 2'));
    });

    test('trie les plus récents en premier', () {
      final texts = [_text('t1'), _text('t2')];
      final items = resumableTexts(texts, {
        't1': _p('t1', 20, at: DateTime(2026, 1, 1)),
        't2': _p('t2', 20, at: DateTime(2026, 2, 1)),
      });
      expect(items.map((i) => i.passage.id).toList(), ['t2', 't1']);
    });
  });
}
