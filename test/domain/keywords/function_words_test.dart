import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/keywords/function_words.dart';

void main() {
  group('isFunctionWord (LR12)', () {
    test('reconnaît les articles, prépositions et déterminants', () {
      for (final w in ['le', 'la', 'les', 'de', 'du', 'des', 'un', 'une']) {
        expect(isFunctionWord(w), isTrue, reason: w);
      }
      for (final w in ['dans', 'sur', 'sous', 'au', 'aux', 'par', 'pour']) {
        expect(isFunctionWord(w), isTrue, reason: w);
      }
    });

    test('reconnaît pronoms et auxiliaires être/avoir', () {
      for (final w in [
        'il',
        'elle',
        'nous',
        'qui',
        'est',
        'sont',
        'a',
        'ont',
      ]) {
        expect(isFunctionWord(w), isTrue, reason: w);
      }
    });

    test('ignore la casse, les accents majuscules et la ponctuation', () {
      expect(isFunctionWord('Le'), isTrue);
      expect(isFunctionWord('À'), isTrue);
      expect(isFunctionWord('(le'), isTrue);
      expect(isFunctionWord('les,'), isTrue);
      expect(isFunctionWord('«dans»'), isTrue);
    });

    test('les mots de contenu ne sont PAS des mots-outils', () {
      for (final w in ['cerveau', 'lire', 'rapide', 'forme', 'mots', 'sens']) {
        expect(isFunctionWord(w), isFalse, reason: w);
      }
    });

    test('préserve les négations comme contenu', () {
      for (final w in ['pas', 'non', 'jamais', 'rien']) {
        expect(isFunctionWord(w), isFalse, reason: w);
      }
    });

    test('mais/car/donc sont bien classés mots-outils', () {
      for (final w in ['mais', 'car', 'donc']) {
        expect(isFunctionWord(w), isTrue, reason: w);
      }
    });

    test('un mot élidé collé (l\'homme, d\'un) n\'est pas un mot-outil', () {
      expect(isFunctionWord("l'homme"), isFalse);
      expect(isFunctionWord("d'un"), isFalse);
      // …mais le clitic isolé, oui.
      expect(isFunctionWord("l'"), isTrue);
      expect(isFunctionWord("qu'"), isTrue);
    });
  });
}
