import '../../domain/measure/reading_session.dart';

Map<String, dynamic> sessionToJson(ReadingSession session) => {
  'type': session.type.name,
  'wordCount': session.wordCount,
  'elapsedMs': session.elapsed.inMilliseconds,
  'wpm': session.wpm,
  'date': session.date.toIso8601String(),
  if (session.comprehension != null) 'comprehension': session.comprehension,
  if (session.textId != null) 'textId': session.textId,
};

ReadingSession sessionFromJson(Map<String, dynamic> json) => ReadingSession(
  type: ExerciseType.values.byName(json['type'] as String),
  wordCount: json['wordCount'] as int,
  elapsed: Duration(milliseconds: json['elapsedMs'] as int),
  wpm: json['wpm'] as int,
  date: DateTime.parse(json['date'] as String),
  comprehension: (json['comprehension'] as num?)?.toDouble(),
  textId: json['textId'] as String?,
);
