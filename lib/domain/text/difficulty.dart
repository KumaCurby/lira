import 'sentence_splitter.dart';
import 'tokenizer.dart';

/// Estime une difficulté de lecture de 1 (facile) à 5 (difficile).
///
/// Indice de lisibilité simplifié : plus les mots et les phrases sont longs,
/// plus le texte est réputé difficile. Sert à classer un texte importé.
int estimateDifficulty(String text) {
  final words = tokenizeWords(text);
  if (words.isEmpty) return 1;

  final sentences = splitSentences(text);
  final sentenceCount = sentences.isEmpty ? 1 : sentences.length;

  final totalChars = words.fold<int>(0, (sum, word) => sum + word.length);
  final avgWordLength = totalChars / words.length;
  final avgSentenceLength = words.length / sentenceCount;

  final score = avgWordLength * 0.6 + avgSentenceLength * 0.25;

  if (score < 4) return 1;
  if (score < 5.5) return 2;
  if (score < 7) return 3;
  if (score < 8.5) return 4;
  return 5;
}
