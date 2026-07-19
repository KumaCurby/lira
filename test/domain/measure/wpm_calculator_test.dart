import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/wpm_calculator.dart';

void main() {
  group('wordsPerMinute (LR1)', () {
    test('300 mots en 2 minutes = 150 mpm', () {
      expect(
        wordsPerMinute(wordCount: 300, elapsed: const Duration(minutes: 2)),
        150,
      );
    });

    test('arrondit au plus proche (100 mots en 90 s = 67)', () {
      expect(
        wordsPerMinute(wordCount: 100, elapsed: const Duration(seconds: 90)),
        67,
      );
    });

    test('refuse une durée nulle ou négative', () {
      expect(
        () => wordsPerMinute(wordCount: 100, elapsed: Duration.zero),
        throwsArgumentError,
      );
    });
  });
}
