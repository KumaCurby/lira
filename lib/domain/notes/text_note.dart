/// LR16 — Note personnelle liée à un texte lu. Peut contenir :
/// - un **résumé** (3 phrases post-quiz, ou plus long) ;
/// - une colonne **cues** (mots-clés / questions, méthode Cornell) ;
/// - des **notes** libres (colonne principale Cornell).
class TextNote {
  const TextNote({
    required this.id,
    required this.textId,
    required this.createdAt,
    this.summary,
    this.cues,
    this.notes,
  });

  /// Identifiant stable (généré à partir de la date de création).
  final String id;

  /// Texte auquel la note se rapporte.
  final String textId;

  /// Instant de création.
  final DateTime createdAt;

  /// Résumé libre (ex. 3 phrases post-quiz). Peut être vide.
  final String? summary;

  /// Colonne « cues » de la méthode Cornell : mots-clés, questions.
  final String? cues;

  /// Colonne « notes » de la méthode Cornell : notes détaillées.
  final String? notes;

  /// Vrai si la note est vide (aucun contenu).
  bool get isEmpty =>
      (summary == null || summary!.trim().isEmpty) &&
      (cues == null || cues!.trim().isEmpty) &&
      (notes == null || notes!.trim().isEmpty);

  TextNote copyWith({String? summary, String? cues, String? notes}) => TextNote(
    id: id,
    textId: textId,
    createdAt: createdAt,
    summary: summary ?? this.summary,
    cues: cues ?? this.cues,
    notes: notes ?? this.notes,
  );
}
