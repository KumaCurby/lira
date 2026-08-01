import '../../domain/repositories/srs_repository.dart';
import '../../domain/srs/srs_card.dart';

/// Impl en mémoire de [SrsRepository] pour les tests.
class InMemorySrsRepository implements SrsRepository {
  final List<SrsCard> _cards = [];

  @override
  Future<List<SrsCard>> all() async => List.unmodifiable(_cards);

  @override
  Future<void> upsert(SrsCard card) async {
    _cards.removeWhere(
      (c) => c.textId == card.textId && c.cardKey == card.cardKey,
    );
    _cards.add(card);
  }

  @override
  Future<void> remove({required String textId, required String cardKey}) async {
    _cards.removeWhere((c) => c.textId == textId && c.cardKey == cardKey);
  }

  @override
  Future<void> clear() async => _cards.clear();
}
