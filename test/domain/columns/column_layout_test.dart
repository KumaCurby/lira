import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/columns/column_layout.dart';

void main() {
  group('splitIntoColumns (LR14)', () {
    test('répartit les mots en colonnes équilibrées', () {
      final cols = splitIntoColumns(
        'un deux trois quatre cinq six',
        columnCount: 2,
      );
      expect(cols, hasLength(2));
      expect(cols.first.split(' '), ['un', 'deux', 'trois']);
      expect(cols.last.split(' '), ['quatre', 'cinq', 'six']);
    });

    test('reste dans l\'ordre du texte source', () {
      final cols = splitIntoColumns('a b c d e f g h i', columnCount: 3);
      expect(cols.expand((c) => c.split(' ')).toList(), [
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
      ]);
    });

    test('gère un texte plus court que le nombre de colonnes', () {
      final cols = splitIntoColumns('un deux', columnCount: 5);
      expect(cols, hasLength(5));
      expect(cols.first, 'un');
      expect(cols[1], 'deux');
      for (var i = 2; i < 5; i++) {
        expect(cols[i], '');
      }
    });

    test('texte vide → colonnes vides', () {
      expect(splitIntoColumns('', columnCount: 3), ['', '', '']);
    });

    test('refuse un nombre de colonnes < 1', () {
      expect(
        () => splitIntoColumns('un deux', columnCount: 0),
        throwsArgumentError,
      );
    });
  });
}
