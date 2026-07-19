/// LR2 — Vitesse EFFECTIVE : mpm pondérée par le taux de compréhension.
///
/// Lire vite sans comprendre ne compte pas : `mpmEffective = mpm × compréhension`
/// (compréhension dans [0, 1]). C'est la métrique de progression de référence.
int effectiveWpm({required int wpm, required double comprehension}) {
  if (comprehension < 0 || comprehension > 1) {
    throw ArgumentError(
      'comprehension doit être dans [0, 1] (reçu $comprehension)',
    );
  }
  return (wpm * comprehension).round();
}
