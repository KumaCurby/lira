import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/random/seeded_random_source.dart';

void main() {
  group('SeededRandomSource', () {
    test('est déterministe : même graine => même séquence', () {
      final a = SeededRandomSource(42);
      final b = SeededRandomSource(42);

      final seqA = List.generate(10, (_) => a.nextInt(100));
      final seqB = List.generate(10, (_) => b.nextInt(100));

      expect(seqA, equals(seqB));
    });

    test('nextInt(max) reste dans [0, max)', () {
      final r = SeededRandomSource(7);
      for (var i = 0; i < 1000; i++) {
        expect(r.nextInt(80), inInclusiveRange(0, 79));
      }
    });

    test('des graines différentes produisent des séquences différentes', () {
      final a = SeededRandomSource(1);
      final b = SeededRandomSource(2);

      final seqA = List.generate(10, (_) => a.nextInt(1000));
      final seqB = List.generate(10, (_) => b.nextInt(1000));

      expect(seqA, isNot(equals(seqB)));
    });
  });
}
