import '../measure/comprehension_score.dart';
import '../measure/word_counter.dart';

/// Provenance d'un texte : fourni avec l'app, ou importé par l'utilisateur.
enum TextSource { builtin, user }

/// Un texte lisible dans l'app, avec ses éventuelles questions de compréhension
/// et sa cible de balayage. Enrichi (sérialisation, difficulté) en Phase 1.
class ReadingText {
  const ReadingText({
    required this.id,
    required this.title,
    required this.body,
    required this.source,
    this.difficulty,
    this.questions = const [],
    this.scanTarget,
    this.bookId,
    this.bookTitle,
    this.partIndex,
  });

  final String id;
  final String title;
  final String body;
  final TextSource source;

  /// Niveau de difficulté 1..5 (optionnel).
  final int? difficulty;

  /// Questions de compréhension associées (peut être vide).
  final List<Question> questions;

  /// Information à retrouver pour l'exercice de balayage (optionnel).
  final String? scanTarget;

  /// Identifiant du livre d'origine (les extraits d'un même import le partagent).
  /// `null` pour un texte autonome (corpus, texte collé simple).
  final String? bookId;

  /// Titre du livre d'origine (en-tête du groupe dans la bibliothèque).
  final String? bookTitle;

  /// Numéro de l'extrait dans le livre (1-based), `null` si texte autonome.
  final int? partIndex;

  /// Vrai si ce texte est un extrait d'un livre importé (regroupable).
  bool get isBookPart => bookId != null;

  /// Nombre de mots du corps du texte.
  int get wordCount => countWords(body);
}
