import '../text/tokenizer.dart';

/// LR1 — Nombre de mots d'un texte (base du calcul de vitesse).
int countWords(String text) => tokenizeWords(text).length;
