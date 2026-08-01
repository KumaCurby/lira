import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';

enum _Phase { read, quiz, result }

/// LR15 — Anti-subvocalisation : lis un texte en suivant du regard un compteur
/// qui bat rapidement (1-2-3-4). Compter mentalement occupe la voix intérieure
/// et t'oblige à reconnaître les mots par leur forme.
class NoSubvocalScreen extends ConsumerStatefulWidget {
  const NoSubvocalScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<NoSubvocalScreen> createState() => _NoSubvocalScreenState();
}

class _NoSubvocalScreenState extends ConsumerState<NoSubvocalScreen> {
  _Phase _phase = _Phase.read;
  int _tempoBpm = 120;
  int _beat = 1;
  Timer? _metronome;

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
    _startMetronome();
  }

  @override
  void dispose() {
    _metronome?.cancel();
    super.dispose();
  }

  void _startMetronome() {
    _metronome?.cancel();
    final period = Duration(milliseconds: (60000 / _tempoBpm).round());
    _metronome = Timer.periodic(period, (_) {
      if (!mounted) return;
      setState(() => _beat = _beat >= 4 ? 1 : _beat + 1);
    });
  }

  void _finishReading() {
    _metronome?.cancel();
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
        type: ExerciseType.noSubvocal,
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
        _Phase.read => _read(),
        _Phase.quiz => _quiz(),
        _Phase.result => _result(),
      },
    );
  }

  Widget _read() {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            l10n.noSubvocalHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        Expanded(
          child: Row(
            children: [
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
              _BeatIndicator(beat: _beat),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Text(l10n.noSubvocalTempo(_tempoBpm)),
                Slider(
                  value: _tempoBpm.toDouble(),
                  min: 60,
                  max: 200,
                  divisions: 14,
                  label: '$_tempoBpm',
                  onChanged: (v) {
                    setState(() => _tempoBpm = v.round());
                    _startMetronome();
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _finishReading,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.scrambleDone),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quiz() {
    final l10n = AppLocalizations.of(context)!;
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

  Widget _result() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ResultCard(wpm: _wpm, comprehension: _comprehension),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.finish),
          ),
        ],
      ),
    );
  }
}

class _BeatIndicator extends StatelessWidget {
  const _BeatIndicator({required this.beat});
  final int beat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 1; i <= 4; i++) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 90),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: beat == i ? AppColors.primary : Colors.transparent,
                border: Border.all(color: AppColors.primary, width: 1.5),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$i',
                style: TextStyle(
                  color: beat == i ? Colors.white : AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (i < 4) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
