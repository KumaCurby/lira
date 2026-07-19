/// Fin de phrase : un ou plusieurs `.`, `!`, `?` ou `…`.
final RegExp _sentenceEnd = RegExp(r'[.!?…]+');

/// Séparateur de paragraphe : une ligne vide (deux retours à la ligne).
final RegExp _blankLine = RegExp(r'\n\s*\n');

/// LR0 — Découpe un texte en phrases (ponctuation finale retirée).
///
/// Découpage volontairement simple : suffisant pour extraire les phrases-sujets
/// de l'écrémage. Les abréviations (« M. Dupont ») ne sont pas traitées.
List<String> splitSentences(String text) => text
    .split(_sentenceEnd)
    .map((sentence) => sentence.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList();

/// LR0 — Découpe un texte en paragraphes, séparés par une ligne vide.
List<String> splitParagraphs(String text) => text
    .split(_blankLine)
    .map((paragraph) => paragraph.trim())
    .where((paragraph) => paragraph.isNotEmpty)
    .toList();
