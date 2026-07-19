import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/app/screens/library_screen.dart';
import 'package:lecture_rapide/data/memory/in_memory_progress_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_text_repository.dart';
import 'package:lecture_rapide/domain/progress/reading_progress.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/l10n/app_localizations.dart';

ReadingText _part(int i) => ReadingText(
  id: 'b-$i',
  title: 'L · $i',
  body: List.filled(100, 'mot').join(' '),
  source: TextSource.user,
  bookId: 'b',
  bookTitle: 'Mon Livre',
  partIndex: i,
);

void main() {
  testWidgets('un livre entamé affiche la progression et « Reprendre »', (
    tester,
  ) async {
    final texts = InMemoryTextRepository([_part(1), _part(2)]);
    final progress = InMemoryProgressRepository();
    await progress.save(
      ReadingProgress(
        textId: 'b-1',
        wordIndex: 50,
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
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Déplier le livre.
    await tester.tap(find.text('Mon Livre'));
    await tester.pumpAndSettle();

    // Reprise proposée sur l'extrait entamé + progression de l'extrait.
    expect(find.textContaining('Reprendre'), findsOneWidget);
    expect(find.textContaining('Lu à 50 %'), findsOneWidget);
  });
}
