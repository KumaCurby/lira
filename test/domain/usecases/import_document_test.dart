import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/domain/usecases/import_document.dart';

void main() {
  group('importDocument', () {
    test('découpe un document en plusieurs textes numérotés', () {
      final paragraph = List.filled(25, 'mot').join(' ');
      final rawText = List.filled(8, paragraph).join('\n\n'); // 200 mots

      final texts = importDocument(
        idPrefix: 'doc1',
        title: 'Mon livre',
        rawText: rawText,
        targetWords: 50,
      );

      expect(texts, hasLength(4));
      expect(texts.first.id, 'doc1-1');
      expect(texts.first.title, 'Mon livre · 1/4');
      expect(texts.last.title, 'Mon livre · 4/4');
      expect(texts.every((t) => t.source == TextSource.user), isTrue);
      expect(texts.every((t) => t.difficulty != null), isTrue);
      expect(texts.every((t) => t.wordCount > 0), isTrue);
      // Regroupement : même bookId, titre du livre, index d'extrait.
      expect(texts.every((t) => t.bookId == 'doc1'), isTrue);
      expect(texts.first.bookTitle, 'Mon livre');
      expect(texts.map((t) => t.partIndex).toList(), [1, 2, 3, 4]);
    });

    test('un document court donne un seul texte au titre simple', () {
      final texts = importDocument(
        idPrefix: 'doc2',
        title: 'Court',
        rawText: 'Trois petits mots.',
      );

      expect(texts, hasLength(1));
      expect(texts.single.title, 'Court'); // pas de « · 1/1 »
      expect(texts.single.isBookPart, isFalse); // texte autonome
      expect(texts.single.bookId, isNull);
    });

    test('refuse un document sans texte exploitable', () {
      expect(
        () => importDocument(idPrefix: 'x', title: 'Vide', rawText: '   '),
        throwsArgumentError,
      );
    });
  });
}
