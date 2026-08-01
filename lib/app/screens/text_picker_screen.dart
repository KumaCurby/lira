import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/measure/reading_session.dart';
import '../../l10n/app_localizations.dart';
import '../exercise_catalog.dart';
import '../navigation.dart';
import '../providers.dart';

/// Choix d'un texte avant de lancer un exercice qui en a besoin.
class TextPickerScreen extends ConsumerWidget {
  const TextPickerScreen({
    super.key,
    required this.info,
    this.returnText = false,
  });

  final ExerciseInfo info;

  /// Si vrai, le tap sur un texte referme l'écran en le renvoyant à l'appelant
  /// (pattern utilisé par la séance combinée). Sinon, on push directement
  /// l'exercice.
  final bool returnText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textsAsync = ref.watch(textsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(exerciseTitle(l10n, info.type))),
      body: textsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'))),
        data: (texts) {
          final list = info.type == ExerciseType.scanning
              ? texts.where((t) => t.scanTarget != null).toList()
              : texts;

          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noTextForExercise,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final text = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: info.color.withValues(alpha: 0.18),
                    foregroundColor: info.color,
                    child: Text('${text.difficulty ?? '?'}'),
                  ),
                  title: Text(text.title),
                  subtitle: Text(
                    l10n.textPickerMeta(
                      text.wordCount,
                      '${text.difficulty ?? '?'}',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (returnText) {
                      Navigator.of(context).pop(text);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => exerciseScreenFor(info.type, text),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
