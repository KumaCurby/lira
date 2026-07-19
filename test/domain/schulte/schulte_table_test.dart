import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_rapide/domain/schulte/schulte_table.dart';

void main() {
  group('SchulteTable (LR6)', () {
    test('cellAt lit la grille ligne par ligne', () {
      final table = SchulteTable(size: 2, cells: [1, 2, 3, 4]);
      expect(table.cellAt(0, 0), 1);
      expect(table.cellAt(0, 1), 2);
      expect(table.cellAt(1, 0), 3);
      expect(table.cellAt(1, 1), 4);
    });

    test('positionOf retrouve la ligne et la colonne', () {
      final table = SchulteTable(size: 2, cells: [3, 1, 4, 2]);
      expect(table.positionOf(4), (row: 1, col: 0));
    });

    test('count vaut size²', () {
      final table = SchulteTable(
        size: 3,
        cells: List.generate(9, (i) => i + 1),
      );
      expect(table.count, 9);
    });

    test('positionOf lève si la valeur est absente', () {
      final table = SchulteTable(size: 2, cells: [1, 2, 3, 4]);
      expect(() => table.positionOf(99), throwsArgumentError);
    });
  });
}
