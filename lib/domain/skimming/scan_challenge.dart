import '../../core/clock/clock.dart';
import '../../core/text/normalize.dart';

/// LR8 — Défi de balayage : retrouver une information précise ([target]) dans
/// un [text], le plus vite possible. La comparaison passe par `normalize`, donc
/// insensible à la casse, aux accents et à la ponctuation. Chronométré via [Clock].
class ScanChallenge {
  ScanChallenge(
    this._clock, {
    required this.text,
    required this.target,
    List<String> acceptedAnswers = const [],
  }) : _accepted = {
         normalize(target),
         for (final answer in acceptedAnswers) normalize(answer),
       };

  final Clock _clock;
  final String text;
  final String target;
  final Set<String> _accepted;

  DateTime? _startedAt;

  /// Démarre le chronomètre de recherche.
  void start() => _startedAt = _clock.now();

  /// Vrai si [submission] correspond à la cible (ou à une réponse acceptée).
  bool check(String submission) => _accepted.contains(normalize(submission));

  /// Durée écoulée depuis [start].
  Duration get elapsed {
    final startedAt = _startedAt;
    if (startedAt == null) {
      throw StateError('elapsed consulté avant start()');
    }
    return _clock.now().difference(startedAt);
  }
}
