import '../../domain/repositories/settings_repository.dart';
import '../../domain/settings/reading_settings.dart';

/// Préférences en mémoire (tests, prévisualisation).
class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._settings = const ReadingSettings()]);

  ReadingSettings _settings;

  @override
  Future<ReadingSettings> load() async => _settings;

  @override
  Future<void> save(ReadingSettings settings) async => _settings = settings;
}
