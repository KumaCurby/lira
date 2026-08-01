import '../../domain/notes/text_note.dart';

Map<String, dynamic> textNoteToJson(TextNote n) => {
  'id': n.id,
  'textId': n.textId,
  'createdAt': n.createdAt.toIso8601String(),
  if (n.summary != null) 'summary': n.summary,
  if (n.cues != null) 'cues': n.cues,
  if (n.notes != null) 'notes': n.notes,
};

TextNote textNoteFromJson(Map<String, dynamic> json) => TextNote(
  id: json['id'] as String,
  textId: json['textId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  summary: json['summary'] as String?,
  cues: json['cues'] as String?,
  notes: json['notes'] as String?,
);
