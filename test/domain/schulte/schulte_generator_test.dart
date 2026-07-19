import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/core/random/seeded_random_source.dart';
import 'package:lecture_rapide/domain/schulte/schulte_generator.dart';

void main() {
  group('SchulteGenerator (LR6)', () {
    test('produit une grille size×size contenant 1..size²', () {
      final table = SchulteGenerator(SeededRandomSource(1)).generate(size: 5);

      expect(table.size, 5);
      expect(table.cells, hasLength(25));
      expect(table.cells.toSet(), {for (var n = 1; n <= 25; n++) n});
    });

    test('est reproductible : même graine => même grille', () {
      final a = SchulteGenerator(SeededRandomSource(42)).generate(size: 5);
      final b = SchulteGenerator(SeededRandomSource(42)).generate(size: 5);
      expect(a.cells, b.cells);
    });

    test('des graines différentes donnent des grilles différentes', () {
      final a = SchulteGenerator(SeededRandomSource(1)).generate(size: 5);
      final b = SchulteGenerator(SeededRandomSource(2)).generate(size: 5);
      expect(a.cells, isNot(b.cells));
    });

    test('cellAt et positionOf restent cohérents', () {
      final table = SchulteGenerator(SeededRandomSource(7)).generate(size: 4);
      for (var value = 1; value <= table.count; value++) {
        final pos = table.positionOf(value);
        expect(table.cellAt(pos.row, pos.col), value);
      }
    });

    test('refuse une taille < 1', () {
      expect(
        () => SchulteGenerator(SeededRandomSource(1)).generate(size: 0),
        throwsArgumentError,
      );
    });
  });
}
