// Point d'entrée de DÉMONSTRATION (non destiné à la production).
//
// Lance l'app sur la bibliothèque, après avoir exécuté le vrai code d'import
// sur le livre d'exemple — les extraits apparaissent regroupés sous une entrée
// dépliable. Utilisé pour les captures d'écran.
//
//   flutter run -d chrome -t lib/main_demo.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers.dart';
import 'app/screens/home_shell.dart';
import 'app/theme.dart';
import 'data/corpus/corpus_loader.dart';
import 'data/import/document_import_service.dart';
import 'data/import/pdf_text_reader_syncfusion.dart';
import 'data/memory/in_memory_progress_repository.dart';
import 'data/memory/in_memory_session_repository.dart';
import 'data/memory/in_memory_settings_repository.dart';
import 'data/memory/in_memory_text_repository.dart';
import 'domain/progress/reading_progress.dart';
import 'domain/settings/reading_settings.dart';
import 'l10n/app_localizations.dart';
import 'samples/sample_book_content.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final corpus = await loadBuiltinCorpus();
  final imported =
      await DocumentImportService(
        pdfReader: const SyncfusionPdfTextReader(),
      ).importFile(
        filename: 'almanach-des-curiosites.epub',
        bytes: buildSampleEpubBytes(),
        idPrefix: 'user-demo',
      );

  final textRepository = InMemoryTextRepository([...corpus, ...imported]);

  // Progression de démo : premier extrait lu à ~60 %.
  final progressRepository = InMemoryProgressRepository();
  final firstPart = imported.first;
  await progressRepository.save(
    ReadingProgress(
      textId: firstPart.id,
      wordIndex: (firstPart.wordCount * 0.6).round(),
      wordCount: firstPart.wordCount,
      updatedAt: DateTime(2026, 7, 10),
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        textRepositoryProvider.overrideWithValue(textRepository),
        progressRepositoryProvider.overrideWithValue(progressRepository),
        bootstrapSettingsProvider.overrideWithValue(const ReadingSettings()),
        sessionRepositoryProvider.overrideWithValue(
          InMemorySessionRepository(),
        ),
        settingsRepositoryProvider.overrideWithValue(
          InMemorySettingsRepository(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(Brightness.light),
        home: const HomeShell(),
      ),
    ),
  );
}
