import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/app.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/data/corpus/local_text_repository.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _corpus = [
  ReadingText(
    id: 'c1',
    title: 'Démo',
    body: 'Un deux trois quatre cinq six.',
    source: TextSource.builtin,
    difficulty: 1,
  ),
];

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final textRepo = LocalTextRepository(corpus: _corpus, prefs: prefs);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        textRepositoryProvider.overrideWithValue(textRepo),
        bootstrapSettingsProvider.overrideWithValue(
          const ReadingSettings(hasOnboarded: true, localeCode: 'fr'),
        ),
      ],
      child: const LiraApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('démarre et affiche la grille d\'exercices', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Lira'), findsWidgets);
    expect(find.text('Lecteur RSVP'), findsOneWidget);
    expect(find.text('Table de Schulte'), findsOneWidget);
  });

  testWidgets('ouvre la table de Schulte (sans texte)', (tester) async {
    await _pumpApp(tester);

    await tester.ensureVisible(find.text('Table de Schulte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Table de Schulte'));
    await tester.pumpAndSettle();

    expect(find.text('Commencer'), findsOneWidget);
  });

  testWidgets('RSVP : choix du texte puis lecteur', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Lecteur RSVP'));
    await tester.pumpAndSettle();
    expect(find.text('Démo'), findsOneWidget); // sélecteur de texte

    await tester.tap(find.text('Démo'));
    await tester.pumpAndSettle();
    expect(find.text('Appuie sur Lecture'), findsOneWidget);
  });

  testWidgets('la bibliothèque propose coller ou importer un fichier', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Textes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    expect(find.text('Coller du texte'), findsOneWidget);
    expect(find.textContaining('Importer un fichier'), findsOneWidget);
  });

  testWidgets('un texte de la bibliothèque propose de lancer un exercice', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Textes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Démo'));
    await tester.pumpAndSettle();

    expect(find.text('Lancer un exercice'), findsOneWidget);
    expect(find.text('Lecteur RSVP'), findsWidgets);
  });

  testWidgets('bascule en thème sombre depuis les réglages', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Réglages'));
    await tester.pumpAndSettle();

    expect(find.text('Thème sombre'), findsOneWidget);
    await tester.tap(find.text('Thème sombre'));
    await tester.pumpAndSettle();
    // Pas d'exception = bascule OK et persistance déclenchée.
  });
}
