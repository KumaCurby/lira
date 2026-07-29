/// LR5 — Regroupe les mots par blocs de [chunkSize] (le dernier peut être plus
/// court). C'est la base de la lecture par groupes de mots (empan) et du guidage.
List<List<String>> chunk(List<String> words, {required int chunkSize}) {
  if (chunkSize < 1) {
    throw ArgumentError('chunkSize doit être >= 1 (reçu $chunkSize)');
  }
  final chunks = <List<String>>[];
  for (var i = 0; i < words.length; i += chunkSize) {
    final end = (i + chunkSize < words.length) ? i + chunkSize : words.length;
    chunks.add(words.sublist(i, end));
  }
  return chunks;
}

/// LR5 — Regroupe les mots avec un **empan croissant** : le premier bloc fait
/// [minSpan] mot(s), chaque bloc suivant en compte un de plus, jusqu'au plafond
/// [maxSpan] (ensuite constant). Base de l'exercice « empan progressif » qui
/// entraîne l'œil à saisir de plus en plus de mots d'un coup.
List<List<String>> progressiveChunk(
  List<String> words, {
  int minSpan = 1,
  int maxSpan = 4,
}) {
  if (minSpan < 1) {
    throw ArgumentError('minSpan doit être >= 1 (reçu $minSpan)');
  }
  if (maxSpan < minSpan) {
    throw ArgumentError('maxSpan doit être >= minSpan ($maxSpan < $minSpan)');
  }
  final chunks = <List<String>>[];
  var span = minSpan;
  var i = 0;
  while (i < words.length) {
    final end = (i + span < words.length) ? i + span : words.length;
    chunks.add(words.sublist(i, end));
    i = end;
    if (span < maxSpan) span++;
  }
  return chunks;
}
