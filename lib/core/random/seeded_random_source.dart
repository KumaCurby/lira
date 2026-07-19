import 'dart:math';

import 'random_source.dart';

/// Source DÉTERMINISTE : une même graine produit toujours la même séquence.
/// Utilisée en test (reproductibilité) et pour un éventuel mode « rejouable ».
class SeededRandomSource implements RandomSource {
  SeededRandomSource(int seed) : _random = Random(seed);

  final Random _random;

  @override
  int nextInt(int max) => _random.nextInt(max);
}
