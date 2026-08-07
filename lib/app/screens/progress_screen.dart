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
  ExerciseType.competition,
  ExerciseType.speedCap,
  ExerciseType.wordLength,
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
              _FilteredSpeedChart(sessions: sessions),
              const SizedBox(height: 12),
              _BenchmarksLine(l10n: l10n),
              if (sessions
                  .where(
                    (s) =>
                        s.type == ExerciseType.competition ||
                        s.type == ExerciseType.speedCap,
                  )
                  .isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.contestHistoryTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ContestHistory(sessions: sessions),
              ],
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
        label: l10n.badgeRocket,
        icon: Icons.rocket,
        earned: speed.bestWpm >= 700,
      ),
      (
        label: l10n.badgeChampion,
        icon: Icons.emoji_events,
        earned: speed.bestWpm >= 1000,
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

/// LR22 — Ligne de repères publics : situer sa vitesse dans le paysage.
class _BenchmarksLine extends StatelessWidget {
  const _BenchmarksLine({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Text(
      l10n.benchmarksLine,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.outline,
        fontSize: 12,
      ),
    );
  }
}

/// LR22 — Courbe filtrable par type d'exercice (chips au-dessus).
class _FilteredSpeedChart extends StatefulWidget {
  const _FilteredSpeedChart({required this.sessions});
  final List<ReadingSession> sessions;

  @override
  State<_FilteredSpeedChart> createState() => _FilteredSpeedChartState();
}

class _FilteredSpeedChartState extends State<_FilteredSpeedChart> {
  ExerciseType? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final base = widget.sessions.where(
      (s) => _readingTypes.contains(s.type) && s.wpm > 0,
    );
    final filtered = _filter == null
        ? base.toList()
        : base.where((s) => s.type == _filter).toList();
    // Chips : « tous » + les types déjà pratiqués
    final types = base.map((s) => s.type).toSet().toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
                label: Text(l10n.filterAllExercises),
              ),
              const SizedBox(width: 6),
              for (final t in types) ...[
                ChoiceChip(
                  selected: _filter == t,
                  onSelected: (_) => setState(() => _filter = t),
                  label: Text(_shortLabelFor(l10n, t)),
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 200, child: _SpeedChart(sessions: filtered)),
      ],
    );
  }

  String _shortLabelFor(AppLocalizations l10n, ExerciseType t) => switch (t) {
    ExerciseType.rsvp => 'RSVP',
    ExerciseType.pacer => 'Pacer',
    ExerciseType.speedTest => 'Speed',
    ExerciseType.skimming => 'Skim',
    ExerciseType.keywords => 'Keywords',
    ExerciseType.columns => 'Cols',
    ExerciseType.noSubvocal => 'NoVoice',
    ExerciseType.competition => 'Contest',
    ExerciseType.speedCap => 'Cap',
    _ => '?',
  };
}

/// LR22 — Historique dédié Compétition + Vitesse plafond, du plus récent au
/// plus ancien.
class _ContestHistory extends StatelessWidget {
  const _ContestHistory({required this.sessions});
  final List<ReadingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contest =
        sessions
            .where(
              (s) =>
                  s.type == ExerciseType.competition ||
                  s.type == ExerciseType.speedCap,
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: [
        for (final s in contest.take(10))
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(
                  s.type == ExerciseType.competition
                      ? Icons.emoji_events
                      : Icons.trending_up,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${s.date.year}-${s.date.month.toString().padLeft(2, '0')}-${s.date.day.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  s.type == ExerciseType.competition && s.comprehension != null
                      ? '${(s.wpm * s.comprehension!).round()} ${l10n.contestScoreUnit}'
                      : '${s.wpm} ${l10n.unitWpm}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
