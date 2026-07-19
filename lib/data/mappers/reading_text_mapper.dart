import '../../domain/measure/comprehension_score.dart';
import '../../domain/text/reading_text.dart';

Map<String, dynamic> questionToJson(Question question) => {
  'prompt': question.prompt,
  'options': question.options,
  'correctIndex': question.correctIndex,
};

Question questionFromJson(Map<String, dynamic> json) => Question(
  prompt: json['prompt'] as String,
  options: (json['options'] as List).cast<String>(),
  correctIndex: json['correctIndex'] as int,
);

Map<String, dynamic> readingTextToJson(ReadingText text) => {
  'id': text.id,
  'title': text.title,
  'body': text.body,
  'source': text.source.name,
  if (text.difficulty != null) 'difficulty': text.difficulty,
  if (text.scanTarget != null) 'scanTarget': text.scanTarget,
  if (text.bookId != null) 'bookId': text.bookId,
  if (text.bookTitle != null) 'bookTitle': text.bookTitle,
  if (text.partIndex != null) 'partIndex': text.partIndex,
  'questions': text.questions.map(questionToJson).toList(),
};

ReadingText readingTextFromJson(Map<String, dynamic> json) => ReadingText(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  source: json['source'] == null
      ? TextSource.builtin
      : TextSource.values.byName(json['source'] as String),
  difficulty: json['difficulty'] as int?,
  scanTarget: json['scanTarget'] as String?,
  bookId: json['bookId'] as String?,
  bookTitle: json['bookTitle'] as String?,
  partIndex: json['partIndex'] as int?,
  questions:
      (json['questions'] as List?)
          ?.map((e) => questionFromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);
