import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/pacer/chunker.dart';

void main() {
  group('chunk (LR5)', () {
    test('regroupe les mots par blocs de taille N', () {
      expect(chunk(['a', 'b', 'c', 'd', 'e'], chunkSize: 2), [
        ['a', 'b'],
        ['c', 'd'],
        ['e'],
      ]);
    });

    test('un chunkSize plus grand que la liste donne un seul bloc', () {
      expect(chunk(['a', 'b'], chunkSize: 10), [
        ['a', 'b'],
      ]);
    });

    test('liste vide -> aucun bloc', () {
      expect(chunk(const [], chunkSize: 3), isEmpty);
    });

    test('refuse un chunkSize < 1', () {
      expect(() => chunk(['a'], chunkSize: 0), throwsArgumentError);
    });
  });
}
