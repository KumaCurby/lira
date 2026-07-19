/// LR6 — Une table de Schulte : grille carrée `size × size` contenant les
/// nombres `1..size²` dans un ordre quelconque, stockés ligne par ligne.
class SchulteTable {
  SchulteTable({required this.size, required this.cells})
    : assert(cells.length == size * size, 'cells doit contenir size² valeurs');

  final int size;
  final List<int> cells;

  /// Nombre de cases (size²).
  int get count => size * size;

  /// Valeur à la ligne [row], colonne [col].
  int cellAt(int row, int col) => cells[row * size + col];

  /// Position (ligne, colonne) d'une valeur présente dans la grille.
  ({int row, int col}) positionOf(int value) {
    final index = cells.indexOf(value);
    if (index < 0) {
      throw ArgumentError('valeur $value absente de la grille');
    }
    return (row: index ~/ size, col: index % size);
  }
}
