import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/word_counter.dart';

void main() {
  group('countWords (LR1)', () {
    test('compte les mots d\'un texte', () {
      expect(countWords('Le petit chat dort.'), 4);
    });

    test('vaut 0 pour un texte sans mot', () {
      expect(countWords('   ...  '), 0);
    });
  });
}
