import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/random/secure_random_source.dart';

void main() {
  group('SecureRandomSource', () {
    test('nextInt(max) reste dans [0, max)', () {
      final r = SecureRandomSource();
      for (var i = 0; i < 1000; i++) {
        expect(r.nextInt(50), inInclusiveRange(0, 49));
      }
    });
  });
}
