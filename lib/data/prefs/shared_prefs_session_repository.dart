import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/measure/reading_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../mappers/reading_session_mapper.dart';

/// Historique de sessions persisté via `shared_preferences` (cross-platform).
class SharedPrefsSessionRepository implements SessionRepository {
  SharedPrefsSessionRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'sessions.v1';

  @override
  Future<List<ReadingSession>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => sessionFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> add(ReadingSession session) async {
    final sessions = await all();
    sessions.add(session);
    await _prefs.setString(
      _key,
      jsonEncode(sessions.map(sessionToJson).toList()),
    );
  }

  @override
  Future<void> clear() async => _prefs.remove(_key);
}
