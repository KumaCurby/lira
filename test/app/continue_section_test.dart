import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/app/screens/training_screen.dart';
import 'package:lecture_rapide/l10n/app_localizations.dart';
import 'package:lecture_rapide/data/memory/in_memory_progress_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_text_repository.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';

void main() {
  testWidgets('la section « Continuer » apparaît pour une lecture en cours', (
    tester,
  ) async {
    final texts = InMemoryTextRepository([
      ReadingText(
        id: 't1',
        title: 'Mon texte',
        body: List.filled(100, 'mot').join(' '),
        source: TextSource.user,
      ),
    ]);
    final progress = InMemoryProgressRepository();
    await progress.save(
      ReadingProgress(
        textId: 't1',
        wordIndex: 40,
        wordCount: 100,
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          textRepositoryProvider.overrideWithValue(texts),
          progressRepositoryProvider.overrideWithValue(progress),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TrainingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continuer'), findsOneWidget);
    expect(find.text('Mon texte'), findsOneWidget);
    expect(find.text('Reprendre'), findsWidgets);
  });
}
