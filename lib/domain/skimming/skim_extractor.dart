import '../text/sentence_splitter.dart';

/// LR7 — Extrait la « vue survol » d'un texte : la première phrase (phrase-sujet)
/// de chaque paragraphe. Base de l'exercice d'écrémage : on lit vite ces lignes
/// pour saisir l'idée générale avant de répondre au quiz.
List<String> extractSkimLines(String text) {
  final lines = <String>[];
  for (final paragraph in splitParagraphs(text)) {
    final sentences = splitSentences(paragraph);
    if (sentences.isNotEmpty) lines.add(sentences.first);
  }
  return lines;
}
