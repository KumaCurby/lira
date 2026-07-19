import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/clock/fixed_clock.dart';
import 'package:lecture_rapide/domain/schulte/schulte_run.dart';

void main() {
  group('SchulteRun (LR6)', () {
    test('valide la séquence 1..n et mesure la durée', () {
      final clock = FixedClock(DateTime(2026, 1, 1, 12));
      final run = SchulteRun(clock, count: 4);

      run.start();
      for (final value in [1, 2, 3, 4]) {
        clock.advance(const Duration(seconds: 1));
        expect(run.tap(value), isTrue);
      }

      expect(run.isComplete, isTrue);
      expect(run.errors, 0);
      expect(run.elapsed, const Duration(seconds: 4));
    });

    test('un tap hors ordre compte une erreur sans avancer', () {
      final run = SchulteRun(FixedClock(DateTime(2026, 1, 1)), count: 4);
      run.start();

      expect(run.tap(2), isFalse); // on attend 1
      expect(run.errors, 1);
      expect(run.nextExpected, 1);

      expect(run.tap(1), isTrue);
      expect(run.nextExpected, 2);
    });

    test('elapsed se fige à l\'achèvement', () {
      final clock = FixedClock(DateTime(2026, 1, 1, 12));
      final run = SchulteRun(clock, count: 2);

      run.start();
      clock.advance(const Duration(seconds: 3));
      run.tap(1);
      clock.advance(const Duration(seconds: 2));
      run.tap(2); // termine à t+5s
      clock.advance(const Duration(seconds: 10)); // ne doit plus compter

      expect(run.elapsed, const Duration(seconds: 5));
    });

    test('elapsed avant start lève une erreur', () {
      final run = SchulteRun(FixedClock(DateTime(2026, 1, 1)), count: 4);
      expect(() => run.elapsed, throwsStateError);
    });
  });
}
