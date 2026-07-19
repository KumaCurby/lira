/// Un mot = une suite de lettres/chiffres, éventuellement reliée par des
/// apostrophes ou traits d'union internes (`aujourd'hui`, `peut-être`).
/// La ponctuation isolée et les espaces sont ignorés.
final RegExp _wordPattern = RegExp(
  r"[\p{L}\p{N}]+(?:['’\-][\p{L}\p{N}]+)*",
  unicode: true,
);

/// LR0 — Découpe un texte en mots.
///
/// Brique de base : sert au comptage de mots (mpm), au découpage RSVP et au
/// guidage. Ne conserve que les mots ; la ponctuation seule n'en est pas un.
List<String> tokenizeWords(String text) =>
    _wordPattern.allMatches(text).map((match) => match[0]!).toList();
