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
