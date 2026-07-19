/// Source d'aléatoire INJECTABLE.
///
/// Toute la logique qui a besoin de hasard (mélange des tables de Schulte,
/// tirage d'exercices…) passe par cette abstraction, jamais par `dart:math`
/// directement. C'est ce qui rend le moteur testable de façon déterministe :
/// on injecte une source à graine fixe en test, une source sûre en production.
abstract class RandomSource {
  /// Renvoie un entier uniforme dans l'intervalle [0, max).
  int nextInt(int max);
}
