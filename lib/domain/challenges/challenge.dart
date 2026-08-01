import 'package:flutter/foundation.dart';

import '../measure/reading_session.dart';
import '../notes/text_note.dart';
import '../srs/srs_card.dart';

/// LR19 — Contexte fourni aux défis pour calculer leur progression.
@immutable
class ChallengeContext {
  const ChallengeContext({
    required this.sessions,
    required this.srsCards,
    required this.notes,
    required this.now,
  });

  final List<ReadingSession> sessions;
  final List<SrsCard> srsCards;
  final List<TextNote> notes;
  final DateTime now;
}

/// LR19 — Un défi que l'utilisateur peut poursuivre. Sa progression est
/// calculée à partir d'un [ChallengeContext] et bornée à [target].
class Challenge {
  const Challenge({
    required this.id,
    required this.emoji,
    required this.titleKey,
    required this.descriptionKey,
    required this.target,
    required this.progress,
  });

  final String id;
  final String emoji;

  /// Clé i18n du titre (résolue côté UI).
  final String titleKey;

  /// Clé i18n de la description.
  final String descriptionKey;
  final int target;
  final int Function(ChallengeContext ctx) progress;
}

/// LR19 — Défis prédéfinis (v1). L'utilisateur ne peut pas encore en créer.
final List<Challenge> kChallenges = [
  Challenge(
    id: 'streak5',
    emoji: '🔥',
    titleKey: 'challengeStreakTitle',
    descriptionKey: 'challengeStreakDesc',
    target: 5,
    progress: (ctx) {
      final days = <String>{};
      for (final s in ctx.sessions) {
        final d = s.date;
        days.add('${d.year}-${d.month}-${d.day}');
      }
      // Nombre de jours consécutifs jusqu'à aujourd'hui inclus.
      var streak = 0;
      var cursor = DateTime(ctx.now.year, ctx.now.month, ctx.now.day);
      while (days.contains('${cursor.year}-${cursor.month}-${cursor.day}')) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      }
      return streak > 5 ? 5 : streak;
    },
  ),
  Challenge(
    id: 'speed500',
    emoji: '⚡',
    titleKey: 'challengeSpeedTitle',
    descriptionKey: 'challengeSpeedDesc',
    target: 1,
    progress: (ctx) =>
        ctx.sessions.any(
          (s) =>
              s.wpm >= 500 &&
              s.comprehension != null &&
              s.comprehension! >= 0.8,
        )
        ? 1
        : 0,
  ),
  Challenge(
    id: 'contest3',
    emoji: '🏆',
    titleKey: 'challengeContestTitle',
    descriptionKey: 'challengeContestDesc',
    target: 3,
    progress: (ctx) {
      final n = ctx.sessions
          .where(
            (s) =>
                s.type == ExerciseType.competition &&
                s.comprehension != null &&
                (s.wpm * s.comprehension!).round() >= 250,
          )
          .length;
      return n > 3 ? 3 : n;
    },
  ),
  Challenge(
    id: 'memory20',
    emoji: '🧠',
    titleKey: 'challengeMemoryTitle',
    descriptionKey: 'challengeMemoryDesc',
    target: 20,
    progress: (ctx) {
      final n = ctx.srsCards.length;
      return n > 20 ? 20 : n;
    },
  ),
  Challenge(
    id: 'notes5',
    emoji: '📝',
    titleKey: 'challengeNotesTitle',
    descriptionKey: 'challengeNotesDesc',
    target: 5,
    progress: (ctx) {
      final n = ctx.notes.length;
      return n > 5 ? 5 : n;
    },
  ),
];
