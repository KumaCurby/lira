import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/rsvp/orp_calculator.dart';

void main() {
  group('orpIndex (LR3)', () {
    test('mot vide ou d\'une lettre -> 0', () {
      expect(orpIndex(''), 0);
      expect(orpIndex('a'), 0);
    });

    test('longueur 2 à 5 -> 1', () {
      for (var n = 2; n <= 5; n++) {
        expect(orpIndex('a' * n), 1, reason: 'longueur $n');
      }
    });

    test('longueur 6 à 9 -> 2', () {
      for (var n = 6; n <= 9; n++) {
        expect(orpIndex('a' * n), 2, reason: 'longueur $n');
      }
    });

    test('longueur 10 à 13 -> 3', () {
      for (var n = 10; n <= 13; n++) {
        expect(orpIndex('a' * n), 3, reason: 'longueur $n');
      }
    });

    test('longueur 14 et plus -> 4', () {
      for (var n = 14; n <= 20; n++) {
        expect(orpIndex('a' * n), 4, reason: 'longueur $n');
      }
    });
  });
}
