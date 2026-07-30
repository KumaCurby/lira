import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/scramble/scramble_stats.dart';

ReadingSession _session(ExerciseType type, int wpm) => ReadingSession(
  type: type,
  wordCount: 100,
  elapsed: const Duration(minutes: 1),
  wpm: wpm,
  date: DateTime(2026, 1, 1),
);

void main() {
  group('referenceReadingWpm (LR10)', () {
    test('moyenne des sessions de lecture normales', () {
      final ref = referenceReadingWpm([
        _session(ExerciseType.speedTest, 300),
        _session(ExerciseType.rsvp, 400),
      ], fallback: 250);
      expect(ref, 350);
    });

    test('ignore « mots mélangés » et les sessions à vitesse nulle', () {
      final ref = referenceReadingWpm([
        _session(ExerciseType.speedTest, 300),
        _session(ExerciseType.scramble, 100), // ignorée
        _session(ExerciseType.keywords, 500), // ignorée (aidée)
        _session(ExerciseType.schulte, 0), // ignorée (wpm 0)
      ], fallback: 250);
      expect(ref, 300);
    });

    test('retombe sur le fallback sans lecture normale', () {
      expect(
        referenceReadingWpm([
          _session(ExerciseType.scramble, 120),
        ], fallback: 250),
        250,
      );
      expect(referenceReadingWpm(const [], fallback: 250), 250);
    });
  });
}
