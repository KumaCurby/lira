import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/mappers/reading_text_mapper.dart';
import 'package:lecture_rapide/domain/measure/comprehension_score.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

void main() {
  group('reading_text_mapper', () {
    const text = ReadingText(
      id: 't1',
      title: 'Titre',
      body: 'Un corps de texte.',
      source: TextSource.user,
      difficulty: 3,
      scanTarget: 'corps',
      bookId: 'book-1',
      bookTitle: 'Mon Livre',
      partIndex: 2,
      questions: [
        Question(prompt: 'Q', options: ['a', 'b'], correctIndex: 1),
      ],
    );

    test('le round-trip conserve toutes les données', () {
      final back = readingTextFromJson(readingTextToJson(text));

      expect(back.id, 't1');
      expect(back.title, 'Titre');
      expect(back.body, 'Un corps de texte.');
      expect(back.source, TextSource.user);
      expect(back.difficulty, 3);
      expect(back.scanTarget, 'corps');
      expect(back.bookId, 'book-1');
      expect(back.bookTitle, 'Mon Livre');
      expect(back.partIndex, 2);
      expect(back.questions.single.prompt, 'Q');
      expect(back.questions.single.options, ['a', 'b']);
      expect(back.questions.single.correctIndex, 1);
    });

    test('source = builtin par défaut (fichiers corpus sans champ source)', () {
      final text = readingTextFromJson({
        'id': 'c1',
        'title': 'Corpus',
        'body': 'Texte.',
      });

      expect(text.source, TextSource.builtin);
      expect(text.questions, isEmpty);
      expect(text.difficulty, isNull);
    });
  });
}
