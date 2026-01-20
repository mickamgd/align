import 'dart:math' show Random;

import 'package:align/domain/game/board.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/domain/game/rules.dart';

/// Interface pour les stratégies de bot - Strategy Pattern
abstract class BotStrategy {
  int selectMove(Board board, Player botPlayer);
}

/// Niveau Easy : coup aléatoire valide
class EasyBotStrategy implements BotStrategy {
  final Random _random = Random();

  @override
  int selectMove(Board board, Player botPlayer) {
    return _BotUtils.randomMove(board, random: _random);
  }
}

/// Niveau Medium : tactiques de base avec random de 10%
class MediumBotStrategy implements BotStrategy {
  final Random _random = Random();

  @override
  int selectMove(Board board, Player botPlayer) {
    final opponent = botPlayer.opponent;

    if (_random.nextInt(100) < 15) {
      return _BotUtils.randomMove(board, random: _random);
    }

    final win = _BotUtils.winningMove(board, botPlayer);
    if (win != null) return win;

    final block = _BotUtils.winningMove(board, opponent);
    if (block != null) return block;

    if (board.size == 3 && board.isEmptyAt(4)) return 4;

    final corners = _BotUtils.corners(board)..shuffle(_random);
    for (final c in corners) {
      if (board.isEmptyAt(c)) return c;
    }

    return _BotUtils.randomMove(board, random: _random);
  }
}

/// Niveau Hard : heuristiques avancées (fourchette, meilleure ligne) sans exploration exhaustive
class HardBotStrategy implements BotStrategy {
  @override
  int selectMove(Board board, Player botPlayer) {
    final opponent = botPlayer.opponent;

    // 1. Gagner immédiatement
    final winMove = _BotUtils.winningMove(board, botPlayer);
    if (winMove != null) return winMove;

    // 2. Bloquer l'adversaire
    final blockMove = _BotUtils.winningMove(board, opponent);
    if (blockMove != null) return blockMove;

    // 3. Prendre le centre
    if (board.size == 3 && board.isEmptyAt(4)) {
      return 4;
    }

    // 4. Créer une fourchette (2+ menaces)
    final forkMove = board.size == 3 ? _findForkMove(board, botPlayer) : null;
    if (forkMove != null) return forkMove;

    // 5. Bloquer une fourchette adverse
    final blockForkMove = board.size == 3
        ? _findForkMove(board, opponent)
        : null;
    if (blockForkMove != null) return blockForkMove;

    // 6. Jouer sur la meilleure ligne
    final bestLineMove = _findBestLineMove(board, botPlayer);
    if (bestLineMove != null) return bestLineMove;

    // 7. Position stratégique
    final strategicMove = _findStrategicPosition(board);
    if (strategicMove != null) return strategicMove;

    // 8. Fallback
    return _BotUtils.randomMove(board);
  }

  int? _findForkMove(Board board, Player player) {
    for (final i in _BotUtils.validMoves(board)) {
      final afterFirst = board.placeAt(i, player);
      var threats = 0;

      for (final j in _BotUtils.validMoves(afterFirst)) {
        final res = Rules.evaluate(afterFirst.placeAt(j, player));
        if (res is Win && res.winner == player) {
          threats++;
          if (threats >= 2) return i;
        }
      }
    }
    return null;
  }

  int? _findBestLineMove(Board board, Player player) {
    final lines = _getAllLines(board);
    int bestMove = -1;
    int bestScore = -1;

    for (final line in lines) {
      final myCount = line.where((i) => board.cells[i] == player).length;
      final opponentCount = line
          .where((i) => board.cells[i] == player.opponent)
          .length;

      // Ligne exploitable (pas d'adversaire)
      if (opponentCount == 0 && myCount > 0) {
        final score = myCount * myCount; // Préfère les lignes avancées

        for (final pos in line) {
          if (board.isEmptyAt(pos)) {
            if (score > bestScore) {
              bestScore = score;
              bestMove = pos;
            }
            break;
          }
        }
      }
    }

    return bestMove != -1 ? bestMove : null;
  }

  int? _findStrategicPosition(Board board) {
    final size = board.size;
    final positions = <int>[];

    // Centre
    final center = (size * size) ~/ 2;
    if (board.isEmptyAt(center)) positions.add(center);

    // Coins
    positions.addAll([0, size - 1, size * (size - 1), size * size - 1]);

    // Cases adjacentes au centre (4x4+)
    if (size >= 4) {
      final mid = size ~/ 2;
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;
          final r = mid + dr;
          final c = mid + dc;
          if (r >= 0 && r < size && c >= 0 && c < size) {
            positions.add(r * size + c);
          }
        }
      }
    }

    positions.shuffle();
    for (final pos in positions) {
      if (board.isEmptyAt(pos)) return pos;
    }

    return null;
  }

  List<List<int>> _getAllLines(Board board) {
    final lines = <List<int>>[];
    final size = board.size;

    // Lignes
    for (int r = 0; r < size; r++) {
      lines.add(List.generate(size, (c) => r * size + c));
    }

    // Colonnes
    for (int c = 0; c < size; c++) {
      lines.add(List.generate(size, (r) => r * size + c));
    }

    // Diagonales
    lines.add(List.generate(size, (i) => i * size + i));
    lines.add(List.generate(size, (i) => i * size + (size - 1 - i)));

    return lines;
  }
}

class _BotUtils {
  static List<int> validMoves(Board board) {
    final moves = <int>[];
    for (int i = 0; i < board.cells.length; i++) {
      if (board.isEmptyAt(i)) moves.add(i);
    }
    return moves;
  }

  static int? winningMove(Board board, Player player) {
    for (final i in validMoves(board)) {
      final res = Rules.evaluate(board.placeAt(i, player));
      if (res is Win && res.winner == player) return i;
    }
    return null;
  }

  static List<int> corners(Board board) {
    final s = board.size;
    return [0, s - 1, s * (s - 1), s * s - 1];
  }

  static int randomMove(Board board, {Random? random}) {
    final moves = validMoves(board);
    if (moves.isEmpty) return 0; // ne devrait jamais arriver si game over géré
    moves.shuffle(random);
    return moves.first;
  }
}
