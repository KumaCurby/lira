import '../../core/random/random_source.dart';

/// LR10 — Typoglycémie : mélange l'intérieur des mots.
///
/// Principe : si l'on garde la **première** et la **dernière** lettre d'un mot
/// à leur place et que l'on mélange seulement les lettres du milieu, le cerveau
/// lit quand même le mot — il le reconnaît par sa forme globale plutôt que
/// lettre à lettre. C'est un entraînement classique de lecture rapide.
///
/// Comme le reste du moteur, l'aléatoire passe par une [RandomSource] injectée
/// → mélange reproductible en test (graine fixe), varié en production.

/// Longueur minimale d'un mot pour qu'il ait un intérieur mélangeable
/// (2 lettres fixes + au moins 2 au milieu).
const int kScrambleMinLength = 4;

/// Un « mot » = une suite de lettres, éventuellement soudée par des apostrophes
/// ou traits d'union internes (`aujourd'hui`, `peut-être`, `c'est-à-dire`). On
/// le traite comme **une seule unité** : seules la 1re et la dernière lettre du
/// mot entier sont fixes, la ponctuation interne reste à sa place (voir
/// [scrambleWord]). Les chiffres ne sont jamais mélangés (hors motif).
final RegExp scrambleWordPattern = RegExp(
  r"\p{L}+(?:['’\-]\p{L}+)*",
  unicode: true,
);

final RegExp _oneLetter = RegExp(r'\p{L}', unicode: true);

/// Mélange l'intérieur d'un mot en conservant la première et la dernière
/// **lettre** à leur place, ainsi que toute ponctuation interne (`'`, `-`).
///
/// - Les mots de moins de [minLength] caractères — ou ayant moins de 2 lettres
///   mobiles — sont renvoyés tels quels. [minLength] pilote l'intensité : plus
///   il est grand, plus on laisse de mots courts intacts (lecture plus facile).
/// - Sans [derange], le mélange est un Fisher–Yates ; si le tirage redonne
///   l'ordre d'origine alors qu'un autre est possible, on force un échange pour
///   qu'un mot assez long ressorte **toujours** visiblement mélangé.
/// - Avec [derange] (intensité maximale), **aucune** lettre mobile ne reste à
///   sa position d'origine quand c'est possible (dérangement).
String scrambleWord(
  String word,
  RandomSource random, {
  int minLength = kScrambleMinLength,
  bool derange = false,
}) {
  final chars = word.split('');
  if (chars.length < minLength) return word;

  // Positions mobiles : le milieu, en sautant la ponctuation interne (', -),
  // qui reste figée à sa place.
  final movable = <int>[];
  for (var i = 1; i < chars.length - 1; i++) {
    if (_oneLetter.hasMatch(chars[i])) movable.add(i);
  }
  if (movable.length < 2) return word;

  final letters = [for (final i in movable) chars[i]];
  final original = List<String>.of(letters);

  for (var i = letters.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final temp = letters[i];
    letters[i] = letters[j];
    letters[j] = temp;
  }

  if (derange) {
    // Supprime les points fixes : aucune lettre mobile à sa position d'origine.
    for (var i = 0; i < letters.length; i++) {
      if (letters[i] == original[i]) {
        final j = (i + 1) % letters.length;
        final temp = letters[i];
        letters[i] = letters[j];
        letters[j] = temp;
      }
    }
  } else if (_sameOrder(letters, original) && letters.toSet().length > 1) {
    // Garantir un vrai mélange quand une autre disposition existe.
    outer:
    for (var i = 0; i < letters.length; i++) {
      for (var j = i + 1; j < letters.length; j++) {
        if (letters[i] != letters[j]) {
          final temp = letters[i];
          letters[i] = letters[j];
          letters[j] = temp;
          break outer;
        }
      }
    }
  }

  for (var k = 0; k < movable.length; k++) {
    chars[movable[k]] = letters[k];
  }
  return chars.join();
}

bool _sameOrder(List<String> a, List<String> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Applique [scrambleWord] à chaque mot d'un [text], en préservant **exactement**
/// tout le reste : espaces, ponctuation, chiffres et retours à la ligne restent
/// en place. Les mots sont traités de gauche à droite ; avec une source à graine
/// fixe, le résultat est donc entièrement reproductible.
String scrambleText(
  String text,
  RandomSource random, {
  int minLength = kScrambleMinLength,
  bool derange = false,
}) => text.replaceAllMapped(
  scrambleWordPattern,
  (m) => scrambleWord(m[0]!, random, minLength: minLength, derange: derange),
);

/// Graine entière **stable** dérivée d'une chaîne (typiquement l'id d'un texte),
/// indépendante de l'exécution : permet, via une source à graine fixe, de
/// retrouver le **même** mélange en revenant sur un texte (pour comparer les
/// scores). Petit hachage type FNV/polynomial, borné pour rester positif.
int stableSeed(String s) {
  var h = 0;
  for (final unit in s.codeUnits) {
    h = (h * 31 + unit) & 0x3fffffff;
  }
  return h == 0 ? 1 : h;
}
