import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/progress/reading_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../mappers/reading_progress_mapper.dart';

/// Progression persistée via `shared_preferences` (cross-platform).
class SharedPrefsProgressRepository implements ProgressRepository {
  SharedPrefsProgressRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'progress.v1';

  @override
  Future<Map<String, ReadingProgress>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map(
      (k, v) => MapEntry(k, readingProgressFromJson(v as Map<String, dynamic>)),
    );
  }

  @override
  Future<void> save(ReadingProgress progress) async {
    final current = await all();
    current[progress.textId] = progress;
    await _prefs.setString(
      _key,
      jsonEncode(current.map((k, v) => MapEntry(k, readingProgressToJson(v)))),
    );
  }

  @override
  Future<void> clear() async => _prefs.remove(_key);
}
