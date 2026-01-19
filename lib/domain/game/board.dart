import 'player.dart';

class Board {
  Board({required this.size, List<Player?>? cells})
    : cells = List<Player?>.unmodifiable(
        cells ?? List<Player?>.filled(size * size, null),
      ) {
    assert(size >= 3, 'Board size must be >= 3');
    assert(this.cells.length == size * size, 'Invalid cells length');
  }

  final int size;
  final List<Player?> cells;

  int index(int row, int col) => row * size + col;

  Player? cellAt(int row, int col) => cells[index(row, col)];

  bool get isFull => !cells.any((c) => c == null);

  bool isEmptyAt(int i) => cells[i] == null;

  Board placeAt(int i, Player player) {
    if (i < 0 || i >= cells.length) {
      throw RangeError.index(i, cells, 'i');
    }
    if (cells[i] != null) {
      throw StateError('Cell is already occupied');
    }

    final next = List<Player?>.from(cells);
    next[i] = player;
    return Board(size: size, cells: next);
  }
}
