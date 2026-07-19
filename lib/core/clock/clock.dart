/// Horloge INJECTABLE.
///
/// Toute mesure de temps (chronométrage d'une lecture, d'un balayage, d'une
/// table de Schulte…) passe par cette abstraction, jamais par `DateTime.now()`
/// directement. On injecte une [FixedClock] en test pour des durées
/// déterministes, sans `sleep` ni instabilité.
abstract class Clock {
  /// L'instant courant.
  DateTime now();
}
