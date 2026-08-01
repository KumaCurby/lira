import 'package:flutter/material.dart';

import '../domain/measure/reading_session.dart';
import '../l10n/app_localizations.dart';

/// Métadonnées d'affichage d'un exercice (icône, couleur…). Les libellés sont
/// localisés via [exerciseTitle] / [exerciseSubtitle].
class ExerciseInfo {
  const ExerciseInfo({
    required this.type,
    required this.icon,
    required this.color,
    required this.needsText,
  });

  final ExerciseType type;
  final IconData icon;
  final Color color;

  /// Vrai si l'exercice démarre par le choix d'un texte.
  final bool needsText;
}

const List<ExerciseInfo> exerciseCatalog = [
  ExerciseInfo(
    type: ExerciseType.rsvp,
    icon: Icons.bolt,
    color: Color(0xFF6C4DF6),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.pacer,
    icon: Icons.linear_scale,
    color: Color(0xFF00B8D4),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.speedTest,
    icon: Icons.speed,
    color: Color(0xFFFF6D00),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.skimming,
    icon: Icons.visibility,
    color: Color(0xFF00C853),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.scanning,
    icon: Icons.search,
    color: Color(0xFFD500F9),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.schulte,
    icon: Icons.grid_view,
    color: Color(0xFFFFAB00),
    needsText: false,
  ),
  ExerciseInfo(
    type: ExerciseType.scramble,
    icon: Icons.shuffle,
    color: Color(0xFFEC407A),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.wordScramble,
    icon: Icons.reorder,
    color: Color(0xFF7E57C2),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.keywords,
    icon: Icons.filter_center_focus,
    color: Color(0xFF00897B),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.columns,
    icon: Icons.view_column_outlined,
    color: Color(0xFF5C6BC0),
    needsText: true,
  ),
  ExerciseInfo(
    type: ExerciseType.noSubvocal,
    icon: Icons.volume_off,
    color: Color(0xFF8D6E63),
    needsText: true,
  ),
];

String exerciseTitle(AppLocalizations l10n, ExerciseType type) =>
    switch (type) {
      ExerciseType.rsvp => l10n.exRsvpTitle,
      ExerciseType.pacer => l10n.exPacerTitle,
      ExerciseType.speedTest => l10n.exSpeedTitle,
      ExerciseType.skimming => l10n.exSkimTitle,
      ExerciseType.scanning => l10n.exScanTitle,
      ExerciseType.schulte => l10n.exSchulteTitle,
      ExerciseType.scramble => l10n.exScrambleTitle,
      ExerciseType.wordScramble => l10n.exWordsTitle,
      ExerciseType.keywords => l10n.exKeywordsTitle,
      ExerciseType.columns => l10n.exColumnsTitle,
      ExerciseType.noSubvocal => l10n.exNoSubvocalTitle,
    };

String exerciseSubtitle(AppLocalizations l10n, ExerciseType type) =>
    switch (type) {
      ExerciseType.rsvp => l10n.exRsvpSubtitle,
      ExerciseType.pacer => l10n.exPacerSubtitle,
      ExerciseType.speedTest => l10n.exSpeedSubtitle,
      ExerciseType.skimming => l10n.exSkimSubtitle,
      ExerciseType.scanning => l10n.exScanSubtitle,
      ExerciseType.schulte => l10n.exSchulteSubtitle,
      ExerciseType.scramble => l10n.exScrambleSubtitle,
      ExerciseType.wordScramble => l10n.exWordsSubtitle,
      ExerciseType.keywords => l10n.exKeywordsSubtitle,
      ExerciseType.columns => l10n.exColumnsSubtitle,
      ExerciseType.noSubvocal => l10n.exNoSubvocalSubtitle,
    };
