import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/passage_splitter.dart';
import 'package:lecture_rapide/domain/text/tokenizer.dart';

void main() {
  group('splitIntoPassages', () {
    test('regroupe les paragraphes en passages proches de la cible', () {
      // 8 paragraphes de 25 mots = 200 mots ; cible 50.
      final paragraph = List.filled(25, 'mot').join(' ');
      final text = List.filled(8, paragraph).join('\n\n');

      final passages = splitIntoPassages(text, targetWords: 50);

      expect(passages, hasLength(4)); // 2 paragraphes par passage
      for (final passage in passages) {
        expect(tokenizeWords(passage).length, lessThanOrEqualTo(75));
      }
      // Tous les mots sont préservés.
      final total = passages.fold<int>(
        0,
        (sum, p) => sum + tokenizeWords(p).length,
      );
      expect(total, tokenizeWords(text).length);
    });

    test('un texte plus court que la cible reste un seul passage', () {
      final passages = splitIntoPassages('Un petit texte.', targetWords: 500);
      expect(passages, hasLength(1));
    });

    test('redécoupe un paragraphe unique trop long par blocs de mots', () {
      final huge = List.filled(300, 'mot').join(' '); // 300 mots, sans saut
      final passages = splitIntoPassages(huge, targetWords: 100);

      expect(passages, hasLength(3));
      expect(tokenizeWords(passages.first).length, 100);
    });

    test('texte vide -> aucun passage', () {
      expect(splitIntoPassages('   '), isEmpty);
    });
  });
}
