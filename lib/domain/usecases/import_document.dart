import '../text/difficulty.dart';
import '../text/passage_splitter.dart';
import '../text/reading_text.dart';

/// Transforme un document brut (texte extrait d'un EPUB/PDF) en une liste de
/// [ReadingText] utilisateur, un par passage d'environ [targetWords] mots.
///
/// Les identifiants sont dérivés de [idPrefix] (`prefix-1`, `prefix-2`…) ;
/// le titre est numéroté « Titre · k/N » (sans suffixe s'il n'y a qu'un passage).
List<ReadingText> importDocument({
  required String idPrefix,
  required String title,
  required String rawText,
  int targetWords = 500,
}) {
  final passages = splitIntoPassages(rawText.trim(), targetWords: targetWords);
  if (passages.isEmpty) {
    throw ArgumentError('aucun texte exploitable dans le document');
  }

  final total = passages.length;
  // Un document d'un seul extrait reste un texte autonome ; au-delà, les
  // extraits sont regroupés sous le même [bookId].
  final grouped = total > 1;
  return [
    for (var i = 0; i < total; i++)
      ReadingText(
        id: '$idPrefix-${i + 1}',
        title: grouped ? '$title · ${i + 1}/$total' : title,
        body: passages[i],
        source: TextSource.user,
        difficulty: estimateDifficulty(passages[i]),
        bookId: grouped ? idPrefix : null,
        bookTitle: grouped ? title : null,
        partIndex: grouped ? i + 1 : null,
      ),
  ];
}
