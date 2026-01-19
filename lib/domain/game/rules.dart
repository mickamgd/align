import 'board.dart';
import 'player.dart';

sealed class GameResult {
  const GameResult();
}

class InProgress extends GameResult {
  const InProgress();
}

class Draw extends GameResult {
  const Draw();
}

class Win extends GameResult {
  const Win({required this.winner, required this.lineIndices});

  final Player winner;
  final List<int> lineIndices;
}

class Rules {
  /// Winning condition: N-in-a-row on an NxN board.
  static GameResult evaluate(Board board) {
    final lines = _winningLines(board.size);

    for (final line in lines) {
      final firstCell = board.cells[line.first];
      if (firstCell == null) continue;

      final isWinningLine = line.every((i) => board.cells[i] == firstCell);
      if (isWinningLine) {
        return Win(
          winner: firstCell,
          lineIndices: List<int>.unmodifiable(line),
        );
      }
    }

    return board.isFull ? const Draw() : const InProgress();
  }

  static List<List<int>> _winningLines(int size) {
    final lines = <List<int>>[];

    // Rows
    for (int r = 0; r < size; r++) {
      lines.add(List<int>.generate(size, (c) => r * size + c));
    }

    // Columns
    for (int c = 0; c < size; c++) {
      lines.add(List<int>.generate(size, (r) => r * size + c));
    }

    // Diagonal top-left -> bottom-right
    lines.add(List<int>.generate(size, (i) => i * size + i));

    // Diagonal top-right -> bottom-left
    lines.add(List<int>.generate(size, (i) => i * size + (size - 1 - i)));

    return lines;
  }
}
