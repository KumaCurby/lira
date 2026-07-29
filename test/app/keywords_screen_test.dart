import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/app/providers.dart';
import 'package:lecture_rapide/app/screens/keywords_screen.dart';
import 'package:lecture_rapide/data/memory/in_memory_session_repository.dart';
import 'package:lecture_rapide/data/memory/in_memory_settings_repository.dart';
import 'package:lecture_rapide/domain/measure/comprehension_score.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';
import 'package:lecture_rapide/domain/text/reading_text.dart';
import 'package:lecture_rapide/l10n/app_localizations.dart';

const _body = 'Le chat noir dort sur le canapé rouge du salon tranquille.';

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
          const ReadingSettings(localeCode: 'fr'),
        ),
        sessionRepositoryProvider.overrideWithValue(
          InMemorySessionRepository(),
        ),
        settingsRepositoryProvider.overrideWithValue(
          InMemorySettingsRepository(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: KeywordsScreen(text: text),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('KeywordsScreen (LR12)', () {
    testWidgets('phase lecture : sélecteur de mode + bouton présents', (
      tester,
    ) async {
      await _pump(tester, _noQuestions);
      expect(find.text('Estompé'), findsOneWidget);
      expect(find.text('Contenu seul'), findsOneWidget);
      expect(find.text("J'ai lu"), findsOneWidget);
    });

    testWidgets('avec questions : « J\'ai lu » enchaîne sur le quiz', (
      tester,
    ) async {
      await _pump(tester, _withQuestions);
      await tester.tap(find.text("J'ai lu"));
      await tester.pumpAndSettle();
      expect(find.text('Question de contrôle ?'), findsOneWidget);
      expect(find.text('Valider'), findsOneWidget);
    });

    testWidgets('sans question : « J\'ai lu » va droit au résultat', (
      tester,
    ) async {
      await _pump(tester, _noQuestions);
      await tester.tap(find.text("J'ai lu"));
      await tester.pumpAndSettle();
      expect(find.text('Terminer'), findsOneWidget);
    });
  });
}
