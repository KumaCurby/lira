import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/data/prefs/shared_prefs_session_repository.dart';
import 'package:lecture_rapide/data/prefs/shared_prefs_settings_repository.dart';
import 'package:lecture_rapide/domain/measure/reading_session.dart';
import 'package:lecture_rapide/domain/settings/reading_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('SharedPrefsSessionRepository persiste et relit les sessions', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = SharedPrefsSessionRepository(prefs);

    expect(await repo.all(), isEmpty);
    await repo.add(
      ReadingSession(
        type: ExerciseType.speedTest,
        wordCount: 100,
        elapsed: const Duration(minutes: 1),
        wpm: 100,
        comprehension: 0.5,
        date: DateTime(2026, 7, 1),
      ),
    );
    await repo.add(
      ReadingSession(
        type: ExerciseType.rsvp,
        wordCount: 50,
        elapsed: const Duration(seconds: 30),
        wpm: 100,
        date: DateTime(2026, 7, 2),
      ),
    );

    // Nouvelle instance -> relit depuis le store.
    final reloaded = await SharedPrefsSessionRepository(
      await SharedPreferences.getInstance(),
    ).all();
    expect(reloaded, hasLength(2));
    expect(reloaded.first.comprehension, 0.5);

    await repo.clear();
    expect(await repo.all(), isEmpty);
  });

  test('SharedPrefsSettingsRepository : défaut puis persistance', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = SharedPrefsSettingsRepository(prefs);

    expect((await repo.load()).defaultWpm, 250); // valeur par défaut

    await repo.save(const ReadingSettings(defaultWpm: 420, darkMode: true));

    final loaded = await SharedPrefsSettingsRepository(
      await SharedPreferences.getInstance(),
    ).load();
    expect(loaded.defaultWpm, 420);
    expect(loaded.darkMode, isTrue);
  });
}
