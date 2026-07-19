import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/text/sentence_splitter.dart';

void main() {
  group('splitSentences (LR0)', () {
    test('sépare sur . ! ? et compacte les espaces', () {
      expect(splitSentences('Bonjour ! Ça va ? Oui, très bien.'), [
        'Bonjour',
        'Ça va',
        'Oui, très bien',
      ]);
    });

    test('ignore les segments vides et les points de suspension', () {
      expect(splitSentences('Attends… j\'arrive.'), ['Attends', 'j\'arrive']);
    });

    test('renvoie une liste vide pour une entrée vide', () {
      expect(splitSentences('   '), isEmpty);
    });
  });

  group('splitParagraphs (LR0)', () {
    test('sépare sur les lignes vides', () {
      const text = 'Premier paragraphe.\n\nDeuxième paragraphe.';
      expect(splitParagraphs(text), [
        'Premier paragraphe.',
        'Deuxième paragraphe.',
      ]);
    });

    test('tolère plusieurs lignes vides et les espaces', () {
      const text = 'Un.\n\n\n  \nDeux.';
      expect(splitParagraphs(text), ['Un.', 'Deux.']);
    });

    test('un texte sans ligne vide reste un seul paragraphe', () {
      const text = 'Ligne un.\nLigne deux.';
      expect(splitParagraphs(text), ['Ligne un.\nLigne deux.']);
    });
  });
}
