import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/skimming/skim_extractor.dart';

void main() {
  group('extractSkimLines (LR7)', () {
    test('retient la première phrase de chaque paragraphe', () {
      const text =
          'Les abeilles vivent en colonie. Elles produisent du miel.\n\n'
          'Le frelon est un prédateur. Il attaque les ruches.';

      expect(extractSkimLines(text), [
        'Les abeilles vivent en colonie',
        'Le frelon est un prédateur',
      ]);
    });

    test('un texte mono-paragraphe donne sa première phrase', () {
      const text = 'Le titre annonce le sujet. Le reste développe.';
      expect(extractSkimLines(text), ['Le titre annonce le sujet']);
    });

    test('texte vide -> aucune ligne', () {
      expect(extractSkimLines('   '), isEmpty);
    });
  });
}
