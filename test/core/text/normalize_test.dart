import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/text/normalize.dart';

void main() {
  group('normalize', () {
    test('met en minuscules et retire les accents', () {
      expect(normalize('Éléphant'), 'elephant');
      expect(normalize('Château'), 'chateau');
      expect(normalize('CIGOGNE'), 'cigogne');
    });

    test('développe les ligatures œ et æ', () {
      expect(normalize('Œuvre'), 'oeuvre');
      expect(normalize('nævus'), 'naevus');
    });

    test('remplace la ponctuation par un espace et compacte', () {
      expect(normalize("L'ami, GRIS !"), 'l ami gris');
    });

    test('supprime les espaces superflus en bord de chaîne', () {
      expect(normalize('   Banque  '), 'banque');
    });

    test('renvoie une chaîne vide pour une entrée vide ou blanche', () {
      expect(normalize(''), '');
      expect(normalize('   '), '');
    });
  });
}
