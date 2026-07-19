import '../../domain/progress/reading_progress.dart';

Map<String, dynamic> readingProgressToJson(ReadingProgress progress) => {
  'textId': progress.textId,
  'wordIndex': progress.wordIndex,
  'wordCount': progress.wordCount,
  'updatedAt': progress.updatedAt.toIso8601String(),
};

ReadingProgress readingProgressFromJson(Map<String, dynamic> json) =>
    ReadingProgress(
      textId: json['textId'] as String,
      wordIndex: json['wordIndex'] as int,
      wordCount: json['wordCount'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
