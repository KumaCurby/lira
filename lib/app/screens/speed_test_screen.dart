import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/effective_wpm.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';
import '../widgets/take_notes_button.dart';

enum _Phase { reading, quiz, result }

/// Test de vitesse : lecture chronométrée → quiz → résultat (mpm + compréhension).
class SpeedTestScreen extends ConsumerStatefulWidget {
  const SpeedTestScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends ConsumerState<SpeedTestScreen> {
  _Phase _phase = _Phase.reading;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsed = Duration.zero;
  int _wpm = 0;
  double? _comprehension;
  late List<int?> _answers = List<int?>.filled(
    widget.text.questions.length,
    null,
  );
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  void _finishReading() {
    _stopwatch.stop();
    _elapsed = _stopwatch.elapsed;
    _wpm = _elapsed > Duration.zero
        ? wordsPerMinute(wordCount: widget.text.wordCount, elapsed: _elapsed)
        : 0;
    if (widget.text.questions.isEmpty) {
      setState(() => _phase = _Phase.result);
      _save();
    } else {
      setState(() => _phase = _Phase.quiz);
    }
  }

  void _submitQuiz() {
    _comprehension = scoreQuiz(widget.text.questions, _answers).ratio;
    recordQuizToSrs(
      ref,
      textId: widget.text.id,
      questions: widget.text.questions,
      answers: _answers,
    );
    setState(() => _phase = _Phase.result);
    _save();
  }

  Future<void> _save() async {
    if (_saved) return;
    _saved = true;
    await recordSession(
      ref,
      ReadingSession(
        type: ExerciseType.speedTest,
        wordCount: widget.text.wordCount,
        elapsed: _elapsed,
        wpm: _wpm,
        comprehension: _comprehension,
        textId: widget.text.id,
        date: ref.read(clockProvider).now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.text.title)),
      body: switch (_phase) {
        _Phase.reading => _reading(),
        _Phase.quiz => _quiz(),
        _Phase.result => _result(),
      },
    );
  }

  Widget _reading() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.text.body,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(height: 1.6),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton.icon(
              onPressed: _finishReading,
              icon: const Icon(Icons.check),
              label: Text(AppLocalizations.of(context)!.doneReading),
            ),
          ),
        ),
      ],
    );
  }

  Widget _quiz() {
    final allAnswered = !_answers.contains(null);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: QuizView(
              questions: widget.text.questions,
              onChanged: (answers) => setState(() => _answers = answers),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
              onPressed: allAnswered ? _submitQuiz : null,
              child: Text(AppLocalizations.of(context)!.validate),
            ),
          ),
        ),
      ],
    );
  }

  Widget _result() {
    final effective = _comprehension == null
        ? null
        : effectiveWpm(wpm: _wpm, comprehension: _comprehension!);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ResultCard(
            wpm: _wpm,
            comprehension: _comprehension,
            effectiveWpm: effective,
          ),
          const SizedBox(height: 20),
          TakeNotesButton(text: widget.text),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.finish),
          ),
        ],
      ),
    );
  }
}
