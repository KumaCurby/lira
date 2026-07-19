/// LR4 — Une « image » RSVP : le mot affiché, l'indice de sa lettre-pivot
/// (ORP) et la durée pendant laquelle il reste à l'écran.
class RsvpFrame {
  const RsvpFrame({
    required this.word,
    required this.orpIndex,
    required this.duration,
  });

  final String word;
  final int orpIndex;
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      other is RsvpFrame &&
      other.word == word &&
      other.orpIndex == orpIndex &&
      other.duration == duration;

  @override
  int get hashCode => Object.hash(word, orpIndex, duration);

  @override
  String toString() =>
      'RsvpFrame($word, orp=$orpIndex, ${duration.inMilliseconds}ms)';
}
