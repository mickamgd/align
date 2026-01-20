import 'package:align/domain/game/board.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/domain/game/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rules.evaluate - 3x3 board', () {
    test('detects horizontal win', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          null,
          null,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [0, 1, 2]);
    });

    test('detects vertical win', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          null,
          Player.x,
          Player.o,
          null,
          Player.x,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [0, 3, 6]);
    });

    test('detects diagonal win (top-left to bottom-right)', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          null,
          Player.o,
          Player.x,
          null,
          null,
          null,
          Player.x,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [0, 4, 8]);
    });

    test('detects diagonal win (top-right to bottom-left)', () {
      final board = Board(
        size: 3,
        cells: [
          Player.o,
          null,
          Player.x,
          Player.o,
          Player.x,
          null,
          Player.x,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [2, 4, 6]);
    });

    test('detects draw when board is full with no winner', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          Player.x,
          Player.o,
          Player.o,
          Player.x,
          Player.o,
          Player.x,
          Player.o,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Draw>());
    });

    test('returns InProgress when game is not finished', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          null,
          Player.o,
          null,
          null,
          null,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<InProgress>());
    });
  });

  group('Rules.evaluate - 4x4 board', () {
    test('detects horizontal win in middle row', () {
      final board = Board(
        size: 4,
        cells: [
          null,
          null,
          null,
          null,
          Player.x,
          Player.x,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.o,
          null,
          null,
          null,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [4, 5, 6, 7]);
    });

    test('detects vertical win in last column', () {
      final board = Board(
        size: 4,
        cells: [
          null,
          null,
          null,
          Player.o,
          null,
          null,
          null,
          Player.o,
          null,
          null,
          null,
          Player.o,
          null,
          null,
          null,
          Player.o,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.o);
      expect(win.lineIndices, [3, 7, 11, 15]);
    });

    test('detects main diagonal win', () {
      final board = Board(
        size: 4,
        cells: [
          Player.x,
          null,
          null,
          null,
          null,
          Player.x,
          null,
          null,
          null,
          null,
          Player.x,
          null,
          null,
          null,
          null,
          Player.x,
        ],
      );

      final result = Rules.evaluate(board);

      expect(result, isA<Win>());
      final win = result as Win;
      expect(win.winner, Player.x);
      expect(win.lineIndices, [0, 5, 10, 15]);
    });

    test('does not detect win when line is incomplete (4x4)', () {
      final board = Board(
        size: 4,
        cells: [
          Player.x,
          Player.x,
          Player.x,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ],
      );

      final result = Rules.evaluate(board);
      expect(result, isA<InProgress>());
    });
  });

  group('Board operations', () {
    test('placeAt creates new board with move', () {
      final board = Board(size: 3);
      final newBoard = board.placeAt(4, Player.x);

      expect(board.cells[4], null); // Original unchanged
      expect(newBoard.cells[4], Player.x); // New board has move
    });

    test('isEmptyAt returns correct value', () {
      final board = Board(
        size: 3,
        cells: [Player.x, null, null, null, null, null, null, null, null],
      );

      expect(board.isEmptyAt(0), false);
      expect(board.isEmptyAt(1), true);
    });
  });
}
