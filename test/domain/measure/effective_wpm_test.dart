import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/effective_wpm.dart';

void main() {
  group('effectiveWpm (LR2)', () {
    test('mpm pondérée par la compréhension', () {
      expect(effectiveWpm(wpm: 300, comprehension: 0.8), 240);
    });

    test('une compréhension parfaite conserve la vitesse', () {
      expect(effectiveWpm(wpm: 250, comprehension: 1), 250);
    });

    test('refuse une compréhension hors [0, 1]', () {
      expect(
        () => effectiveWpm(wpm: 200, comprehension: 1.5),
        throwsArgumentError,
      );
    });
  });
}
