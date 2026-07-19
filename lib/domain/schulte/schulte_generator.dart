import '../../core/random/random_source.dart';
import 'schulte_table.dart';

/// LR6 — Génère une table de Schulte en mélangeant `1..size²`.
///
/// Le mélange de Fisher–Yates s'appuie sur la [RandomSource] injectée : grille
/// reproductible en test (graine fixe), aléatoire sûre en production. Même
/// principe que le tirage de numéros distincts du projet loto.
class SchulteGenerator {
  SchulteGenerator(this._random);

  final RandomSource _random;

  SchulteTable generate({required int size}) {
    if (size < 1) {
      throw ArgumentError('size doit être >= 1 (reçu $size)');
    }
    final cells = List<int>.generate(size * size, (i) => i + 1);
    for (var i = cells.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = cells[i];
      cells[i] = cells[j];
      cells[j] = temp;
    }
    return SchulteTable(size: size, cells: cells);
  }
}
