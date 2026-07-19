import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/difficulty.dart';

void main() {
  group('estimateDifficulty', () {
    test('reste dans l\'intervalle [1, 5]', () {
      expect(estimateDifficulty('Le chat dort.'), inInclusiveRange(1, 5));
    });

    test('un texte simple est plus facile qu\'un texte complexe', () {
      const simple = 'Le chat dort. Il est noir. Je le vois.';
      const complexe =
          "L'appréhension phénoménologique des considérations épistémologiques "
          'transcende invariablement les paradigmes conventionnellement établis '
          'par les institutions académiques contemporaines.';

      expect(
        estimateDifficulty(simple),
        lessThan(estimateDifficulty(complexe)),
      );
    });

    test('texte vide -> 1', () {
      expect(estimateDifficulty('   '), 1);
    });
  });
}
