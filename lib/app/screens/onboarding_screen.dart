import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/word_counter.dart';
import '../../domain/measure/wpm_calculator.dart';
import '../../domain/progress/goal.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';

const String _onboardingText =
    "La lecture rapide n'est pas un don réservé à quelques privilégiés : c'est "
    "une compétence qui s'entraîne, comme un muscle. La plupart d'entre nous "
    "lisons en prononçant mentalement chaque mot, une habitude prise à l'école "
    "qui limite fortement notre vitesse. En apprenant à voir les mots par "
    "groupes plutôt qu'un à un, et en réduisant cette petite voix intérieure, "
    "on peut lire bien plus vite sans rien perdre en compréhension. Les "
    "exercices réguliers font toute la différence : quelques minutes par jour "
    "suffisent pour progresser de façon visible en quelques semaines. "
    "L'important n'est pas de battre des records, mais de trouver un rythme "
    "confortable où l'esprit reste attentif et où le plaisir de lire demeure "
    "intact. Alors, prêt à découvrir de quoi tu es déjà capable ? Lis ce court "
    "texte tranquillement, comme tu le ferais d'habitude.";

enum _Phase { welcome, reading, result }

/// Onboarding du premier lancement : mesure la vitesse initiale et propose un
/// objectif. À la fin, marque [ReadingSettings.hasOnboarded].
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _Phase _phase = _Phase.welcome;
  final Stopwatch _stopwatch = Stopwatch();
  int _measuredWpm = 0;
  int _goal = 400;

  void _startReading() {
    _stopwatch
      ..reset()
      ..start();
    setState(() => _phase = _Phase.reading);
  }

  void _finishReading() {
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsed;
    final words = countWords(_onboardingText);
    _measuredWpm = elapsed > Duration.zero
        ? wordsPerMinute(wordCount: words, elapsed: elapsed)
        : 0;
    _goal = suggestGoalWpm(_measuredWpm == 0 ? 250 : _measuredWpm);
    setState(() => _phase = _Phase.result);
  }

  Future<void> _finish() async {
    final settings = ref.read(settingsProvider);
    await ref
        .read(settingsProvider.notifier)
        .update(
          settings.copyWith(
            hasOnboarded: true,
            targetWpm: _goal,
            defaultWpm: _measuredWpm.clamp(100, 800),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: switch (_phase) {
          _Phase.welcome => _welcome(),
          _Phase.reading => _reading(),
          _Phase.result => _result(),
        },
      ),
    );
  }

  Widget _welcome() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, size: 104, color: AppColors.primary),
          ),
          const SizedBox(height: 44),
          Text(
            l10n.onbTitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onbSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkSoft, height: 1.5),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _startReading,
              icon: const Icon(Icons.timer_outlined),
              label: Text(l10n.onbMeasure),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reading() {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: scheme.secondaryContainer,
          child: Text(
            l10n.onbReadHint,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              _onboardingText,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(height: 1.6),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton.icon(
            onPressed: _finishReading,
            icon: const Icon(Icons.check),
            label: Text(l10n.onbFinishReading),
          ),
        ),
      ],
    );
  }

  Widget _result() {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onbYourSpeed, textAlign: TextAlign.center),
          Text(
            '$_measuredWpm mpm',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onbGoalLabel(_goal),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: _goal.toDouble(),
            min: 200,
            max: 800,
            divisions: 30,
            label: '$_goal',
            onChanged: (v) => setState(() => _goal = v.round()),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _finish, child: Text(l10n.onbStart)),
        ],
      ),
    );
  }
}
