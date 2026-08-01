import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/keywords/function_words.dart';
import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/scramble/scramble_stats.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';
import '../widgets/take_notes_button.dart';

/// Intensité d'estompage des mots-outils.
enum _KwMode { normal, dim, content }

enum _Phase { read, quiz, result }

/// Lecture mots-clés : les mots-outils (le, la, les, dans, sur…) sont estompés
/// pour que l'œil se pose sur les mots porteurs de sens → on lit plus vite sans
/// perdre la compréhension (vérifiée par le quiz).
class KeywordsScreen extends ConsumerStatefulWidget {
  const KeywordsScreen({super.key, required this.text});

  final ReadingText text;

  @override
  ConsumerState<KeywordsScreen> createState() => _KeywordsScreenState();
}

class _KeywordsScreenState extends ConsumerState<KeywordsScreen> {
  _Phase _phase = _Phase.read;
  _KwMode _mode = _KwMode.dim;
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
        type: ExerciseType.keywords,
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
    final baseStyle = Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(height: 1.9);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            l10n.keywordsHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text.rich(
              TextSpan(
                style: baseStyle,
                children: _spans(widget.text.body, _mode, scheme),
              ),
            ),
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
                    for (final m in _KwMode.values)
                      ChoiceChip(
                        selected: _mode == m,
                        onSelected: (_) => setState(() => _mode = m),
                        label: Text(_modeName(l10n, m)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
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

  String _modeName(AppLocalizations l10n, _KwMode mode) => switch (mode) {
    _KwMode.normal => l10n.kwNormal,
    _KwMode.dim => l10n.kwDim,
    _KwMode.content => l10n.kwContent,
  };

  /// Estompe les mots-outils selon le mode : gris (dim) ou quasi invisible
  /// (content). Les autres mots (contenu) restent en pleine couleur.
  List<InlineSpan> _spans(String text, _KwMode mode, ColorScheme scheme) {
    if (mode == _KwMode.normal) return [TextSpan(text: text)];
    final fwStyle = TextStyle(
      color: scheme.onSurface.withValues(
        alpha: mode == _KwMode.content ? 0.14 : 0.38,
      ),
    );
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in RegExp(r"[\p{L}']+", unicode: true).allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final word = m[0]!;
      spans.add(
        TextSpan(text: word, style: isFunctionWord(word) ? fwStyle : null),
      );
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
    return spans;
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
    final settings = ref.watch(settingsProvider);
    final sessions = ref.watch(sessionsProvider).valueOrNull ?? const [];
    final refWpm = referenceReadingWpm(sessions, fallback: settings.defaultWpm);
    final percent = refWpm > 0 ? (_wpm / refWpm * 100).round() : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ResultCard(wpm: _wpm, comprehension: _comprehension),
          if (percent != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.compare_arrows, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.keywordsSpeedTitle,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(l10n.scrambleSpeedCompare(percent, refWpm)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
