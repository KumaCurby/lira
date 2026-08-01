import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/srs_repository.dart';
import '../../domain/srs/srs_card.dart';
import '../mappers/srs_card_mapper.dart';

/// Cartes SRS persistées via `shared_preferences` (cross-platform).
class SharedPrefsSrsRepository implements SrsRepository {
  SharedPrefsSrsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'srs.v1';

  @override
  Future<List<SrsCard>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => srsCardFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> upsert(SrsCard card) async {
    final cards = await all();
    cards.removeWhere(
      (c) => c.textId == card.textId && c.cardKey == card.cardKey,
    );
    cards.add(card);
    await _save(cards);
  }

  @override
  Future<void> remove({required String textId, required String cardKey}) async {
    final cards = await all();
    cards.removeWhere((c) => c.textId == textId && c.cardKey == cardKey);
    await _save(cards);
  }

  @override
  Future<void> clear() async => _prefs.remove(_key);

  Future<void> _save(List<SrsCard> cards) =>
      _prefs.setString(_key, jsonEncode(cards.map(srsCardToJson).toList()));
}
