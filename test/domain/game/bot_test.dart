import 'package:align/domain/game/board.dart';
import 'package:align/domain/game/bot/bot_strategy.dart';
import 'package:align/domain/game/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyBotStrategy', () {
    test('returns a valid move on empty board', () {
      final board = Board(size: 3);
      final bot = EasyBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect(move, greaterThanOrEqualTo(0));
      expect(move, lessThan(9));
      expect(board.isEmptyAt(move), true);
    });

    test('returns valid move when some cells are occupied', () {
      final board = Board(size: 3, cells: [
        Player.x, Player.o, null,
        null, Player.x, null,
        null, null, null,
      ]);
      final bot = EasyBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect(move, greaterThanOrEqualTo(0));
      expect(move, lessThan(9));
      expect(board.isEmptyAt(move), true);
    });

    test('returns valid move when only one cell is empty', () {
      final board = Board(size: 3, cells: [
        Player.x, Player.o, Player.x,
        Player.o, Player.x, Player.o,
        Player.x, Player.o, null,
      ]);
      final bot = EasyBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect(move, 8); // Only valid move
    });
  });

  group('HardBotStrategy', () {
    test('blocks opponent winning move', () {
      final board = Board(size: 3, cells: [
        Player.x, Player.x, null, // X about to win at index 2
        Player.o, null, null,
        null, null, null,
      ]);
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Bot should block at index 2
      expect(move, 2);
    });

    test('takes winning move when available', () {
      final board = Board(size: 3, cells: [
        Player.o, Player.o, null, // O can win at index 2
        Player.x, Player.x, null,
        null, null, null,
      ]);
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Bot should win at index 2
      expect(move, 2);
    });

    test('prioritizes winning over blocking', () {
      final board = Board(size: 3, cells: [
        Player.o, Player.o, null, // O can win at index 2
        Player.x, Player.x, null, // X threatens at index 5
        null, null, null,
      ]);
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Bot should win immediately rather than block
      expect(move, 2);
    });

    test('takes strategic position on empty 3x3 board', () {
      final board = Board(size: 3);
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Hard bot should prefer center or corner (strategic)
      final strategicPositions = [0, 2, 4, 6, 8]; // Center + corners
      expect(strategicPositions.contains(move), true);
    });
  });

  group('MediumBotStrategy', () {
    test('blocks winning moves most of the time', () {
      final board = Board(size: 3, cells: [
        Player.x, Player.x, null, // X about to win at index 2
        Player.o, null, null,
        null, null, null,
      ]);
      final bot = MediumBotStrategy();

      // Run multiple times - should block most of the time (90%)
      int blockedCount = 0;
      for (var i = 0; i < 20; i++) {
        final move = bot.selectMove(board, Player.o);
        if (move == 2) blockedCount++;
      }

      // Should block at least 50% of the time (accounting for 10% randomness)
      expect(blockedCount, greaterThan(10));
    });

    test('takes winning move when available', () {
      final board = Board(size: 3, cells: [
        Player.o, Player.o, null, // O can win at index 2
        Player.x, null, null,
        null, null, null,
      ]);
      final bot = MediumBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Should always take winning move (no randomness here)
      expect(move, 2);
    });

    test('prefers center on empty 3x3 board', () {
      final board = Board(size: 3);
      final bot = MediumBotStrategy();

      // Run multiple times to test behavior
      final moves = <int>[];
      for (var i = 0; i < 20; i++) {
        final move = bot.selectMove(board, Player.o);
        moves.add(move);
      }

      // Should prefer center or corners most of the time
      final centerCount = moves.where((m) => m == 4).length;
      expect(centerCount, greaterThan(10)); // More than half
    });
  });
}
