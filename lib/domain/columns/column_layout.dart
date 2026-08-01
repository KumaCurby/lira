import '../text/tokenizer.dart';

/// LR14 — Répartit les mots d'un [text] en [columnCount] colonnes équilibrées :
/// chaque colonne contient à peu près le même nombre de mots, dans l'ordre.
/// Base de l'exercice « lecture en colonnes » (réduction du nombre de fixations
/// par ligne : la colonne étant étroite, l'œil saute moins souvent).
List<String> splitIntoColumns(String text, {required int columnCount}) {
  if (columnCount < 1) {
    throw ArgumentError('columnCount doit être >= 1 (reçu $columnCount)');
  }
  final words = tokenizeWords(text);
  if (words.isEmpty) return List.filled(columnCount, '');
  final per = (words.length / columnCount).ceil();
  return [
    for (var i = 0; i < columnCount; i++)
      words.skip(i * per).take(per).join(' '),
  ];
}
