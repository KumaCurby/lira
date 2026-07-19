import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/pacer/pacer_schedule.dart';

void main() {
  group('buildPacerSchedule (LR5)', () {
    final words = ['a', 'b', 'c', 'd', 'e'];

    test('couvre tous les mots dans l\'ordre', () {
      final steps = buildPacerSchedule(words, wpm: 600, chunkSize: 2);
      final flattened = [for (final s in steps) ...s.words];
      expect(flattened, words);
    });

    test('durée proportionnelle au nombre de mots du bloc', () {
      // wpm 600 => 100 ms/mot. Blocs [2,2,1] => durées [200,200,100].
      final steps = buildPacerSchedule(words, wpm: 600, chunkSize: 2);
      expect(steps.map((s) => s.duration).toList(), const [
        Duration(milliseconds: 200),
        Duration(milliseconds: 200),
        Duration(milliseconds: 100),
      ]);
    });

    test('les débuts sont cumulés et strictement croissants', () {
      final steps = buildPacerSchedule(words, wpm: 600, chunkSize: 2);
      expect(steps.map((s) => s.start).toList(), const [
        Duration.zero,
        Duration(milliseconds: 200),
        Duration(milliseconds: 400),
      ]);
      for (var i = 1; i < steps.length; i++) {
        expect(steps[i].start, steps[i - 1].start + steps[i - 1].duration);
      }
    });

    test('liste vide -> planning vide', () {
      expect(buildPacerSchedule(const [], wpm: 300, chunkSize: 2), isEmpty);
    });

    test('refuse un wpm <= 0', () {
      expect(
        () => buildPacerSchedule(words, wpm: 0, chunkSize: 2),
        throwsArgumentError,
      );
    });
  });
}
