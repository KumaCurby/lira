import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/take_notes_button.dart';

enum _Phase { rsvp, quiz, result }

/// LR18 — Vitesse plafond : RSVP dont la vitesse **augmente automatiquement**
/// jusqu'à ce que l'utilisateur touche « STOP je perds ». Le quiz final valide
/// si le plafond est réel (compréhension conservée) ou fantasmé.
class SpeedCapScreen extends ConsumerStatefulWidget {
  const SpeedCapScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<SpeedCapScreen> createState() => _SpeedCapScreenState();
}

class _SpeedCapScreenState extends ConsumerState<SpeedCapScreen> {
  _Phase _phase = _Phase.rsvp;
  late final List<String> _words = widget.text.body.split(RegExp(r'\s+'))
    ..removeWhere((w) => w.isEmpty);
  int _index = 0;
  int _wpm = 250;
  Timer? _wordTimer;
  Timer? _rampTimer;
  double? _comprehension;
  late List<int?> _answers = List<int?>.filled(
    widget.text.questions.length,
    null,
  );
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _scheduleNextWord();
    _rampTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      setState(() => _wpm += 25);
      _scheduleNextWord();
    });
  }

  @override
  void dispose() {
    _wordTimer?.cancel();
    _rampTimer?.cancel();
    super.dispose();
  }

  void _scheduleNextWord() {
    _wordTimer?.cancel();
    final period = Duration(milliseconds: (60000 / _wpm).round());
    _wordTimer = Timer.periodic(period, (_) {
      if (!mounted) return;
      setState(() => _index++);
      if (_index >= _words.length) _stop();
    });
  }

  void _stop() {
    _wordTimer?.cancel();
    _rampTimer?.cancel();
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
        type: ExerciseType.speedCap,
        wordCount: _index,
        elapsed: Duration.zero,
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
      appBar: AppBar(title: Text(l10n.exSpeedCapTitle)),
      body: switch (_phase) {
        _Phase.rsvp => _rsvp(l10n),
        _Phase.quiz => _quiz(l10n),
        _Phase.result => _result(l10n),
      },
    );
  }

  Widget _rsvp(AppLocalizations l10n) {
    final currentWord = _index < _words.length ? _words[_index] : '';
    final validated = _comprehension != null && _comprehension! >= 0.7;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.primarySoft.withValues(alpha: 0.4),
          child: Text(
            l10n.speedCapHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_wpm ${l10n.unitWpm}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currentWord,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (validated) ...[
                  const SizedBox(height: 16),
                  Text(l10n.speedCapValidated),
                ],
              ],
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
                onPressed: _stop,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                ),
                icon: const Icon(Icons.stop_circle),
                label: Text(l10n.speedCapStop),
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
    final validated = _comprehension != null && _comprehension! >= 0.7;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: validated
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  l10n.speedCapCeiling,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '$_wpm',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l10n.unitWpm,
                  style: const TextStyle(color: Colors.white70),
                ),
                if (_comprehension != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    validated
                        ? l10n.speedCapReal((_comprehension! * 100).round())
                        : l10n.speedCapFake((_comprehension! * 100).round()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ],
            ),
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
