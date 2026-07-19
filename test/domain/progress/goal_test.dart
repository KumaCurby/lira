import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/progress/goal.dart';

void main() {
  group('Goal (LR9)', () {
    const goal = Goal(targetWpm: 400);

    test('atteint quand la vitesse atteint ou dépasse la cible', () {
      expect(goal.isReachedBy(420), isTrue);
      expect(goal.isReachedBy(400), isTrue);
      expect(goal.isReachedBy(399), isFalse);
    });

    test('progression bornée à [0, 1]', () {
      expect(goal.progressFrom(200), closeTo(0.5, 1e-9));
      expect(goal.progressFrom(800), 1.0);
      expect(goal.progressFrom(0), 0.0);
    });
  });

  group('suggestGoalWpm', () {
    test('propose environ +30 %, arrondi à la dizaine', () {
      expect(suggestGoalWpm(300), 390);
      expect(suggestGoalWpm(200), 260);
    });

    test('borne le résultat à [250, 800]', () {
      expect(suggestGoalWpm(100), 250); // plancher
      expect(suggestGoalWpm(700), 800); // plafond
    });
  });
}
