import 'package:align/app/game/game_config.dart';
import 'package:align/domain/game/board.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/domain/game/player_info.dart';
import 'package:align/domain/game/rules.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

enum GameStatus { inProgress, draw, won, abandoned }

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    required GameConfig config,
    required Board board,
    required Player currentPlayer,
    required GameStatus status,
    required PlayerInfo playerXInfo,
    required PlayerInfo playerOInfo,
    Player? winner,
    @Default(<int>[]) List<int> winningLine,
  }) = _GameState;

  const GameState._();

  factory GameState.initial(
    GameConfig config, {
    required PlayerInfo playerXInfo,
    required PlayerInfo playerOInfo,
  }) => GameState(
    config: config,
    board: Board(size: config.size),
    currentPlayer: Player.x,
    status: GameStatus.inProgress,
    winner: null,
    winningLine: const <int>[],
    playerXInfo: playerXInfo,
    playerOInfo: playerOInfo,
  );

  bool get isGameOver => status != GameStatus.inProgress;

  GameState applyResult(GameResult result) => switch (result) {
    InProgress() => copyWith(
      status: GameStatus.inProgress,
      winner: null,
      winningLine: const <int>[],
    ),
    Draw() => copyWith(
      status: GameStatus.draw,
      winner: null,
      winningLine: const <int>[],
    ),
    Win(:final winner, :final lineIndices) => copyWith(
      status: GameStatus.won,
      winner: winner,
      winningLine: lineIndices,
    ),
  };
}
