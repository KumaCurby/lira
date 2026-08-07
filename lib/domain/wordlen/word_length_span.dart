/// LR24 — Segment de texte tagué par un `WordLengthTagger` : soit un mot dont
/// on connaît la longueur en lettres (via [letters]), soit un fragment
/// non-mot (espaces, ponctuation…) dont [letters] vaut 0.
class LengthSpan {
  const LengthSpan({required this.text, required this.letters});
  final String text;
  final int letters;
  bool matches({required int min, required int max}) =>
      letters >= min && letters <= max;
}

/// LR24 — Découpe un [text] en spans en distinguant les mots (leur longueur
/// en lettres) et les non-mots. La longueur d'un mot compte **les lettres**
/// (`\p{L}` — accents inclus), pas la ponctuation intérieure (`aujourd'hui` =
/// 9 lettres, pas 11).
List<LengthSpan> tagByWordLength(String text) {
  final re = RegExp(r"\p{L}+(?:['’\-]\p{L}+)*", unicode: true);
  final letter = RegExp(r'\p{L}', unicode: true);
  final spans = <LengthSpan>[];
  var last = 0;
  for (final m in re.allMatches(text)) {
    if (m.start > last) {
      spans.add(LengthSpan(text: text.substring(last, m.start), letters: 0));
    }
    final word = m[0]!;
    final n = letter.allMatches(word).length;
    spans.add(LengthSpan(text: word, letters: n));
    last = m.end;
  }
  if (last < text.length) {
    spans.add(LengthSpan(text: text.substring(last), letters: 0));
  }
  return spans;
}

/// LR24 — Trois plages proposées à l'utilisateur.
enum WordLengthRange {
  short, // 3-4 lettres
  medium, // 5-6 lettres
  long, // 7+ lettres
}

({int min, int max}) rangeBounds(WordLengthRange r) => switch (r) {
  WordLengthRange.short => (min: 3, max: 4),
  WordLengthRange.medium => (min: 5, max: 6),
  WordLengthRange.long => (min: 7, max: 999),
};
