import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/text/reading_text.dart';
import '../../domain/wordlen/word_length_span.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';
import '../widgets/take_notes_button.dart';

enum _Mode { highlight, filter }

enum _Phase { read, quiz, result }

/// LR24 — Jeu « Mots par longueur » : choisis une plage (3-4, 5-6, 7+ lettres),
/// vois-les surlignés dans le texte (mode « Voir »), ou uniquement affichés
/// (mode « Filtrer » : les autres sont estompés) → devine le sens. Quiz de
/// compréhension à la fin pour vérifier que tu as bien compris.
class WordLengthScreen extends ConsumerStatefulWidget {
  const WordLengthScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<WordLengthScreen> createState() => _WordLengthScreenState();
}

class _WordLengthScreenState extends ConsumerState<WordLengthScreen> {
  _Phase _phase = _Phase.read;
  WordLengthRange _range = WordLengthRange.medium;
  _Mode _mode = _Mode.highlight;
  late final List<LengthSpan> _spans = tagByWordLength(widget.text.body);

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
        type: ExerciseType.wordLength,
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
    final bounds = rangeBounds(_range);
    final baseStyle = Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(height: 1.9);

    final matchStyle = const TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w800,
    );
    final dimStyle = TextStyle(color: scheme.onSurface.withValues(alpha: 0.25));

    final children = <InlineSpan>[];
    for (final s in _spans) {
      final match =
          s.letters > 0 && s.matches(min: bounds.min, max: bounds.max);
      final letters = s.letters > 0;
      TextStyle? style;
      if (match) {
        style = matchStyle;
      } else if (letters && _mode == _Mode.filter) {
        style = dimStyle;
      }
      children.add(TextSpan(text: s.text, style: style));
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            l10n.wordLengthHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text.rich(TextSpan(style: baseStyle, children: children)),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final r in WordLengthRange.values)
                      ChoiceChip(
                        selected: _range == r,
                        onSelected: (_) => setState(() => _range = r),
                        label: Text(_rangeLabel(l10n, r)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final m in _Mode.values)
                      ChoiceChip(
                        selected: _mode == m,
                        onSelected: (_) => setState(() => _mode = m),
                        label: Text(_modeLabel(l10n, m)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
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

  String _rangeLabel(AppLocalizations l10n, WordLengthRange r) => switch (r) {
    WordLengthRange.short => l10n.wordLengthShort,
    WordLengthRange.medium => l10n.wordLengthMedium,
    WordLengthRange.long => l10n.wordLengthLong,
  };

  String _modeLabel(AppLocalizations l10n, _Mode m) => switch (m) {
    _Mode.highlight => l10n.wordLengthHighlight,
    _Mode.filter => l10n.wordLengthFilter,
  };

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
