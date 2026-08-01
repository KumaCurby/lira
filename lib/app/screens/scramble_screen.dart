import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/random/seeded_random_source.dart';
import '../../domain/measure/comprehension_score.dart';
import '../../domain/measure/reading_session.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/scramble/scramble_sentences.dart';
import '../../domain/scramble/scramble_stats.dart';
import '../../domain/scramble/scramble_word.dart';
import '../../domain/settings/reading_settings.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/quiz_view.dart';
import '../widgets/result_card.dart';
import '../widgets/take_notes_button.dart';

/// Deux exercices frères partagent cet écran : mélange des **lettres**
/// (typoglycémie) ou de l'**ordre des mots** d'une phrase.
enum ScrambleMode { letters, words }

enum _Phase { read, quiz, result }

/// Mots mélangés / Phrases mélangées : on lit malgré le désordre → quiz
/// éventuel → résultat (mpm de lecture + comparaison à la vitesse normale).
class ScrambleScreen extends ConsumerStatefulWidget {
  const ScrambleScreen({
    super.key,
    required this.text,
    this.mode = ScrambleMode.letters,
  });

  final ReadingText text;
  final ScrambleMode mode;

  @override
  ConsumerState<ScrambleScreen> createState() => _ScrambleScreenState();
}

class _ScrambleScreenState extends ConsumerState<ScrambleScreen> {
  late final String _scrambled;
  late final List<String> _originalWords;
  late final List<TapGestureRecognizer> _wordTaps;

  _Phase _phase = _Phase.read;
  bool _showOriginal = false;
  int? _revealed;
  int _hints = 0;
  Timer? _revealTimer;

  bool _timed = false;
  int _budget = 0;
  int _remaining = 0;
  Timer? _countdown;

  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsed = Duration.zero;
  int _wpm = 0;
  double? _comprehension;
  late List<int?> _answers = List<int?>.filled(
    widget.text.questions.length,
    null,
  );
  bool _saved = false;

  ExerciseType get _type => widget.mode == ScrambleMode.words
      ? ExerciseType.wordScramble
      : ExerciseType.scramble;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);

    // Source d'aléatoire : stable (graine = id du texte) ou variée (#10).
    final random = settings.scrambleStable
        ? SeededRandomSource(stableSeed(widget.text.id))
        : ref.read(randomSourceProvider);

    if (widget.mode == ScrambleMode.words) {
      _scrambled = scrambleWordOrder(widget.text.body, random);
      _originalWords = const [];
      _wordTaps = const [];
    } else {
      // Intensité → longueur minimale + dérangement (#1).
      final (minLen, derange) = switch (settings.scrambleIntensity) {
        ScrambleIntensity.easy => (6, false),
        ScrambleIntensity.medium => (kScrambleMinLength, false),
        ScrambleIntensity.hard => (kScrambleMinLength, true),
      };
      _scrambled = scrambleText(
        widget.text.body,
        random,
        minLength: minLen,
        derange: derange,
      );
      _originalWords = [
        for (final m in scrambleWordPattern.allMatches(widget.text.body)) m[0]!,
      ];
      _wordTaps = [
        for (var i = 0; i < _originalWords.length; i++)
          TapGestureRecognizer()..onTap = () => _reveal(i),
      ];
    }

    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowIntro());
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _countdown?.cancel();
    for (final r in _wordTaps) {
      r.dispose();
    }
    super.dispose();
  }

  /// #4 — explication de la typoglycémie, une seule fois.
  void _maybeShowIntro() {
    final settings = ref.read(settingsProvider);
    if (settings.scrambleIntroSeen || !mounted) return;
    ref
        .read(settingsProvider.notifier)
        .update(settings.copyWith(scrambleIntroSeen: true));
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.introTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.introBody, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.introGotIt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// #2 — entrevoir un mot en clair ~1,5 s (compte un coup de pouce).
  void _reveal(int index) {
    if (_phase != _Phase.read) return;
    setState(() {
      _revealed = index;
      _hints++;
    });
    _revealTimer?.cancel();
    _revealTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _revealed = null);
    });
  }

  /// #5 — chrono : budget = motsⁿ / vitesse de référence ; auto-fin à 0.
  void _toggleTimed(bool on) {
    _countdown?.cancel();
    if (on) {
      final sessions = ref.read(sessionsProvider).valueOrNull ?? const [];
      final refWpm = referenceReadingWpm(
        sessions,
        fallback: ref.read(settingsProvider).defaultWpm,
      );
      _budget = (widget.text.wordCount / (refWpm <= 0 ? 250 : refWpm) * 60)
          .round();
      if (_budget < 10) _budget = 10;
      _remaining = _budget;
      _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() => _remaining--);
        if (_remaining <= 0) {
          t.cancel();
          _finishReading();
        }
      });
    }
    setState(() => _timed = on);
  }

  void _finishReading() {
    if (_phase != _Phase.read) return;
    _countdown?.cancel();
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
        type: _type,
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
    final settings = ref.watch(settingsProvider);
    final emphasis = settings.scrambleEmphasis;
    final isWords = widget.mode == ScrambleMode.words;
    final nextMode = ScrambleEmphasis
        .values[(emphasis.index + 1) % ScrambleEmphasis.values.length];
    final comfort = settings.scrambleComfort;
    final baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      height: comfort ? 2.5 : 1.9,
      letterSpacing: comfort ? 1.2 : null,
      fontSize: comfort ? 20 : null,
    );
    final display = _showOriginal ? widget.text.body : _scrambled;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            isWords ? l10n.wordsHint : l10n.scrambleHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        if (_timed)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _budget == 0 ? 0 : _remaining / _budget,
                      minHeight: 6,
                      color: _remaining <= 5 ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$_remaining s',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: isWords
                ? Text(display, style: baseStyle)
                : Text.rich(
                    TextSpan(
                      style: baseStyle,
                      children: _spans(display, emphasis, scheme),
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
                if (!isWords)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      l10n.scrambleTapHint,
                      style: TextStyle(fontSize: 12, color: scheme.outline),
                    ),
                  ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    if (!isWords)
                      ActionChip(
                        avatar: const Icon(Icons.flag_outlined, size: 18),
                        tooltip: l10n.scrambleMarkers,
                        label: Text(_emphasisName(l10n, emphasis)),
                        onPressed: () => ref
                            .read(settingsProvider.notifier)
                            .update(
                              settings.copyWith(scrambleEmphasis: nextMode),
                            ),
                      ),
                    FilterChip(
                      selected: _showOriginal,
                      onSelected: (v) => setState(() => _showOriginal = v),
                      avatar: Icon(
                        _showOriginal ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                      ),
                      label: Text(l10n.scrambleShowOriginal),
                    ),
                    FilterChip(
                      selected: _timed,
                      onSelected: _toggleTimed,
                      avatar: const Icon(Icons.timer_outlined, size: 18),
                      label: Text(l10n.scrambleTimed),
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

  String _emphasisName(AppLocalizations l10n, ScrambleEmphasis mode) =>
      switch (mode) {
        ScrambleEmphasis.colorEnds => l10n.markColorEnds,
        ScrambleEmphasis.dimMiddle => l10n.markDimMiddle,
        ScrambleEmphasis.underline => l10n.markUnderline,
        ScrambleEmphasis.none => l10n.markNone,
      };

  /// Met en avant les repères (1re/dernière lettre) selon le mode, et rend chaque
  /// mot **tapable** pour l'entrevoir en clair (#2). Le mot entrevu s'affiche
  /// surligné à sa place.
  List<InlineSpan> _spans(
    String text,
    ScrambleEmphasis mode,
    ColorScheme scheme,
  ) {
    final endStyle = switch (mode) {
      ScrambleEmphasis.colorEnds => const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
      ),
      ScrambleEmphasis.underline => const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        decoration: TextDecoration.underline,
      ),
      _ => null,
    };
    final midStyle = mode == ScrambleEmphasis.dimMiddle
        ? TextStyle(color: scheme.onSurface.withValues(alpha: 0.35))
        : null;
    final revealStyle = TextStyle(
      color: AppColors.primary,
      backgroundColor: AppColors.primarySoft.withValues(alpha: 0.7),
      fontWeight: FontWeight.w700,
    );

    final spans = <InlineSpan>[];
    var last = 0;
    var wi = 0;
    for (final m in scrambleWordPattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final word = m[0]!;
      final recognizer = wi < _wordTaps.length ? _wordTaps[wi] : null;

      if (_revealed == wi && wi < _originalWords.length) {
        spans.add(
          TextSpan(
            text: _originalWords[wi],
            style: revealStyle,
            recognizer: recognizer,
          ),
        );
      } else if (word.length >= kScrambleMinLength &&
          mode != ScrambleEmphasis.none) {
        spans.add(
          TextSpan(
            text: word.substring(0, 1),
            style: endStyle,
            recognizer: recognizer,
          ),
        );
        spans.add(
          TextSpan(
            text: word.substring(1, word.length - 1),
            style: midStyle,
            recognizer: recognizer,
          ),
        );
        spans.add(
          TextSpan(
            text: word.substring(word.length - 1),
            style: endStyle,
            recognizer: recognizer,
          ),
        );
      } else {
        spans.add(TextSpan(text: word, recognizer: recognizer));
      }
      last = m.end;
      wi++;
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
                          l10n.scrambleSpeedTitle,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(l10n.scrambleSpeedCompare(percent, refWpm)),
                        if (_hints > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            l10n.scrambleHints(_hints),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
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
