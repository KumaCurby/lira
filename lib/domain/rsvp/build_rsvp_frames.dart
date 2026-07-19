import 'orp_calculator.dart';
import 'rsvp_frame.dart';

/// Ponctuation en bord de mot à retirer pour mesurer le « cœur » du mot.
final RegExp _edgePunctuation = RegExp(
  r"^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$",
  unicode: true,
);

const Set<String> _sentenceEnders = {'.', '!', '?', '…'};
const Set<String> _clauseEnders = {',', ';', ':'};

/// LR4 — Construit la séquence de frames RSVP pour une liste de mots.
///
/// [words] sont les jetons d'affichage (ponctuation comprise). Durée de base =
/// `60000/wpm` ms. Deux raffinements optionnels, chacun activable indépendamment :
/// - [slowLongWords] : +5 % de durée par lettre au-delà de 6 ;
/// - [pauseOnPunctuation] : ×2 en fin de phrase (`. ! ? …`), ×1,5 sur `, ; :`.
List<RsvpFrame> buildRsvpFrames(
  List<String> words, {
  required int wpm,
  bool slowLongWords = true,
  bool pauseOnPunctuation = true,
}) {
  if (wpm <= 0) {
    throw ArgumentError('wpm doit être > 0 (reçu $wpm)');
  }
  final baseMs = 60000 / wpm;

  return [
    for (final word in words)
      RsvpFrame(
        word: word,
        orpIndex: orpIndex(_core(word)),
        duration: Duration(
          milliseconds: _durationMs(
            word,
            baseMs: baseMs,
            slowLongWords: slowLongWords,
            pauseOnPunctuation: pauseOnPunctuation,
          ),
        ),
      ),
  ];
}

/// Le mot sans sa ponctuation de bord (repli sur le mot brut si tout est retiré).
String _core(String word) {
  final core = word.replaceAll(_edgePunctuation, '');
  return core.isEmpty ? word : core;
}

int _durationMs(
  String word, {
  required double baseMs,
  required bool slowLongWords,
  required bool pauseOnPunctuation,
}) {
  var ms = baseMs;

  if (slowLongWords) {
    final length = _core(word).length;
    if (length > 6) ms += baseMs * 0.05 * (length - 6);
  }

  if (pauseOnPunctuation && word.isNotEmpty) {
    final last = word[word.length - 1];
    if (_sentenceEnders.contains(last)) {
      ms *= 2.0;
    } else if (_clauseEnders.contains(last)) {
      ms *= 1.5;
    }
  }

  return ms.round();
}
