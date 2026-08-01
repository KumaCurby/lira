import '../srs/srs_card.dart';

/// LR13 — Stockage des cartes de révision espacée (une par question ou mot-clé).
abstract class SrsRepository {
  /// Toutes les cartes connues.
  Future<List<SrsCard>> all();

  /// Ajoute ou remplace la carte identifiée par `(textId, cardKey)`.
  Future<void> upsert(SrsCard card);

  /// Supprime la carte identifiée par `(textId, cardKey)`.
  Future<void> remove({required String textId, required String cardKey});

  /// Efface toutes les cartes.
  Future<void> clear();
}
