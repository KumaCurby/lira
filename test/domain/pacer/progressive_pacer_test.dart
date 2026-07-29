import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/pacer/chunker.dart';
import 'package:lecture_rapide/domain/pacer/pacer_schedule.dart';

List<String> _words(int n) => [for (var i = 1; i <= n; i++) 'm$i'];

void main() {
  group('progressiveChunk (LR5 — empan progressif)', () {
    test('couvre tous les mots, dans l\'ordre', () {
      final w = _words(10);
      final flat = progressiveChunk(w).expand((g) => g).toList();
      expect(flat, w);
    });

    test('l\'empan part de minSpan, croît de 1, plafonne à maxSpan', () {
      final groups = progressiveChunk(_words(15), minSpan: 1, maxSpan: 3);
      final sizes = groups.map((g) => g.length).toList();
      expect(sizes.first, 1);
      expect(sizes.every((s) => s <= 3), isTrue);
      // Croissance non décroissante jusqu'au plateau (dernier bloc peut être court).
      for (var i = 1; i < sizes.length - 1; i++) {
        expect(sizes[i] >= sizes[i - 1], isTrue, reason: 'index $i : $sizes');
      }
      // 1+2+3+3+3+3 = 15
      expect(sizes, [1, 2, 3, 3, 3, 3]);
    });

    test('refuse des empans invalides', () {
      expect(
        () => progressiveChunk(_words(5), minSpan: 0),
        throwsArgumentError,
      );
      expect(
        () => progressiveChunk(_words(5), minSpan: 3, maxSpan: 2),
        throwsArgumentError,
      );
    });
  });

  group('buildProgressivePacerSchedule (LR5)', () {
    test('une étape par bloc, débuts cumulés', () {
      final steps = buildProgressivePacerSchedule(
        _words(10),
        wpm: 300,
        minSpan: 1,
        maxSpan: 4,
      );
      expect(steps, hasLength(4)); // blocs 1,2,3,4
      for (var i = 1; i < steps.length; i++) {
        expect(steps[i].start >= steps[i - 1].start, isTrue);
      }
    });

    test('la durée totale respecte la vitesse (wpm)', () {
      const wpm = 300;
      final steps = buildProgressivePacerSchedule(_words(12), wpm: wpm);
      final totalMs = steps.fold<int>(
        0,
        (sum, s) => sum + s.duration.inMilliseconds,
      );
      // 12 mots à 300 mpm = 12 * 200 ms = 2400 ms.
      expect(totalMs, closeTo(2400, 5));
    });

    test('refuse un wpm nul', () {
      expect(
        () => buildProgressivePacerSchedule(_words(5), wpm: 0),
        throwsArgumentError,
      );
    });
  });
}
