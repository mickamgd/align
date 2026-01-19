import 'package:align/app/game/game_config.dart';
import 'package:align/domain/game/player.dart';

class GameHistory {
  const GameHistory({
    required this.id,
    required this.playedAt,
    required this.boardSize,
    required this.gameMode,
    required this.difficulty,
    required this.result,
    required this.winner,
    required this.playerXName,
    required this.playerXEmoji,
    required this.playerOName,
    required this.playerOEmoji,
    required this.isPlayerOBot,
    required this.userId,
    this.isAbandonment = false,
  });

  final String id;
  final DateTime playedAt;
  final int boardSize;
  final GameMode gameMode;
  final BotDifficulty? difficulty;
  final GameHistoryResult result;
  final Player? winner;
  final String playerXName;
  final String playerXEmoji;
  final String playerOName;
  final String playerOEmoji;
  final bool isPlayerOBot;
  final String userId;
  final bool isAbandonment;

  Map<String, dynamic> toJson() => {
    'id': id,
    'playedAt': playedAt.toIso8601String(),
    'boardSize': boardSize,
    'gameMode': gameMode.name,
    'difficulty': difficulty?.name,
    'result': result.name,
    'winner': winner?.name,
    'playerXName': playerXName,
    'playerXEmoji': playerXEmoji,
    'playerOName': playerOName,
    'playerOEmoji': playerOEmoji,
    'isPlayerOBot': isPlayerOBot,
    'userId': userId,
    'isAbandonment': isAbandonment,
  };

  factory GameHistory.fromJson(Map<String, dynamic> json) {
    return GameHistory(
      id: json['id'],
      playedAt: DateTime.parse(json['playedAt']),
      boardSize: json['boardSize'],
      gameMode: GameMode.values.byName(json['gameMode']),
      difficulty: json['difficulty'] != null
          ? BotDifficulty.values.byName(json['difficulty'])
          : null,
      result: GameHistoryResult.values.byName(json['result']),
      winner: json['winner'] != null
          ? Player.values.byName(json['winner'])
          : null,
      playerXName: json['playerXName'],
      playerXEmoji: json['playerXEmoji'],
      playerOName: json['playerOName'],
      playerOEmoji: json['playerOEmoji'],
      isPlayerOBot: json['isPlayerOBot'],
      userId: json['userId'],
      isAbandonment: json['isAbandonment'] ?? false,
    );
  }

  bool get isWin => result == GameHistoryResult.win;
  bool get isLoss => result == GameHistoryResult.loss;
  bool get isDraw => result == GameHistoryResult.draw;

  String get resultLabel {
    if (isAbandonment) {
      return switch (result) {
        GameHistoryResult.win => 'Victoire par abandon',
        GameHistoryResult.loss => 'Défaite par abandon',
        GameHistoryResult.draw => 'Match nul',
      };
    }
    return switch (result) {
      GameHistoryResult.win => 'Victoire',
      GameHistoryResult.loss => 'Défaite',
      GameHistoryResult.draw => 'Match nul',
    };
  }

  String get opponentLabel {
    if (isPlayerOBot) {
      final diff = switch (difficulty) {
        BotDifficulty.easy => 'Facile',
        BotDifficulty.medium => 'Moyen',
        BotDifficulty.hard => 'Difficile',
        null => 'Bot',
      };
      return 'Bot ($diff)';
    }
    return playerOName;
  }
}

enum GameHistoryResult { win, loss, draw }
