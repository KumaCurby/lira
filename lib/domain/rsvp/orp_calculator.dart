/// LR3 — Point de fixation optimal (ORP), l'indice de la lettre à aligner/colorer.
///
/// En RSVP, l'œil reconnaît le mot plus vite si un point légèrement à gauche du
/// centre reste fixe. Barème usuel (type Spritz) selon la longueur du mot :
/// 1 → 0, 2–5 → 1, 6–9 → 2, 10–13 → 3, 14+ → 4.
int orpIndex(String word) {
  final length = word.length;
  if (length <= 1) return 0;
  if (length <= 5) return 1;
  if (length <= 9) return 2;
  if (length <= 13) return 3;
  return 4;
}
