/// LR12 — Lecture « mots-clés » : repérer les **mots-outils** (petits mots
/// grammaticaux) pour pouvoir les estomper et lire plus vite sans perdre le
/// sens, l'œil se posant sur les mots porteurs de contenu.
///
/// On retient les catégories quasi vides de sens : articles, déterminants,
/// prépositions, pronoms personnels/relatifs, conjonctions de liaison simples
/// **et connecteurs logiques** (mais, car, donc), auxiliaires être/avoir, et la
/// particule « ne ». On **exclut volontairement** les mots qui portent une
/// charge sémantique forte même s'ils sont courts : négations (pas, non,
/// jamais, rien, aucun) et quantifieurs (tout, plus, très)…
const Set<String> kFrenchFunctionWords = {
  // Articles & déterminants
  'le', 'la', 'les', "l'", 'un', 'une', 'des', 'de', 'du', "d'",
  'ce', 'cet', 'cette', 'ces',
  'mon', 'ma', 'mes', 'ton', 'ta', 'tes', 'son', 'sa', 'ses',
  'notre', 'nos', 'votre', 'vos', 'leur', 'leurs',
  // Prépositions
  'à', 'au', 'aux', 'en', 'dans', 'sur', 'sous', 'par', 'pour',
  'avec', 'sans', 'chez', 'vers', 'entre', 'depuis', 'pendant',
  'selon', 'parmi', 'dès',
  // Conjonctions de liaison simples et connecteurs logiques
  'et', 'ou', 'ni', 'que', "qu'", 'comme', 'mais', 'car', 'donc',
  // Pronoms
  'je', "j'", 'tu', 'il', 'elle', 'on', 'nous', 'vous', 'ils', 'elles',
  'me', "m'", 'te', "t'", 'se', "s'", 'lui', 'y',
  "c'", 'qui', 'quoi', 'dont', 'où',
  // Auxiliaires être / avoir (haute fréquence, faible contenu)
  'est', 'sont', 'es', 'suis', 'sommes', 'êtes', 'être',
  'a', 'as', 'ai', 'avons', 'avez', 'ont', 'avoir', 'été',
  // Particule de négation (redondante avec « pas », qui reste visible)
  'ne', "n'",
};

final RegExp _edges = RegExp(r"^[^\p{L}']+|[^\p{L}']+$", unicode: true);

/// Vrai si [word] est un mot-outil (voir [kFrenchFunctionWords]).
///
/// Insensible à la casse et aux accents majuscules (« Le », « À »), et à la
/// ponctuation qui entoure le mot (« (le », « las, »). Un mot élidé collé à sa
/// suite (« l'homme », « d'un ») n'est PAS considéré comme mot-outil : seul le
/// clitic isolé (« l' », « qu' ») l'est.
bool isFunctionWord(String word) {
  final bare = word.toLowerCase().replaceAll(_edges, '');
  return kFrenchFunctionWords.contains(bare);
}
