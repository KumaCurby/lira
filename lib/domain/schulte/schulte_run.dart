import '../../core/clock/clock.dart';

/// LR6 — Déroulé d'une table de Schulte : on doit toucher les cases dans l'ordre
/// `1, 2, 3, …`. Compte les erreurs et chronomètre via une [Clock] injectée.
class SchulteRun {
  SchulteRun(this._clock, {required this.count});

  final Clock _clock;

  /// Nombre de cases à toucher (size²).
  final int count;

  int _next = 1;
  int _errors = 0;
  DateTime? _startedAt;
  DateTime? _finishedAt;

  /// Démarre (ou réinitialise) le déroulé.
  void start() {
    _startedAt = _clock.now();
    _finishedAt = null;
    _next = 1;
    _errors = 0;
  }

  /// Enregistre un tap sur [value]. Renvoie `true` si c'était la case attendue.
  bool tap(int value) {
    if (isComplete) return false;
    if (value == _next) {
      _next++;
      if (isComplete) _finishedAt = _clock.now();
      return true;
    }
    _errors++;
    return false;
  }

  int get errors => _errors;

  /// Prochaine valeur attendue.
  int get nextExpected => _next;

  bool get isComplete => _next > count;

  /// Durée écoulée depuis [start] ; figée à l'instant d'achèvement.
  Duration get elapsed {
    final startedAt = _startedAt;
    if (startedAt == null) {
      throw StateError('elapsed consulté avant start()');
    }
    return (_finishedAt ?? _clock.now()).difference(startedAt);
  }
}
