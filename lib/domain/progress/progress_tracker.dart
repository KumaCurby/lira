import '../measure/reading_session.dart';

/// LR9 — Synthèse de progression calculée à partir des sessions.
class ProgressSummary {
  const ProgressSummary({
    required this.sessionCount,
    required this.bestWpm,
    required this.averageWpm,
    required this.latestWpm,
    required this.trend,
    required this.byType,
  });

  final int sessionCount;
  final int bestWpm;
  final double averageWpm;
  final int latestWpm;

  /// Écart entre la première et la dernière session (positif = progrès).
  final int trend;

  /// Nombre de sessions par famille d'exercice.
  final Map<ExerciseType, int> byType;
}

/// LR9 — Agrège une liste de sessions en une [ProgressSummary].
ProgressSummary summarize(List<ReadingSession> sessions) {
  if (sessions.isEmpty) {
    return const ProgressSummary(
      sessionCount: 0,
      bestWpm: 0,
      averageWpm: 0,
      latestWpm: 0,
      trend: 0,
      byType: {},
    );
  }

  final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
  final wpms = sorted.map((s) => s.wpm);

  final byType = <ExerciseType, int>{};
  for (final session in sorted) {
    byType[session.type] = (byType[session.type] ?? 0) + 1;
  }

  return ProgressSummary(
    sessionCount: sorted.length,
    bestWpm: wpms.reduce((a, b) => a > b ? a : b),
    averageWpm: wpms.reduce((a, b) => a + b) / sorted.length,
    latestWpm: sorted.last.wpm,
    trend: sorted.last.wpm - sorted.first.wpm,
    byType: byType,
  );
}

/// LR9 — Nombre de jours consécutifs (jusqu'à [today] inclus) comportant au
/// moins une session. Renvoie 0 si aucune session aujourd'hui.
int currentStreakDays(Iterable<DateTime> dates, {required DateTime today}) {
  final days = {for (final d in dates) DateTime(d.year, d.month, d.day)};

  var streak = 0;
  var cursor = DateTime(today.year, today.month, today.day);
  while (days.contains(cursor)) {
    streak++;
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return streak;
}

/// LR9 — Vrai si au moins une séance a eu lieu aujourd'hui ([today]).
bool practicedToday(Iterable<DateTime> dates, {required DateTime today}) {
  final day = DateTime(today.year, today.month, today.day);
  return dates.any((d) => DateTime(d.year, d.month, d.day) == day);
}
