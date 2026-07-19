import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/mappers/reading_session_mapper.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';

void main() {
  group('reading_session_mapper', () {
    test('le round-trip conserve la session', () {
      final session = ReadingSession(
        type: ExerciseType.scanning,
        wordCount: 120,
        elapsed: const Duration(seconds: 45),
        wpm: 160,
        comprehension: 0.75,
        textId: 'corpus-abeilles',
        date: DateTime(2026, 7, 10, 14, 30),
      );

      final back = sessionFromJson(sessionToJson(session));

      expect(back.type, ExerciseType.scanning);
      expect(back.wordCount, 120);
      expect(back.elapsed, const Duration(seconds: 45));
      expect(back.wpm, 160);
      expect(back.comprehension, 0.75);
      expect(back.textId, 'corpus-abeilles');
      expect(back.date, DateTime(2026, 7, 10, 14, 30));
    });

    test('gère l\'absence de compréhension et de textId', () {
      final session = ReadingSession(
        type: ExerciseType.rsvp,
        wordCount: 10,
        elapsed: const Duration(seconds: 5),
        wpm: 120,
        date: DateTime(2026, 1, 1),
      );

      final back = sessionFromJson(sessionToJson(session));

      expect(back.comprehension, isNull);
      expect(back.textId, isNull);
    });
  });
}
