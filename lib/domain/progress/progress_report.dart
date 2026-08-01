import '../measure/reading_session.dart';
import 'progress_tracker.dart';

/// LR23 — Génère un **rapport texte** de progression (formatée) pour partage
/// ou export. Contenu : synthèse globale, exercices pratiqués, meilleurs scores
/// compétition, série de jours, dernières sessions.
String buildProgressReport(
  List<ReadingSession> sessions, {
  required DateTime now,
}) {
  if (sessions.isEmpty) return 'Aucune session enregistrée.';
  final summary = summarize(sessions);
  final streak = currentStreakDays(sessions.map((s) => s.date), today: now);
  final buf = StringBuffer()
    ..writeln('╭─────────────────────────────╮')
    ..writeln('│  RAPPORT LIRA — ${_isoDate(now)}  │')
    ..writeln('╰─────────────────────────────╯')
    ..writeln()
    ..writeln('▸ Sessions totales : ${summary.sessionCount}')
    ..writeln('▸ Meilleure vitesse : ${summary.bestWpm} mpm')
    ..writeln('▸ Vitesse moyenne : ${summary.averageWpm.round()} mpm')
    ..writeln('▸ Dernière vitesse : ${summary.latestWpm} mpm')
    ..writeln('▸ Série en cours : $streak jour(s)')
    ..writeln(
      '▸ Tendance : ${summary.trend >= 0 ? '+' : ''}${summary.trend} mpm',
    );

  final byType = summary.byType.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  if (byType.isNotEmpty) {
    buf
      ..writeln()
      ..writeln('EXERCICES PRATIQUÉS');
    for (final e in byType) {
      buf.writeln('  · ${_labelFor(e.key)} : ${e.value}');
    }
  }

  final contests =
      sessions
          .where(
            (s) =>
                s.type == ExerciseType.competition && s.comprehension != null,
          )
          .toList()
        ..sort((a, b) {
          final sa = (a.wpm * a.comprehension!).round();
          final sb = (b.wpm * b.comprehension!).round();
          return sb.compareTo(sa);
        });
  if (contests.isNotEmpty) {
    buf
      ..writeln()
      ..writeln('MEILLEURS SCORES COMPÉTITION');
    for (final s in contests.take(5)) {
      final score = (s.wpm * s.comprehension!).round();
      buf.writeln(
        '  · $score pts (${s.wpm} mpm × ${(s.comprehension! * 100).round()} %) — ${_isoDate(s.date)}',
      );
    }
  }

  return buf.toString();
}

String _isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _labelFor(ExerciseType t) => switch (t) {
  ExerciseType.speedTest => 'Test de vitesse',
  ExerciseType.rsvp => 'RSVP',
  ExerciseType.pacer => 'Guidage',
  ExerciseType.skimming => 'Écrémage',
  ExerciseType.scanning => 'Balayage',
  ExerciseType.schulte => 'Schulte',
  ExerciseType.scramble => 'Mots mélangés',
  ExerciseType.wordScramble => 'Phrases mélangées',
  ExerciseType.keywords => 'Mots-clés',
  ExerciseType.columns => 'Colonnes',
  ExerciseType.noSubvocal => 'Sans voix intérieure',
  ExerciseType.competition => 'Compétition',
  ExerciseType.speedCap => 'Vitesse plafond',
};
