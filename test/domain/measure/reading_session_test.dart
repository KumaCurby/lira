import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';

void main() {
  group('ReadingSession (LR2)', () {
    test('calcule la mpm effective quand il y a une compréhension', () {
      final session = ReadingSession(
        type: ExerciseType.speedTest,
        wordCount: 300,
        elapsed: const Duration(minutes: 2),
        wpm: 150,
        comprehension: 0.8,
        date: DateTime(2026, 7, 10),
      );

      expect(session.effectiveWpm, 120); // 150 × 0.8
    });

    test('mpm effective nulle en l\'absence de quiz', () {
      final session = ReadingSession(
        type: ExerciseType.rsvp,
        wordCount: 300,
        elapsed: const Duration(minutes: 1),
        wpm: 300,
        date: DateTime(2026, 7, 10),
      );

      expect(session.effectiveWpm, isNull);
    });
  });
}
