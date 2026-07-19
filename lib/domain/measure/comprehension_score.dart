/// LR2 — Une question de compréhension à choix multiple.
class Question {
  const Question({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
}

/// LR2 — Résultat d'un quiz : nombre de bonnes réponses sur le total.
class ComprehensionResult {
  const ComprehensionResult({required this.correct, required this.total});

  final int correct;
  final int total;

  /// Taux de réussite dans [0, 1] (0 si le quiz est vide).
  double get ratio => total == 0 ? 0 : correct / total;
}

/// LR2 — Corrige un quiz. Une réponse `null` (non répondue) compte comme fausse.
ComprehensionResult scoreQuiz(List<Question> questions, List<int?> answers) {
  if (answers.length != questions.length) {
    throw ArgumentError(
      'answers (${answers.length}) doit avoir la longueur de questions '
      '(${questions.length})',
    );
  }
  var correct = 0;
  for (var i = 0; i < questions.length; i++) {
    if (answers[i] == questions[i].correctIndex) correct++;
  }
  return ComprehensionResult(correct: correct, total: questions.length);
}
