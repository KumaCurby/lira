import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';
import '../../domain/settings/reading_settings.dart';
import '../mappers/reading_settings_mapper.dart';

/// Préférences persistées via `shared_preferences` (cross-platform).
class SharedPrefsSettingsRepository implements SettingsRepository {
  SharedPrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'settings.v1';

  @override
  Future<ReadingSettings> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return const ReadingSettings();
    return settingsFromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(ReadingSettings settings) async {
    await _prefs.setString(_key, jsonEncode(settingsToJson(settings)));
  }
}
