import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/clock/clock.dart';
import '../core/clock/system_clock.dart';
import '../core/random/random_source.dart';
import '../core/random/secure_random_source.dart';
import '../data/import/document_import_service.dart';
import '../data/import/pdf_text_reader.dart';
import '../data/import/pdf_text_reader_syncfusion.dart';
import '../data/prefs/shared_prefs_progress_repository.dart';
import '../data/prefs/shared_prefs_session_repository.dart';
import '../data/prefs/shared_prefs_settings_repository.dart';
import '../domain/measure/reading_session.dart';
import '../domain/progress/progress_tracker.dart';
import '../domain/progress/reading_progress.dart';
import '../domain/repositories/progress_repository.dart';
import '../domain/repositories/session_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/text_repository.dart';
import '../domain/settings/reading_settings.dart';
import '../domain/text/reading_text.dart';
import 'reminder/reminder_service.dart';

// --- Amorçage (overridés dans main() après chargement asynchrone) ---
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('à overrider dans main()'),
);
final textRepositoryProvider = Provider<TextRepository>(
  (ref) => throw UnimplementedError('à overrider dans main()'),
);
final bootstrapSettingsProvider = Provider<ReadingSettings>(
  (ref) => throw UnimplementedError('à overrider dans main()'),
);

// --- Services injectables ---
final clockProvider = Provider<Clock>((ref) => const SystemClock());
final randomSourceProvider = Provider<RandomSource>(
  (ref) => SecureRandomSource(),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SharedPrefsSessionRepository(ref.watch(sharedPreferencesProvider)),
);
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPrefsSettingsRepository(ref.watch(sharedPreferencesProvider)),
);
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => SharedPrefsProgressRepository(ref.watch(sharedPreferencesProvider)),
);

/// Rappel quotidien (implémentation native ou no-op web ; init/sync dans main).
final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(),
);

// --- Réglages (état mutable persisté) ---
class SettingsNotifier extends Notifier<ReadingSettings> {
  @override
  ReadingSettings build() => ref.watch(bootstrapSettingsProvider);

  Future<void> update(ReadingSettings settings) async {
    state = settings;
    await ref.read(settingsRepositoryProvider).save(settings);
    await ref.read(reminderServiceProvider).sync(settings);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, ReadingSettings>(
  SettingsNotifier.new,
);

// --- Textes (corpus + import) ---
final textsProvider = FutureProvider<List<ReadingText>>(
  (ref) => ref.watch(textRepositoryProvider).all(),
);

// --- Sessions & progression ---
final sessionsProvider = FutureProvider<List<ReadingSession>>(
  (ref) => ref.watch(sessionRepositoryProvider).all(),
);

final progressProvider = FutureProvider<ProgressSummary>((ref) async {
  final sessions = await ref.watch(sessionRepositoryProvider).all();
  return summarize(sessions);
});

/// Progression de lecture par texte (pour reprendre là où on s'est arrêté).
final readingProgressProvider = FutureProvider<Map<String, ReadingProgress>>(
  (ref) => ref.watch(progressRepositoryProvider).all(),
);

/// Enregistre une session puis rafraîchit les vues de progression.
Future<void> recordSession(WidgetRef ref, ReadingSession session) async {
  await ref.read(sessionRepositoryProvider).add(session);
  ref.invalidate(sessionsProvider);
  ref.invalidate(progressProvider);
}

// --- Import de documents (EPUB/PDF) ---
final pdfTextReaderProvider = Provider<PdfTextReader>(
  (ref) => const SyncfusionPdfTextReader(),
);

final documentImportServiceProvider = Provider<DocumentImportService>(
  (ref) => DocumentImportService(pdfReader: ref.watch(pdfTextReaderProvider)),
);
