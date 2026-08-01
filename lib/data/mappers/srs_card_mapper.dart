import '../../domain/srs/srs_card.dart';

Map<String, dynamic> srsCardToJson(SrsCard c) => {
  'textId': c.textId,
  'cardKey': c.cardKey,
  'interval': c.interval,
  'ease': c.ease,
  'repetitions': c.repetitions,
  'dueDate': c.dueDate.toIso8601String(),
};

SrsCard srsCardFromJson(Map<String, dynamic> json) => SrsCard(
  textId: json['textId'] as String,
  cardKey: json['cardKey'] as String,
  interval: json['interval'] as int,
  ease: (json['ease'] as num).toDouble(),
  repetitions: json['repetitions'] as int,
  dueDate: DateTime.parse(json['dueDate'] as String),
);
