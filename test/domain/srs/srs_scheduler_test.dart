import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/srs/srs_card.dart';
import 'package:lecture_rapide/domain/srs/srs_scheduler.dart';

final _now = DateTime(2026, 1, 15, 10);

SrsCard _fresh() => SrsCard.fresh(textId: 't1', cardKey: 'q:0', now: _now);

void main() {
  group('scheduleNext (LR13)', () {
    test('good sur carte neuve : intervalle 1 jour, ease intact', () {
      final next = scheduleNext(_fresh(), SrsAnswer.good, now: _now);
      expect(next.interval, 1);
      expect(next.repetitions, 1);
      expect(next.ease, 2.5);
      expect(next.dueDate, _now.add(const Duration(days: 1)));
    });

    test('good deux fois : intervalles 1 puis 3 jours', () {
      final a = scheduleNext(_fresh(), SrsAnswer.good, now: _now);
      final b = scheduleNext(
        a,
        SrsAnswer.good,
        now: _now.add(const Duration(days: 1)),
      );
      expect(b.interval, 3);
      expect(b.repetitions, 2);
    });

    test('good trois fois : croissance ~ ease (2.5)', () {
      var c = _fresh();
      for (var i = 0; i < 3; i++) {
        c = scheduleNext(c, SrsAnswer.good, now: _now);
      }
      // 3e réponse : interval = 3 * 2.5 = 7-8
      expect(c.interval, inInclusiveRange(7, 8));
      expect(c.repetitions, 3);
    });

    test('again : intervalle 1 jour, reps réinitialisées, ease diminue', () {
      final trained = scheduleNext(
        scheduleNext(_fresh(), SrsAnswer.good, now: _now),
        SrsAnswer.good,
        now: _now.add(const Duration(days: 1)),
      );
      final failed = scheduleNext(trained, SrsAnswer.again, now: _now);
      expect(failed.interval, 1);
      expect(failed.repetitions, 0);
      expect(failed.ease, lessThan(trained.ease));
      expect(failed.ease, greaterThanOrEqualTo(kSrsEaseFloor));
    });

    test('hard : reps++, croissance ralentie', () {
      var c = _fresh();
      c = scheduleNext(c, SrsAnswer.good, now: _now); // interval 1
      final hard = scheduleNext(c, SrsAnswer.hard, now: _now);
      expect(hard.repetitions, 2);
      expect(hard.interval, greaterThan(0));
      expect(hard.ease, lessThan(c.ease));
    });

    test('easy : ease augmente, croissance accélérée', () {
      var c = _fresh();
      c = scheduleNext(c, SrsAnswer.good, now: _now);
      c = scheduleNext(c, SrsAnswer.good, now: _now);
      final easy = scheduleNext(c, SrsAnswer.easy, now: _now);
      expect(easy.ease, greaterThan(c.ease));
      // 3e réponse easy = interval*ease*1.3 > interval*ease (good)
      final good = scheduleNext(c, SrsAnswer.good, now: _now);
      expect(easy.interval, greaterThan(good.interval));
    });

    test('ease ne descend pas sous 1.3', () {
      var c = _fresh();
      for (var i = 0; i < 20; i++) {
        c = scheduleNext(c, SrsAnswer.again, now: _now);
      }
      expect(c.ease, kSrsEaseFloor);
    });
  });

  group('dueCards (LR13)', () {
    test('ne renvoie que les cartes échues, triées par dueDate', () {
      final past = _fresh().copyWith(
        dueDate: _now.subtract(const Duration(days: 2)),
      );
      final now = _fresh().copyWith(dueDate: _now);
      final future = _fresh().copyWith(
        dueDate: _now.add(const Duration(days: 1)),
      );
      final due = dueCards([future, now, past], now: _now);
      expect(due, [past, now]); // triés par urgence
    });

    test('carte à l\'heure pile est due', () {
      final c = _fresh().copyWith(dueDate: _now);
      expect(dueCards([c], now: _now), [c]);
    });
  });
}
