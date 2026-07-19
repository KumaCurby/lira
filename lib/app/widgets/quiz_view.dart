import 'package:flutter/material.dart';

import '../../domain/measure/comprehension_score.dart';

/// Affiche un quiz de compréhension et remonte les réponses à chaque choix.
class QuizView extends StatefulWidget {
  const QuizView({super.key, required this.questions, required this.onChanged});

  final List<Question> questions;
  final ValueChanged<List<int?>> onChanged;

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final List<int?> _answers = List<int?>.filled(
    widget.questions.length,
    null,
  );

  void _select(int questionIndex, int optionIndex) {
    setState(() => _answers[questionIndex] = optionIndex);
    widget.onChanged(List.of(_answers));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var q = 0; q < widget.questions.length; q++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.questions[q].prompt,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<int>(
                    groupValue: _answers[q],
                    onChanged: (value) {
                      if (value != null) _select(q, value);
                    },
                    child: Column(
                      children: [
                        for (
                          var o = 0;
                          o < widget.questions[q].options.length;
                          o++
                        )
                          RadioListTile<int>(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            value: o,
                            title: Text(widget.questions[q].options[o]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
