import 'clock.dart';

/// Horloge contrôlable, pour les tests et les démonstrations.
///
/// On la positionne à un instant précis, puis on la fait avancer manuellement
/// avec [advance] afin de simuler l'écoulement du temps de façon déterministe.
class FixedClock implements Clock {
  FixedClock(this._current);

  DateTime _current;

  @override
  DateTime now() => _current;

  /// Remplace l'instant courant.
  void set(DateTime time) => _current = time;

  /// Fait avancer l'horloge de [by].
  void advance(Duration by) => _current = _current.add(by);
}
