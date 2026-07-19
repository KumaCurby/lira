import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/clock/fixed_clock.dart';
import 'package:lecture_rapide/domain/measure/reading_timer.dart';

void main() {
  group('ReadingTimer (LR1)', () {
    test('mesure la durée écoulée entre start et stop', () {
      final clock = FixedClock(DateTime(2026, 1, 1, 10));
      final timer = ReadingTimer(clock);

      timer.start();
      clock.advance(const Duration(minutes: 1, seconds: 30));
      final elapsed = timer.stop();

      expect(elapsed, const Duration(minutes: 1, seconds: 30));
    });

    test('isRunning reflète l\'état du chronomètre', () {
      final timer = ReadingTimer(FixedClock(DateTime(2026, 1, 1)));

      expect(timer.isRunning, isFalse);
      timer.start();
      expect(timer.isRunning, isTrue);
      timer.stop();
      expect(timer.isRunning, isFalse);
    });

    test('stop() sans start() lève une erreur', () {
      final timer = ReadingTimer(FixedClock(DateTime(2026, 1, 1)));

      expect(timer.stop, throwsStateError);
    });
  });
}
