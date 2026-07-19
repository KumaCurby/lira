import '../settings/reading_settings.dart';

/// Persistance des préférences de lecture.
abstract class SettingsRepository {
  /// Charge les préférences (valeurs par défaut si rien n'est enregistré).
  Future<ReadingSettings> load();

  /// Enregistre les préférences.
  Future<void> save(ReadingSettings settings);
}
