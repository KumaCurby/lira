import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/progress/goal.dart';
import '../../domain/progress/progress_tracker.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';

const Set<ExerciseType> _readingTypes = {
  ExerciseType.speedTest,
  ExerciseType.rsvp,
  ExerciseType.pacer,
  ExerciseType.skimming,
  ExerciseType.keywords,
  ExerciseType.columns,
  ExerciseType.noSubvocal,
};

/// Onglet « Progrès » : statistiques, courbe de vitesse et badges.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionsAsync = ref.watch(sessionsProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressTitle)),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.progressEmpty, textAlign: TextAlign.center),
              ),
            );
          }

          final reading = sessions
              .where((s) => _readingTypes.contains(s.type))
              .toList();
          final speed = summarize(reading);
          final streak = currentStreakDays(
            sessions.map((s) => s.date),
            today: ref.read(clockProvider).now(),
          );
          final scramble = sessions
              .where(
                (s) =>
                    s.type == ExerciseType.scramble ||
                    s.type == ExerciseType.wordScramble,
              )
              .toList();
          final scrambleSummary = summarize(scramble);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _GoalCard(targetWpm: settings.targetWpm, bestWpm: speed.bestWpm),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatTile(
                    label: l10n.statBestSpeed,
                    value: '${speed.bestWpm}',
                    unit: l10n.unitWpm,
                    icon: Icons.emoji_events,
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    label: l10n.statAvgSpeed,
                    value: '${speed.averageWpm.round()}',
                    unit: l10n.unitWpm,
                    icon: Icons.speed,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatTile(
                    label: l10n.statStreak,
                    value: '$streak',
                    unit: l10n.unitDays,
                    icon: Icons.local_fire_department,
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    label: l10n.statSessions,
                    value: '${sessions.length}',
                    unit: l10n.unitTotal,
                    icon: Icons.check_circle,
                  ),
                ],
              ),
              if (scramble.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatTile(
                      label: l10n.scrambleBest,
                      value: '${scrambleSummary.bestWpm}',
                      unit: l10n.unitWpm,
                      icon: Icons.shuffle,
                    ),
                    const SizedBox(width: 12),
                    _StatTile(
                      label: l10n.scrambleSessionsStat,
                      value: '${scramble.length}',
                      unit: l10n.unitTotal,
                      icon: Icons.repeat,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.speedEvolution,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: _SpeedChart(sessions: reading)),
              const SizedBox(height: 20),
              Text(
                l10n.badgesTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _Badges(sessions: sessions, speed: speed, streak: streak),
            ],
          );
        },
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.targetWpm, required this.bestWpm});

  final int targetWpm;
  final int bestWpm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final goal = Goal(targetWpm: targetWpm);
    final reached = goal.isReachedBy(bestWpm);
    final fraction = goal.progressFrom(bestWpm);

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  reached ? Icons.emoji_events : Icons.flag,
                  color: scheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reached
                        ? l10n.goalReached(targetWpm)
                        : l10n.goalLabel(targetWpm),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${(fraction * 100).round()} %',
                  style: TextStyle(color: scheme.onPrimaryContainer),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: scheme.onPrimaryContainer.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        color: scheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$label · $unit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedChart extends StatelessWidget {
  const _SpeedChart({required this.sessions});

  final List<ReadingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    if (sorted.length < 2) {
      return Center(child: Text(AppLocalizations.of(context)!.chartMorePoints));
    }

    final scheme = Theme.of(context).colorScheme;
    final spots = [
      for (var i = 0; i < sorted.length; i++)
        FlSpot(i.toDouble(), sorted[i].wpm.toDouble()),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: scheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: scheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges({
    required this.sessions,
    required this.speed,
    required this.streak,
  });

  final List<ReadingSession> sessions;
  final ProgressSummary speed;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typesTried = sessions.map((s) => s.type).toSet();
    final badges = <({String label, IconData icon, bool earned})>[
      (label: l10n.badgeFirst, icon: Icons.flag, earned: sessions.isNotEmpty),
      (
        label: l10n.badgeRegular,
        icon: Icons.local_fire_department,
        earned: streak >= 3,
      ),
      (label: l10n.badgeQuick, icon: Icons.bolt, earned: speed.bestWpm >= 300),
      (
        label: l10n.badgeFlash,
        icon: Icons.flash_on,
        earned: speed.bestWpm >= 500,
      ),
      (
        label: l10n.badgeExplorer,
        icon: Icons.explore,
        earned: typesTried.length >= 6,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final badge in badges)
          Chip(
            avatar: Icon(
              badge.icon,
              size: 18,
              color: badge.earned
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
            ),
            label: Text(badge.label),
            backgroundColor: badge.earned
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
      ],
    );
  }
}
