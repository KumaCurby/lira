import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/skimming/skim_extractor.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';

enum _Phase { skim, quiz, result }

/// Écrémage : survol des phrases-clés → quiz d'idée générale → résultat.
class SkimmingScreen extends ConsumerStatefulWidget {
  const SkimmingScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<SkimmingScreen> createState() => _SkimmingScreenState();
}

class _SkimmingScreenState extends ConsumerState<SkimmingScreen> {
  late final List<String> _skimLines = extractSkimLines(widget.text.body);
  _Phase _phase = _Phase.skim;
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

  void _finishSkim() {
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
    setState(() => _phase = _Phase.result);
    _save();
  }

  Future<void> _save() async {
    if (_saved) return;
    _saved = true;
    await recordSession(
      ref,
      ReadingSession(
        type: ExerciseType.skimming,
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
        _Phase.skim => _skim(),
        _Phase.quiz => _quiz(),
        _Phase.result => _result(),
      },
    );
  }

  Widget _skim() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            AppLocalizations.of(context)!.skimHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final line in _skimLines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.bolt, color: scheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          line,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton.icon(
              onPressed: _finishSkim,
              icon: const Icon(Icons.check),
              label: Text(AppLocalizations.of(context)!.skimDone),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ResultCard(wpm: _wpm, comprehension: _comprehension),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.finish),
          ),
        ],
      ),
    );
  }
}
