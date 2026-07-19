import '../../core/clock/clock.dart';

/// LR1 — Chronomètre une lecture au moyen d'une [Clock] injectée.
///
/// Testable de façon déterministe : en test on injecte une `FixedClock` que
/// l'on fait avancer manuellement, sans dépendre du temps réel.
class ReadingTimer {
  ReadingTimer(this._clock);

  final Clock _clock;
  DateTime? _startedAt;

  /// Démarre (ou redémarre) le chronomètre.
  void start() => _startedAt = _clock.now();

  /// Arrête le chronomètre et renvoie la durée écoulée depuis [start].
  Duration stop() {
    final startedAt = _startedAt;
    if (startedAt == null) {
      throw StateError('stop() appelé sans start() préalable');
    }
    _startedAt = null;
    return _clock.now().difference(startedAt);
  }

  bool get isRunning => _startedAt != null;
}
