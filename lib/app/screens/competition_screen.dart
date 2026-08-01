import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/effective_wpm.dart' as measure;
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/take_notes_button.dart';

enum _Phase { read, quiz, result }

/// LR17 — Mode compétition : lecture chronométrée d'un texte inconnu + quiz →
/// score composite = mpm × compréhension. Le style de la lecture réelle en
/// concours (WRRC-like), avec un gros chrono visible.
class CompetitionScreen extends ConsumerStatefulWidget {
  const CompetitionScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends ConsumerState<CompetitionScreen> {
  _Phase _phase = _Phase.read;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsed = Duration.zero;
  int _wpm = 0;
  double? _comprehension;
  Timer? _tick;
  int _displaySeconds = 0;

  late List<int?> _answers = List<int?>.filled(
    widget.text.questions.length,
    null,
  );
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _tick = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() => _displaySeconds = _stopwatch.elapsed.inSeconds);
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _finishReading() {
    _stopwatch.stop();
    _tick?.cancel();
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
        type: ExerciseType.competition,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exCompetitionTitle)),
      body: switch (_phase) {
        _Phase.read => _read(l10n),
        _Phase.quiz => _quiz(l10n),
        _Phase.result => _result(l10n),
      },
    );
  }

  Widget _read(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.primarySoft.withValues(alpha: 0.6),
          child: Column(
            children: [
              Text(
                '${_displaySeconds}s',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              Text(
                l10n.competitionReadHint,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.text.body,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(height: 1.9),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _finishReading,
                icon: const Icon(Icons.stop),
                label: Text(l10n.competitionDone),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _quiz(AppLocalizations l10n) {
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
              child: Text(l10n.validate),
            ),
          ),
        ),
      ],
    );
  }

  Widget _result(AppLocalizations l10n) {
    final composite = _comprehension == null
        ? null
        : measure.effectiveWpm(wpm: _wpm, comprehension: _comprehension!);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  l10n.competitionScoreLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${composite ?? _wpm}',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l10n.competitionScoreCaption,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: l10n.wpmCaption, value: '$_wpm'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  label: l10n.comprehension,
                  value: _comprehension == null
                      ? '—'
                      : '${(_comprehension! * 100).round()} %',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TakeNotesButton(text: widget.text),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.finish),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
