import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/measure/comprehension_score.dart';

void main() {
  const questions = [
    Question(prompt: 'Q1', options: ['a', 'b'], correctIndex: 0),
    Question(prompt: 'Q2', options: ['a', 'b'], correctIndex: 1),
    Question(prompt: 'Q3', options: ['a', 'b'], correctIndex: 0),
  ];

  group('scoreQuiz (LR2)', () {
    test('compte les bonnes réponses et le ratio', () {
      final result = scoreQuiz(questions, [0, 1, 1]); // 2 bonnes sur 3

      expect(result.correct, 2);
      expect(result.total, 3);
      expect(result.ratio, closeTo(2 / 3, 1e-9));
    });

    test('une réponse manquante (null) compte comme fausse', () {
      final result = scoreQuiz(questions, [0, null, null]); // 1 sur 3

      expect(result.correct, 1);
      expect(result.ratio, closeTo(1 / 3, 1e-9));
    });

    test('ratio de 0 pour un quiz sans question', () {
      expect(scoreQuiz(const [], const []).ratio, 0);
    });

    test('refuse des réponses de longueur différente', () {
      expect(() => scoreQuiz(questions, [0]), throwsArgumentError);
    });
  });
}
