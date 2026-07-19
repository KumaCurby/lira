import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/progress/progress_tracker.dart';
import '../../domain/progress/resumable.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../exercise_catalog.dart';
import '../navigation.dart';
import '../providers.dart';
import '../theme.dart';
import 'text_picker_screen.dart';

/// Onglet « Entraînement » : en-tête + hero + objectif + reprise + exercices.
/// Style repris du modèle : cartes arrondies, accent corail.
class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  void _open(BuildContext context, ExerciseInfo info) {
    if (info.needsText) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => TextPickerScreen(info: info)));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => exerciseScreenFor(info.type, null)),
      );
    }
  }

  Future<void> _resume(
    BuildContext context,
    WidgetRef ref,
    ReadingText passage,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => exerciseScreenFor(ExerciseType.rsvp, passage),
      ),
    );
    ref.invalidate(readingProgressProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(textsProvider).valueOrNull ?? const [];
    final progress = ref.watch(readingProgressProvider).valueOrNull ?? const {};
    final resumables = resumableTexts(texts, progress);
    final sessions = ref.watch(sessionsProvider).valueOrNull ?? const [];
    final today = ref.read(clockProvider).now();
    final doneToday = practicedToday(sessions.map((s) => s.date), today: today);
    final streak = currentStreakDays(sessions.map((s) => s.date), today: today);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _Header(streak: streak),
                const SizedBox(height: 16),
                const _HeroBanner(),
                const SizedBox(height: 14),
                _DailyGoalCard(doneToday: doneToday),
                const SizedBox(height: 20),
                if (resumables.isNotEmpty)
                  _ContinueSection(
                    items: resumables,
                    onResume: (passage) => _resume(context, ref, passage),
                  ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 190,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: exerciseCatalog.length,
                  itemBuilder: (context, i) => _ExerciseCard(
                    info: exerciseCatalog[i],
                    onTap: () => _open(context, exerciseCatalog[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// En-tête : logo/marque « Lira » + pastille de série.
class _Header extends StatelessWidget {
  const _Header({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bolt, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text(
          'Lira',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.deepOrange,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.streakDays(streak),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Bannière hero corail (accroche du jour).
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeGreetingTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.homeGreetingSubtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.rocket_launch, color: Colors.white, size: 52),
        ],
      ),
    );
  }
}

/// Bannière « objectif du jour ».
class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.doneToday});

  final bool doneToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: doneToday
                  ? Colors.green.withValues(alpha: 0.15)
                  : AppColors.primarySoft.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              doneToday ? Icons.check_circle : Icons.flag_outlined,
              color: doneToday ? Colors.green : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dailyGoalTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  doneToday ? l10n.dailyGoalDone : l10n.dailyGoalTodo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section horizontale « Continuer » : lectures en cours, reprise en un tap.
class _ContinueSection extends StatelessWidget {
  const _ContinueSection({required this.items, required this.onResume});

  final List<ResumableItem> items;
  final void Function(ReadingText passage) onResume;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            l10n.continueSection,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _ContinueCard(
              item: items[i],
              onTap: () => onResume(items[i].passage),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.item, required this.onTap});

  final ResumableItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: 240,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.resume,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.fraction,
                    minHeight: 6,
                    backgroundColor: AppColors.primarySoft.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(item.fraction * 100).round()} %',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Carte d'exercice (grille), style « produit » du modèle.
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.info, required this.onTap});

  final ExerciseInfo info;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: info.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(info.icon, color: Colors.white),
              ),
              const Spacer(),
              Text(
                exerciseTitle(l10n, info.type),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                exerciseSubtitle(l10n, info.type),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
