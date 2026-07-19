import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/domain/usecases/import_text.dart';

void main() {
  group('importText', () {
    test('crée un texte utilisateur (corps nettoyé, difficulté, mots)', () {
      final text = importText(id: 'u1', raw: '  Le chat dort paisiblement.  ');

      expect(text.id, 'u1');
      expect(text.source, TextSource.user);
      expect(text.body, 'Le chat dort paisiblement.');
      expect(text.wordCount, 4);
      expect(text.difficulty, inInclusiveRange(1, 5));
    });

    test('dérive un titre du début du texte quand aucun n\'est fourni', () {
      final text = importText(
        id: 'u2',
        raw: 'Première ligne du texte.\nSuite.',
      );
      expect(text.title, 'Première ligne du texte.');
    });

    test('tronque un titre trop long avec une ellipse', () {
      final text = importText(id: 'u3', raw: 'a' * 60);
      expect(text.title.length, lessThanOrEqualTo(41));
      expect(text.title, endsWith('…'));
    });

    test('respecte un titre fourni explicitement', () {
      final text = importText(id: 'u4', raw: 'Corps.', title: 'Mon titre');
      expect(text.title, 'Mon titre');
    });

    test('refuse un texte vide', () {
      expect(() => importText(id: 'x', raw: '   '), throwsArgumentError);
    });
  });
}
