import 'dart:math';

import 'random_source.dart';

/// Source sûre pour la production (non reproductible par conception).
class SecureRandomSource implements RandomSource {
  final Random _random = Random.secure();

  @override
  int nextInt(int max) => _random.nextInt(max);
}
