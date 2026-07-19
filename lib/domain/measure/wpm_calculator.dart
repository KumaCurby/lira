/// LR1 — Vitesse de lecture en mots par minute (mpm).
///
/// `mpm = nbMots × 60000 / duréeEnMs`, arrondi à l'entier le plus proche.
int wordsPerMinute({required int wordCount, required Duration elapsed}) {
  if (elapsed <= Duration.zero) {
    throw ArgumentError(
      'elapsed doit être strictement positif (reçu $elapsed)',
    );
  }
  if (wordCount < 0) {
    throw ArgumentError('wordCount doit être >= 0 (reçu $wordCount)');
  }
  return (wordCount * 60000 / elapsed.inMilliseconds).round();
}
