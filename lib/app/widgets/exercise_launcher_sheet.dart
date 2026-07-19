import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/text/reading_text.dart';
import '../../l10n/app_localizations.dart';
import '../exercise_catalog.dart';
import '../navigation.dart';
import '../providers.dart';

/// Feuille « Lancer un exercice » : propose, pour un [text] donné, les exercices
/// applicables et démarre directement celui qu'on choisit.
Future<void> showExerciseLauncher(
  BuildContext context,
  WidgetRef ref,
  ReadingText text,
) {
  final l10n = AppLocalizations.of(context)!;
  final exercises = exerciseCatalog
      .where((e) => e.needsText)
      // Le balayage a besoin d'une cible ; on le masque si le texte n'en a pas.
      .where((e) => e.type != ExerciseType.scanning || text.scanTarget != null)
      .toList();

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.launchExercise,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  Text(
                    text.title,
                    style: Theme.of(sheetContext).textTheme.bodyMedium
                        ?.copyWith(
                          color: Theme.of(sheetContext).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            for (final info in exercises)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: info.color,
                  foregroundColor: Colors.white,
                  child: Icon(info.icon),
                ),
                title: Text(exerciseTitle(l10n, info.type)),
                subtitle: Text(exerciseSubtitle(l10n, info.type)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => exerciseScreenFor(info.type, text),
                        ),
                      )
                      .then((_) => ref.invalidate(readingProgressProvider));
                },
              ),
          ],
        ),
      ),
    ),
  );
}
