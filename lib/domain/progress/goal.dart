/// LR9 — Objectif de vitesse de lecture (mpm) à atteindre.
class Goal {
  const Goal({required this.targetWpm});

  final int targetWpm;

  /// Vrai si [wpm] atteint ou dépasse la cible.
  bool isReachedBy(int wpm) => wpm >= targetWpm;

  /// Avancement vers l'objectif, borné à [0, 1].
  double progressFrom(int wpm) => (wpm / targetWpm).clamp(0.0, 1.0).toDouble();
}

/// Propose un objectif à partir d'une vitesse mesurée : ~+30 %, arrondi à la
/// dizaine, borné à [250, 800] mpm.
int suggestGoalWpm(int measuredWpm) {
  final raw = (measuredWpm * 1.3 / 10).round() * 10;
  return raw.clamp(250, 800);
}
