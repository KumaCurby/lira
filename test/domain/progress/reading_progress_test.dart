import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';

void main() {
  group('ReadingProgress', () {
    test('fraction et isComplete pour une lecture en cours', () {
      final p = ReadingProgress(
        textId: 't',
        wordIndex: 50,
        wordCount: 100,
        updatedAt: DateTime(2026),
      );
      expect(p.fraction, closeTo(0.5, 1e-9));
      expect(p.isComplete, isFalse);
    });

    test('complet quand wordIndex atteint wordCount', () {
      final p = ReadingProgress(
        textId: 't',
        wordIndex: 100,
        wordCount: 100,
        updatedAt: DateTime(2026),
      );
      expect(p.isComplete, isTrue);
      expect(p.fraction, 1.0);
    });

    test('fraction nulle si wordCount vaut 0', () {
      final p = ReadingProgress(
        textId: 't',
        wordIndex: 0,
        wordCount: 0,
        updatedAt: DateTime(2026),
      );
      expect(p.fraction, 0);
      expect(p.isComplete, isFalse);
    });
  });
}
