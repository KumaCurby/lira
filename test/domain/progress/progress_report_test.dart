import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/progress/progress_report.dart';

ReadingSession _s(int wpm, {ExerciseType t = ExerciseType.rsvp, double? c}) =>
    ReadingSession(
      type: t,
      wordCount: 100,
      elapsed: const Duration(seconds: 30),
      wpm: wpm,
      comprehension: c,
      date: DateTime(2026, 1, 10),
    );

void main() {
  group('buildProgressReport (LR23)', () {
    test('sans session : message dédié', () {
      expect(
        buildProgressReport(const [], now: DateTime(2026, 1, 1)),
        'Aucune session enregistrée.',
      );
    });

    test('inclut meilleur wpm et tendance', () {
      final report = buildProgressReport([
        _s(200),
        _s(400),
      ], now: DateTime(2026, 1, 10));
      expect(report, contains('Meilleure vitesse : 400 mpm'));
      expect(report, contains('Tendance'));
    });

    test('liste les meilleurs scores compétition', () {
      final report = buildProgressReport([
        _s(200, t: ExerciseType.competition, c: 0.7), // 140
        _s(400, t: ExerciseType.competition, c: 0.9), // 360
      ], now: DateTime(2026, 1, 10));
      expect(report, contains('MEILLEURS SCORES COMPÉTITION'));
      // Le score le plus élevé (360) doit apparaître en premier.
      final i1 = report.indexOf('360 pts');
      final i2 = report.indexOf('140 pts');
      expect(i1, greaterThanOrEqualTo(0));
      expect(i2, greaterThan(i1));
    });
  });
}
