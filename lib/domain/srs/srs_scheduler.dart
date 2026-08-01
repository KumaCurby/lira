import 'srs_card.dart';

/// LR13 — Qualité de réponse fournie par l'utilisateur (échelle SM-2 simplifiée).
enum SrsAnswer {
  /// Raté / oublié — la carte redevient neuve.
  again,

  /// Correct mais avec effort — on ralentit la croissance.
  hard,

  /// Correct sans hésitation — croissance normale.
  good,

  /// Trivial — croissance accélérée.
  easy,
}

/// Plancher du facteur d'aisance (SM-2 classique).
const double kSrsEaseFloor = 1.3;

/// Planifie la prochaine révision d'une [card] à partir d'une [answer].
///
/// Algorithme dérivé de SM-2 :
/// - **again** : `interval=1`, `reps=0`, `ease−=0.20` (plancher [kSrsEaseFloor]).
/// - **hard** : `reps++`, `interval=max(1, round(prev*1.2))`, `ease−=0.15`.
/// - **good** : `reps++`, `interval` = 1 → 3 → prev*ease (à partir de la 3e).
/// - **easy** : idem good, avec `interval*=1.3` et `ease+=0.15`.
///
/// La nouvelle `dueDate` est calculée à partir de [now] + interval (en jours,
/// à la même heure de la journée).
SrsCard scheduleNext(SrsCard card, SrsAnswer answer, {required DateTime now}) {
  var ease = card.ease;
  var reps = card.repetitions;
  int interval;

  switch (answer) {
    case SrsAnswer.again:
      ease = _clampEase(ease - 0.20);
      reps = 0;
      interval = 1;
    case SrsAnswer.hard:
      ease = _clampEase(ease - 0.15);
      reps += 1;
      final base = card.interval < 1 ? 1 : card.interval;
      interval = (base * 1.2).round();
      if (interval < 1) interval = 1;
    case SrsAnswer.good:
      reps += 1;
      if (reps == 1) {
        interval = 1;
      } else if (reps == 2) {
        interval = 3;
      } else {
        interval = (card.interval * ease).round();
      }
    case SrsAnswer.easy:
      ease = _clampEase(ease + 0.15);
      reps += 1;
      if (reps == 1) {
        interval = 2;
      } else if (reps == 2) {
        interval = 4;
      } else {
        interval = (card.interval * ease * 1.3).round();
      }
  }

  return card.copyWith(
    ease: ease,
    repetitions: reps,
    interval: interval,
    dueDate: now.add(Duration(days: interval)),
  );
}

double _clampEase(double e) => e < kSrsEaseFloor ? kSrsEaseFloor : e;

/// LR13 — Filtre les cartes dues à [now] (dueDate <= now), triées par urgence.
List<SrsCard> dueCards(Iterable<SrsCard> cards, {required DateTime now}) {
  final due = cards.where((c) => !c.dueDate.isAfter(now)).toList();
  due.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return due;
}
