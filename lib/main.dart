import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'app/reminder/reminder_service.dart';
import 'data/corpus/corpus_loader.dart';
import 'data/corpus/local_text_repository.dart';
import 'data/prefs/shared_prefs_settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final corpus = await loadBuiltinCorpus();
  final textRepository = LocalTextRepository(corpus: corpus, prefs: prefs);
  final settings = await SharedPrefsSettingsRepository(prefs).load();

  final reminder = ReminderService();
  await reminder.init();
  await reminder.sync(settings);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        textRepositoryProvider.overrideWithValue(textRepository),
        bootstrapSettingsProvider.overrideWithValue(settings),
        reminderServiceProvider.overrideWithValue(reminder),
      ],
      child: const LiraApp(),
    ),
  );
}
