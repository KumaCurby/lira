import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/tokenizer.dart';

void main() {
  group('tokenizeWords (LR0)', () {
    test('découpe une phrase simple et ignore la ponctuation', () {
      expect(tokenizeWords('Le chat dort.'), ['Le', 'chat', 'dort']);
    });

    test('garde les apostrophes et traits d\'union internes', () {
      expect(tokenizeWords("Aujourd'hui, c'est peut-être vrai"), [
        "Aujourd'hui",
        "c'est",
        'peut-être',
        'vrai',
      ]);
    });

    test('gère les chiffres comme des mots', () {
      expect(tokenizeWords("J'ai 21 ans"), ["J'ai", '21', 'ans']);
    });

    test('traverse les sauts de ligne et espaces multiples', () {
      expect(tokenizeWords('Bonjour\n  le   monde'), [
        'Bonjour',
        'le',
        'monde',
      ]);
    });

    test('renvoie une liste vide pour une entrée vide ou blanche', () {
      expect(tokenizeWords(''), isEmpty);
      expect(tokenizeWords('   \n  '), isEmpty);
      expect(tokenizeWords('... !?'), isEmpty);
    });
  });
}
