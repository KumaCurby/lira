import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/challenges/challenge.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/notes/text_note.dart';
import 'package:lecture_rapide/domain/srs/srs_card.dart';

final _now = DateTime(2026, 4, 10, 12);

ReadingSession _s({
  ExerciseType type = ExerciseType.rsvp,
  int wpm = 300,
  double? c,
  DateTime? date,
}) => ReadingSession(
  type: type,
  wordCount: 100,
  elapsed: const Duration(seconds: 20),
  wpm: wpm,
  comprehension: c,
  date: date ?? _now,
);

ChallengeContext _ctx({
  List<ReadingSession> sessions = const [],
  List<SrsCard> srsCards = const [],
  List<TextNote> notes = const [],
}) => ChallengeContext(
  sessions: sessions,
  srsCards: srsCards,
  notes: notes,
  now: _now,
);

Challenge _by(String id) => kChallenges.firstWhere((c) => c.id == id);

void main() {
  group('challenge streak5', () {
    test('progresse par jours consécutifs jusqu\'à aujourd\'hui', () {
      final sessions = [
        _s(date: _now),
        _s(date: _now.subtract(const Duration(days: 1))),
        _s(date: _now.subtract(const Duration(days: 2))),
      ];
      expect(_by('streak5').progress(_ctx(sessions: sessions)), 3);
    });

    test('interruption casse la série', () {
      final sessions = [
        _s(date: _now),
        _s(date: _now.subtract(const Duration(days: 3))),
      ];
      expect(_by('streak5').progress(_ctx(sessions: sessions)), 1);
    });
  });

  group('challenge speed500', () {
    test('atteint si une session ≥ 500 mpm avec compréhension ≥ 80 %', () {
      expect(
        _by('speed500').progress(_ctx(sessions: [_s(wpm: 550, c: 0.85)])),
        1,
      );
    });

    test('non atteint si compréhension < 80 %', () {
      expect(
        _by('speed500').progress(_ctx(sessions: [_s(wpm: 550, c: 0.75)])),
        0,
      );
    });
  });

  group('challenge contest3', () {
    test('compte les compétitions avec score composite ≥ 250', () {
      final sessions = [
        _s(type: ExerciseType.competition, wpm: 400, c: 0.7), // score 280 ✓
        _s(type: ExerciseType.competition, wpm: 200, c: 0.5), // score 100 ✗
        _s(type: ExerciseType.rsvp, wpm: 800, c: 1.0), // pas compétition ✗
      ];
      expect(_by('contest3').progress(_ctx(sessions: sessions)), 1);
    });
  });
}
