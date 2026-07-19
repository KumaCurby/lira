import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/app/screens/library_screen.dart';
import 'package:lecture_rapide/data/memory/in_memory_progress_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_text_repository.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/l10n/app_localizations.dart';

const _book = [
  ReadingText(
    id: 'b-1',
    title: 'Mon Livre · 1/2',
    body: 'a b c',
    source: TextSource.user,
    bookId: 'b',
    bookTitle: 'Mon Livre',
    partIndex: 1,
  ),
  ReadingText(
    id: 'b-2',
    title: 'Mon Livre · 2/2',
    body: 'd e f',
    source: TextSource.user,
    bookId: 'b',
    bookTitle: 'Mon Livre',
    partIndex: 2,
  ),
];

void main() {
  testWidgets('les extraits d\'un livre sont regroupés et dépliables', (
    tester,
  ) async {
    final repo = InMemoryTextRepository([..._book]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          textRepositoryProvider.overrideWithValue(repo),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
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

    // Replié : on voit le livre (une entrée), pas les extraits.
    expect(find.text('Mon Livre'), findsOneWidget);
    expect(find.text('2 extraits · 6 mots'), findsOneWidget);
    expect(find.text('Extrait 1'), findsNothing);

    // Déplier.
    await tester.tap(find.text('Mon Livre'));
    await tester.pumpAndSettle();

    expect(find.text('Extrait 1'), findsOneWidget);
    expect(find.text('Extrait 2'), findsOneWidget);
    expect(find.text('Supprimer le livre'), findsOneWidget);
  });
}
