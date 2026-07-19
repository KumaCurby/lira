import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/progress/progress_tracker.dart';

ReadingSession _session({
  required int wpm,
  required DateTime date,
  ExerciseType type = ExerciseType.speedTest,
}) => ReadingSession(
  type: type,
  wordCount: 100,
  elapsed: const Duration(minutes: 1),
  wpm: wpm,
  date: date,
);

void main() {
  group('summarize (LR9)', () {
    test('agrège meilleur, moyenne, dernier et tendance', () {
      final sessions = [
        _session(wpm: 200, date: DateTime(2026, 7, 1)),
        _session(wpm: 260, date: DateTime(2026, 7, 5)),
        _session(wpm: 240, date: DateTime(2026, 7, 3)),
      ];

      final summary = summarize(sessions);

      expect(summary.sessionCount, 3);
      expect(summary.bestWpm, 260);
      expect(summary.averageWpm, closeTo((200 + 260 + 240) / 3, 1e-9));
      expect(summary.latestWpm, 260); // session du 5 juillet
      expect(summary.trend, 60); // dernier (260) - premier (200)
    });

    test('ventile le nombre de sessions par type', () {
      final sessions = [
        _session(wpm: 200, date: DateTime(2026, 7, 1), type: ExerciseType.rsvp),
        _session(wpm: 210, date: DateTime(2026, 7, 2), type: ExerciseType.rsvp),
        _session(
          wpm: 220,
          date: DateTime(2026, 7, 3),
          type: ExerciseType.schulte,
        ),
      ];

      final summary = summarize(sessions);

      expect(summary.byType[ExerciseType.rsvp], 2);
      expect(summary.byType[ExerciseType.schulte], 1);
    });

    test('résumé nul pour une liste vide', () {
      final summary = summarize(const []);

      expect(summary.sessionCount, 0);
      expect(summary.bestWpm, 0);
      expect(summary.averageWpm, 0);
      expect(summary.trend, 0);
      expect(summary.byType, isEmpty);
    });
  });

  group('currentStreakDays (LR9)', () {
    test('compte les jours consécutifs jusqu\'à aujourd\'hui', () {
      final today = DateTime(2026, 7, 10);
      final dates = [
        DateTime(2026, 7, 10, 8),
        DateTime(2026, 7, 9, 20),
        DateTime(2026, 7, 8, 7),
        DateTime(2026, 7, 6, 7), // le 7 manque -> la série s'arrête
      ];

      expect(currentStreakDays(dates, today: today), 3);
    });

    test('série nulle si rien aujourd\'hui', () {
      final today = DateTime(2026, 7, 10);
      expect(currentStreakDays([DateTime(2026, 7, 9)], today: today), 0);
    });
  });

  group('practicedToday (LR9)', () {
    final today = DateTime(2026, 7, 10);

    test('vrai si une séance a eu lieu aujourd\'hui', () {
      expect(practicedToday([DateTime(2026, 7, 10, 9)], today: today), isTrue);
    });

    test('faux sinon (hier, ou aucune séance)', () {
      expect(practicedToday([DateTime(2026, 7, 9)], today: today), isFalse);
      expect(practicedToday(const [], today: today), isFalse);
    });
  });
}
