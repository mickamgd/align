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
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          null,
          null,
          Player.x,
          null,
          null,
          null,
          null,
        ],
      );
      final bot = EasyBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect(move, greaterThanOrEqualTo(0));
      expect(move, lessThan(9));
      expect(board.isEmptyAt(move), true);
    });

    test('returns valid move when only one cell is empty', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          Player.o,
          Player.x,
          Player.o,
          Player.x,
          Player.o,
          Player.x,
          Player.o,
          null,
        ],
      );
      final bot = EasyBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect(move, 8); // Only valid move
    });
  });

  group('HardBotStrategy', () {
    test('blocks opponent winning move', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x, Player.x, null, // X about to win at index 2
          Player.o, null, null,
          null, null, null,
        ],
      );
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Bot should block at index 2
      expect(move, 2);
    });

    test('takes winning move when available', () {
      final board = Board(
        size: 3,
        cells: [
          Player.o, Player.o, null, // O can win at index 2
          Player.x, Player.x, null,
          null, null, null,
        ],
      );
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      // Bot should win at index 2
      expect(move, 2);
    });

    test('prioritizes winning over blocking', () {
      final board = Board(
        size: 3,
        cells: [
          Player.o, Player.o, null, // O can win at index 2
          Player.x, Player.x, null, // X threatens at index 5
          null, null, null,
        ],
      );
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

    test('Hard creates a fork when available (3x3)', () {
      final board = Board(
        size: 3,
        cells: [
          Player.o,
          null,
          null,
          null,
          Player.x,
          null,
          null,
          null,
          Player.o,
        ],
      );
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect([2, 6].contains(move), true);
    });

    test('Hard blocks opponent fork when available (3x3)', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x,
          null,
          null,
          null,
          Player.o,
          null,
          null,
          null,
          Player.x,
        ],
      );
      final bot = HardBotStrategy();

      final move = bot.selectMove(board, Player.o);

      expect([2, 6].contains(move), true);
    });
  });

  group('MediumBotStrategy', () {
    test('blocks winning moves most of the time', () {
      final board = Board(
        size: 3,
        cells: [
          Player.x, Player.x, null, // X about to win at index 2
          Player.o, null, null,
          null, null, null,
        ],
      );
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

    test('takes winning move most of the time when available', () {
      final board = Board(
        size: 3,
        cells: [
          Player.o,
          Player.o,
          null,
          Player.x,
          null,
          null,
          null,
          null,
          null,
        ],
      );
      final bot = MediumBotStrategy();

      int winCount = 0;
      for (var i = 0; i < 50; i++) {
        final move = bot.selectMove(board, Player.o);
        if (move == 2) winCount++;
      }

      // Avec 15% random, on s'attend à ~85% de bons coups.
      // Seuil conservateur pour éviter le flaky :
      expect(winCount, greaterThanOrEqualTo(35)); // 70%
    });

    test('prefers center on empty 3x3 board most of the time', () {
      final board = Board(size: 3);
      final bot = MediumBotStrategy();

      int centerCount = 0;
      for (var i = 0; i < 100; i++) {
        if (bot.selectMove(board, Player.o) == 4) centerCount++;
      }

      // Attendu ~85, seuil safe
      expect(centerCount, greaterThanOrEqualTo(70));
    });
  });
}
