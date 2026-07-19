import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/corpus/corpus_loader.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

void main() {
  group('parseCorpus', () {
    test('parse une liste de textes en source builtin', () {
      const json =
          '[{"id":"a","title":"A","body":"Un deux trois.",'
          '"scanTarget":"deux","questions":[{"prompt":"?","options":["x","y"],'
          '"correctIndex":0}]}]';

      final texts = parseCorpus(json);

      expect(texts, hasLength(1));
      expect(texts.single.source, TextSource.builtin);
      expect(texts.single.scanTarget, 'deux');
      expect(texts.single.questions.single.correctIndex, 0);
    });
  });

  group('corpus intégré (fichier réel)', () {
    test('assets/corpus/corpus_fr.json est valide et complet', () {
      final json = File('assets/corpus/corpus_fr.json').readAsStringSync();
      final texts = parseCorpus(json);

      expect(texts.length, greaterThanOrEqualTo(4));
      for (final text in texts) {
        expect(text.source, TextSource.builtin);
        expect(text.title, isNotEmpty);
        expect(text.body, isNotEmpty);
        expect(text.questions, isNotEmpty);
        expect(text.scanTarget, isNotNull);
        // La cible de balayage doit réellement figurer dans le texte.
        expect(
          text.body.toLowerCase(),
          contains(text.scanTarget!.toLowerCase()),
          reason: '« ${text.scanTarget} » absent de « ${text.title} »',
        );
      }
    });
  });
}
