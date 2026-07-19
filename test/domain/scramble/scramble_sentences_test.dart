import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/random/seeded_random_source.dart';
import 'package:lecture_rapide/domain/scramble/scramble_sentences.dart';
import 'package:lecture_rapide/domain/text/tokenizer.dart';

void main() {
  group('scrambleWordOrder (LR11)', () {
    test('garde le premier et le dernier mot, brasse le milieu', () {
      const source = 'Le petit chat noir dort sur le canapé rouge.';
      final out = scrambleWordOrder(source, SeededRandomSource(2));
      final srcWords = tokenizeWords(source);
      final outWords = tokenizeWords(out);

      expect(outWords.first, srcWords.first); // « Le »
      expect(outWords.last, srcWords.last); // « rouge »
      // Mêmes mots, ordre (au moins du milieu) différent.
      expect(outWords.toList()..sort(), srcWords.toList()..sort());
      expect(outWords, isNot(srcWords));
    });

    test('conserve la ponctuation finale de la phrase', () {
      final out = scrambleWordOrder(
        'Un deux trois quatre cinq ?',
        SeededRandomSource(1),
      );
      expect(out.trim().endsWith('?'), isTrue);
    });

    test('laisse les phrases de moins de 4 mots intactes', () {
      const short = 'Le chat dort.';
      expect(scrambleWordOrder(short, SeededRandomSource(9)), short);
    });

    test('traite chaque phrase indépendamment', () {
      const source = 'Le grand chien blanc court. Il aboie très fort ici.';
      final out = scrambleWordOrder(source, SeededRandomSource(4));
      final sentences = out.split('.').where((s) => s.trim().isNotEmpty);
      expect(sentences.length, 2);
      for (final s in sentences) {
        final w = tokenizeWords(s);
        expect(w.length, greaterThanOrEqualTo(4));
      }
    });

    test('est reproductible à graine égale', () {
      const source =
          'Voici une phrase assez longue pour être bien brassée ici.';
      final a = scrambleWordOrder(source, SeededRandomSource(7));
      final b = scrambleWordOrder(source, SeededRandomSource(7));
      expect(a, b);
    });
  });
}
