import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/app/screens/scramble_screen.dart';
import 'package:lecture_rapide/core/random/seeded_random_source.dart';
import 'package:lecture_rapide/data/memory/in_memory_session_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_settings_repository.dart';
import 'package:lecture_rapide/domain/measure/comprehension_score.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/l10n/app_localizations.dart';

const _body = 'Le petit chat dort tranquillement sur le canapé rouge du salon.';

const _withQuestions = ReadingText(
  id: 't1',
  title: 'Test',
  body: _body,
  source: TextSource.builtin,
  questions: [
    Question(
      prompt: 'Question de contrôle ?',
      options: ['Oui', 'Non'],
      correctIndex: 0,
    ),
  ],
);

const _noQuestions = ReadingText(
  id: 't2',
  title: 'Test',
  body: _body,
  source: TextSource.builtin,
);

Future<void> _pump(WidgetTester tester, ReadingText text) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bootstrapSettingsProvider.overrideWithValue(
          const ReadingSettings(localeCode: 'fr', scrambleIntroSeen: true),
        ),
        sessionRepositoryProvider.overrideWithValue(
          InMemorySessionRepository(),
        ),
        settingsRepositoryProvider.overrideWithValue(
          InMemorySettingsRepository(),
        ),
        randomSourceProvider.overrideWithValue(SeededRandomSource(1)),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScrambleScreen(text: text),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('ScrambleScreen (LR10)', () {
    testWidgets('phase lecture : bouton « J\'ai lu » présent', (tester) async {
      await _pump(tester, _noQuestions);
      expect(find.text("J'ai lu"), findsOneWidget);
      // Le corps n'est PAS affiché tel quel (il est mélangé).
      expect(find.text(_body), findsNothing);
    });

    testWidgets('avec questions : « J\'ai lu » enchaîne sur le quiz', (
      tester,
    ) async {
      await _pump(tester, _withQuestions);

      await tester.tap(find.text("J'ai lu"));
      await tester.pumpAndSettle();

      expect(find.text('Question de contrôle ?'), findsOneWidget);
      expect(find.text('Valider'), findsOneWidget);
      expect(find.text('Terminer'), findsNothing);
    });

    testWidgets('sans question : « J\'ai lu » va droit au résultat', (
      tester,
    ) async {
      await _pump(tester, _noQuestions);

      await tester.tap(find.text("J'ai lu"));
      await tester.pumpAndSettle();

      expect(find.text('Terminer'), findsOneWidget);
      expect(find.text('Valider'), findsNothing);
    });
  });
}
