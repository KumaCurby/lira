import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/challenges/challenge.dart';
import '../../l10n/app_localizations.dart';
import '../providers.dart';
import '../theme.dart';

/// LR19 — Écran « Défis » : progression courante sur chaque défi prédéfini.
class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessions = ref.watch(sessionsProvider).valueOrNull ?? const [];
    final cards = ref.watch(srsCardsProvider).valueOrNull ?? const [];
    final notes = ref.watch(notesProvider).valueOrNull ?? const [];
    final ctx = ChallengeContext(
      sessions: sessions,
      srsCards: cards,
      notes: notes,
      now: ref.read(clockProvider).now(),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.challengesTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kChallenges.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _ChallengeCard(
          challenge: kChallenges[i],
          progress: kChallenges[i].progress(ctx),
          l10n: l10n,
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.progress,
    required this.l10n,
  });

  final Challenge challenge;
  final int progress;
  final AppLocalizations l10n;

  String _title() => switch (challenge.titleKey) {
    'challengeStreakTitle' => l10n.challengeStreakTitle,
    'challengeSpeedTitle' => l10n.challengeSpeedTitle,
    'challengeContestTitle' => l10n.challengeContestTitle,
    'challengeMemoryTitle' => l10n.challengeMemoryTitle,
    'challengeNotesTitle' => l10n.challengeNotesTitle,
    _ => challenge.titleKey,
  };

  String _desc() => switch (challenge.descriptionKey) {
    'challengeStreakDesc' => l10n.challengeStreakDesc,
    'challengeSpeedDesc' => l10n.challengeSpeedDesc,
    'challengeContestDesc' => l10n.challengeContestDesc,
    'challengeMemoryDesc' => l10n.challengeMemoryDesc,
    'challengeNotesDesc' => l10n.challengeNotesDesc,
    _ => challenge.descriptionKey,
  };

  @override
  Widget build(BuildContext context) {
    final done = progress >= challenge.target;
    final fraction = challenge.target == 0
        ? 0.0
        : (progress / challenge.target).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: done ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _title(),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '$progress / ${challenge.target}',
                style: TextStyle(
                  color: done
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _desc(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8,
              backgroundColor: AppColors.primarySoft.withValues(alpha: 0.5),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          if (done) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.challengeDone,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
