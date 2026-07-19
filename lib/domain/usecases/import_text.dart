import '../text/difficulty.dart';
import '../text/reading_text.dart';

/// Longueur maximale d'un titre dérivé automatiquement.
const int _maxTitleLength = 40;

/// Crée un [ReadingText] utilisateur à partir d'un texte brut collé/importé.
///
/// L'[id] est fourni par l'appelant (ex. UUID côté app) pour rester
/// déterministe et testable. À défaut de [title], un titre est dérivé du début
/// du texte. La difficulté est estimée automatiquement.
ReadingText importText({
  required String id,
  required String raw,
  String? title,
}) {
  final body = raw.trim();
  if (body.isEmpty) {
    throw ArgumentError('le texte importé est vide');
  }

  final resolvedTitle = (title == null || title.trim().isEmpty)
      ? _deriveTitle(body)
      : title.trim();

  return ReadingText(
    id: id,
    title: resolvedTitle,
    body: body,
    source: TextSource.user,
    difficulty: estimateDifficulty(body),
  );
}

String _deriveTitle(String body) {
  final firstLine = body.split('\n').first.trim();
  if (firstLine.length <= _maxTitleLength) return firstLine;
  return '${firstLine.substring(0, _maxTitleLength).trimRight()}…';
}
