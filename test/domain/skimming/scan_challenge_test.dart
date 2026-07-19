import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/clock/fixed_clock.dart';
import 'package:lecture_rapide/domain/skimming/scan_challenge.dart';

void main() {
  ScanChallenge make(FixedClock clock) => ScanChallenge(
    clock,
    text: 'La réunion est prévue à Bordeaux le 12 mai.',
    target: 'Bordeaux',
    acceptedAnswers: const ['à Bordeaux'],
  );

  group('ScanChallenge (LR8)', () {
    test('accepte la bonne réponse malgré casse, accents et ponctuation', () {
      final challenge = make(FixedClock(DateTime(2026, 1, 1)));
      expect(challenge.check('BORDEAUX'), isTrue);
      expect(challenge.check('bordeaux.'), isTrue);
    });

    test('accepte une réponse alternative', () {
      expect(
        make(FixedClock(DateTime(2026, 1, 1))).check('à bordeaux'),
        isTrue,
      );
    });

    test('rejette une mauvaise réponse', () {
      expect(make(FixedClock(DateTime(2026, 1, 1))).check('Paris'), isFalse);
    });

    test('mesure le temps de recherche', () {
      final clock = FixedClock(DateTime(2026, 1, 1, 9));
      final challenge = make(clock)..start();
      clock.advance(const Duration(seconds: 7));
      expect(challenge.elapsed, const Duration(seconds: 7));
    });

    test('elapsed avant start lève une erreur', () {
      expect(
        () => make(FixedClock(DateTime(2026, 1, 1))).elapsed,
        throwsStateError,
      );
    });
  });
}
