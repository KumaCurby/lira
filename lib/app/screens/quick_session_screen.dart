import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../exercise_catalog.dart';
import '../navigation.dart';
import '../theme.dart';
import 'text_picker_screen.dart';

/// LR21 — Séance combinée « 15 min » : trois exercices enchaînés — Guidage
/// (échauffement), RSVP (entraînement), Test de vitesse (mesure). Chaque étape
/// se déverrouille en revenant de la précédente.
class QuickSessionScreen extends ConsumerStatefulWidget {
  const QuickSessionScreen({super.key});

  @override
  ConsumerState<QuickSessionScreen> createState() => _QuickSessionScreenState();
}

class _QuickSessionScreenState extends ConsumerState<QuickSessionScreen> {
  int _step = 0;
  static const List<ExerciseType> _sequence = [
    ExerciseType.pacer,
    ExerciseType.rsvp,
    ExerciseType.speedTest,
  ];

  Future<void> _openStep(int i) async {
    final info = exerciseCatalog.firstWhere((e) => e.type == _sequence[i]);
    ReadingText? chosen;
    if (info.needsText) {
      chosen = await Navigator.of(context).push<ReadingText>(
        MaterialPageRoute(
          builder: (_) => TextPickerScreen(info: info, returnText: true),
        ),
      );
      if (chosen == null || !mounted) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => exerciseScreenFor(info.type, chosen)),
    );
    if (mounted) setState(() => _step = i + 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.quickSessionTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quickSessionHero,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.quickSessionSubtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _sequence.length; i++)
            _StepCard(
              index: i,
              info: exerciseCatalog.firstWhere((e) => e.type == _sequence[i]),
              phase: i < _step
                  ? _StepPhase.done
                  : (i == _step ? _StepPhase.current : _StepPhase.upcoming),
              onTap: i == _step ? () => _openStep(i) : null,
              l10n: l10n,
            ),
          if (_step >= _sequence.length) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.quickSessionDone,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _StepPhase { upcoming, current, done }

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.info,
    required this.phase,
    required this.onTap,
    required this.l10n,
  });

  final int index;
  final ExerciseInfo info;
  final _StepPhase phase;
  final VoidCallback? onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final done = phase == _StepPhase.done;
    final current = phase == _StepPhase.current;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: current
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: done ? AppColors.primary : AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseTitle(l10n, info.type),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: done
                            ? Theme.of(context).colorScheme.outline
                            : null,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      exerciseSubtitle(l10n, info.type),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (current) const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
