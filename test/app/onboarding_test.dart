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

void main() {
  testWidgets("l'onboarding mesure la vitesse puis mène à l'accueil", (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final textRepo = LocalTextRepository(corpus: _corpus, prefs: prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          textRepositoryProvider.overrideWithValue(textRepo),
          bootstrapSettingsProvider.overrideWithValue(
            const ReadingSettings(localeCode: 'fr'),
          ),
        ],
        child: const LiraApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Écran de bienvenue.
    expect(find.text('Bienvenue dans Lira'), findsOneWidget);
    await tester.tap(find.text('Mesurer ma vitesse'));
    await tester.pumpAndSettle();

    // Lecture chronométrée.
    await tester.tap(find.text("J'ai fini de lire"));
    await tester.pumpAndSettle();

    // Résultat + objectif.
    expect(find.text('Ta vitesse'), findsOneWidget);
    await tester.tap(find.textContaining("C'est parti"));
    await tester.pumpAndSettle();

    // On arrive sur l'accueil (onglets).
    expect(find.text('Entraînement'), findsWidgets);
  });
}
