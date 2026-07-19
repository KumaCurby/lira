/// Table de correspondance des caractères accentués vers leur équivalent ASCII.
const Map<String, String> _accents = {
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'á': 'a',
  'ã': 'a',
  'å': 'a',
  'ç': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'í': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ô': 'o',
  'ö': 'o',
  'ó': 'o',
  'õ': 'o',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ú': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'œ': 'oe',
  'æ': 'ae',
};

final RegExp _nonAlphaNum = RegExp('[^a-z0-9]+');

/// Normalise une chaîne pour des comparaisons robustes (balayage, réponses…).
///
/// Passe en minuscules, retire les accents et ligatures, remplace toute
/// ponctuation par une espace, puis compacte les espaces. Ainsi
/// `« L'Éléphant, GRIS ! »` et `« l elephant gris »` deviennent identiques.
String normalize(String input) {
  final lower = input.toLowerCase();

  final deAccented = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    deAccented.write(_accents[char] ?? char);
  }

  return deAccented.toString().replaceAll(_nonAlphaNum, ' ').trim();
}
