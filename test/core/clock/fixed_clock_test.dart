import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/clock/fixed_clock.dart';

void main() {
  group('FixedClock', () {
    test('renvoie l\'instant fixé', () {
      final t = DateTime(2026, 7, 10, 9, 0, 0);
      final clock = FixedClock(t);

      expect(clock.now(), t);
    });

    test('advance() fait avancer l\'horloge', () {
      final clock = FixedClock(DateTime(2026, 1, 1));

      clock.advance(const Duration(minutes: 2, seconds: 30));

      expect(clock.now(), DateTime(2026, 1, 1, 0, 2, 30));
    });

    test('set() remplace l\'instant courant', () {
      final clock = FixedClock(DateTime(2026, 1, 1));

      clock.set(DateTime(2027, 6, 15));

      expect(clock.now(), DateTime(2027, 6, 15));
    });
  });
}
