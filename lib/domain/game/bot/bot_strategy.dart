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
  @override
  int selectMove(Board board, Player botPlayer) {
    final validMoves = <int>[];
    for (int i = 0; i < board.cells.length; i++) {
      if (board.isEmptyAt(i)) {
        validMoves.add(i);
      }
    }

    validMoves.shuffle();
    return validMoves.first;
  }
}

/// Niveau Medium : tactiques de base avec random de 10%
class MediumBotStrategy implements BotStrategy {
  final Random _random = Random();

  @override
  int selectMove(Board board, Player botPlayer) {
    final opponent = botPlayer.opponent;

    // 10% de chance de jouer un coup random (erreur humaine)
    if (_random.nextInt(100) < 10) {
      return EasyBotStrategy().selectMove(board, botPlayer);
    }

    // 1. Gagner si possible
    final winMove = _findWinningMove(board, botPlayer);
    if (winMove != null) return winMove;

    // 2. Bloquer l'adversaire
    final blockMove = _findWinningMove(board, opponent);
    if (blockMove != null) return blockMove;

    // 3. Prendre le centre (3x3 uniquement)
    if (board.size == 3) {
      const center = 4; // index du centre en 3x3
      if (board.isEmptyAt(center)) return center;
    }

    // 4. Prendre un coin
    final corners = _getCorners(board);
    for (final corner in corners) {
      if (board.isEmptyAt(corner)) return corner;
    }

    // 5. N'importe quel coup valide
    return EasyBotStrategy().selectMove(board, botPlayer);
  }

  /// Trouve un coup gagnant pour le joueur donné
  int? _findWinningMove(Board board, Player player) {
    for (int i = 0; i < board.cells.length; i++) {
      if (!board.isEmptyAt(i)) continue;

      final testBoard = board.placeAt(i, player);
      final result = Rules.evaluate(testBoard);

      if (result is Win && result.winner == player) {
        return i;
      }
    }
    return null;
  }

  /// Retourne les indices des coins du plateau
  List<int> _getCorners(Board board) {
    final size = board.size;
    return [0, size - 1, size * (size - 1), size * size - 1];
  }
}

/// Niveau Hard : heuristiques avancées (fourchette, meilleure ligne) sans exploration exhaustive
class HardBotStrategy implements BotStrategy {
  @override
  int selectMove(Board board, Player botPlayer) {
    final opponent = botPlayer.opponent;

    // 1. Gagner immédiatement
    final winMove = _findWinningMove(board, botPlayer);
    if (winMove != null) return winMove;

    // 2. Bloquer l'adversaire
    final blockMove = _findWinningMove(board, opponent);
    if (blockMove != null) return blockMove;

    // 3. Créer une fourchette (2+ menaces)
    final forkMove = _findForkMove(board, botPlayer);
    if (forkMove != null) return forkMove;

    // 4. Bloquer une fourchette adverse
    final blockForkMove = _findForkMove(board, opponent);
    if (blockForkMove != null) return blockForkMove;

    // 5. Jouer sur la meilleure ligne
    final bestLineMove = _findBestLineMove(board, botPlayer);
    if (bestLineMove != null) return bestLineMove;

    // 6. Position stratégique
    final strategicMove = _findStrategicPosition(board);
    if (strategicMove != null) return strategicMove;

    // 7. Fallback
    return EasyBotStrategy().selectMove(board, botPlayer);
  }

  int? _findWinningMove(Board board, Player player) {
    for (int i = 0; i < board.cells.length; i++) {
      if (!board.isEmptyAt(i)) continue;
      final testBoard = board.placeAt(i, player);
      final result = Rules.evaluate(testBoard);
      if (result is Win && result.winner == player) return i;
    }
    return null;
  }

  int? _findForkMove(Board board, Player player) {
    for (int i = 0; i < board.cells.length; i++) {
      if (!board.isEmptyAt(i)) continue;

      final testBoard = board.placeAt(i, player);
      int threats = 0;

      // Compte les menaces créées
      for (int j = 0; j < board.cells.length; j++) {
        if (!testBoard.isEmptyAt(j)) continue;
        final testBoard2 = testBoard.placeAt(j, player);
        if (Rules.evaluate(testBoard2) is Win) {
          threats++;
          if (threats >= 2) return i; // Fourchette !
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
