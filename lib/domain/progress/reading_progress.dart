/// Progression de lecture d'un texte : dernière position atteinte (index de mot).
class ReadingProgress {
  const ReadingProgress({
    required this.textId,
    required this.wordIndex,
    required this.wordCount,
    required this.updatedAt,
  });

  final String textId;
  final int wordIndex;
  final int wordCount;
  final DateTime updatedAt;

  /// Avancement dans [0, 1].
  double get fraction =>
      wordCount <= 0 ? 0 : (wordIndex / wordCount).clamp(0.0, 1.0).toDouble();

  /// Vrai si le texte a été lu jusqu'au bout.
  bool get isComplete => wordCount > 0 && wordIndex >= wordCount;
}
