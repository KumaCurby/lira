/// LR13 — Une carte de révision espacée (Spaced Repetition System).
///
/// Une carte représente **une chose précise à mémoriser** : une question de
/// compréhension liée à un texte, ou un mot-clé à retenir. Elle porte l'état
/// de l'algo SM-2 simplifié (voir `srs_scheduler.dart`) : `interval` (en jours
/// jusqu'à la prochaine révision), `ease` (multiplicateur de croissance),
/// `repetitions` (succès consécutifs), et `dueDate` (moment de la prochaine
/// révision).
class SrsCard {
  const SrsCard({
    required this.textId,
    required this.cardKey,
    required this.interval,
    required this.ease,
    required this.repetitions,
    required this.dueDate,
  });

  /// Identifiant du texte source.
  final String textId;

  /// Clé stable de la carte à l'intérieur du texte :
  /// - `q:<index>` pour une question de compréhension ;
  /// - `k:<motclé>` pour un mot-clé.
  final String cardKey;

  /// Nombre de jours avant la prochaine révision.
  final int interval;

  /// Facteur de croissance (SM-2, part à 2.5, plancher 1.3).
  final double ease;

  /// Nombre de bonnes réponses consécutives depuis le dernier échec.
  final int repetitions;

  /// Instant de la prochaine révision (l'heure est utile pour ordonner).
  final DateTime dueDate;

  /// Carte fraîche, prête à être planifiée pour la première fois.
  factory SrsCard.fresh({
    required String textId,
    required String cardKey,
    required DateTime now,
  }) => SrsCard(
    textId: textId,
    cardKey: cardKey,
    interval: 0,
    ease: 2.5,
    repetitions: 0,
    dueDate: now,
  );

  SrsCard copyWith({
    int? interval,
    double? ease,
    int? repetitions,
    DateTime? dueDate,
  }) => SrsCard(
    textId: textId,
    cardKey: cardKey,
    interval: interval ?? this.interval,
    ease: ease ?? this.ease,
    repetitions: repetitions ?? this.repetitions,
    dueDate: dueDate ?? this.dueDate,
  );

  @override
  bool operator ==(Object other) =>
      other is SrsCard &&
      other.textId == textId &&
      other.cardKey == cardKey &&
      other.interval == interval &&
      other.ease == ease &&
      other.repetitions == repetitions &&
      other.dueDate == dueDate;

  @override
  int get hashCode =>
      Object.hash(textId, cardKey, interval, ease, repetitions, dueDate);
}
