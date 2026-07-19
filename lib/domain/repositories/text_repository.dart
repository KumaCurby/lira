import '../text/reading_text.dart';

/// Accès aux textes (corpus intégré + textes importés). Le domaine ne connaît
/// que cette interface ; l'implémentation concrète arrive en Phase 1.
abstract class TextRepository {
  /// Tous les textes disponibles (corpus + utilisateur).
  Future<List<ReadingText>> all();

  /// Un texte par son identifiant, ou `null` s'il n'existe pas.
  Future<ReadingText?> byId(String id);

  /// Enregistre un texte importé par l'utilisateur.
  Future<void> save(ReadingText text);

  /// Supprime un texte utilisateur.
  Future<void> delete(String id);

  /// Supprime plusieurs textes utilisateur d'un coup (ex. tous les extraits
  /// d'un même livre).
  Future<void> deleteAll(Iterable<String> ids);
}
