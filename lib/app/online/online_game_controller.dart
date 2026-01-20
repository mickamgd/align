import 'dart:async';

import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/game/game_config.dart';
import 'package:align/app/game/game_controller.dart';
import 'package:align/app/game/game_state.dart';
import 'package:align/app/history/history_controller.dart';
import 'package:align/app/online/online_providers.dart';
import 'package:align/core/logger.dart';
import 'package:align/data/online/online_room_repository.dart';
import 'package:align/domain/game/game_history.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/domain/game/player_info.dart';
import 'package:align/domain/game/rules.dart';
import 'package:align/domain/online/online_room.dart';
import 'package:align/domain/profile/emoji_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final onlineGameControllerProvider =
    NotifierProvider<OnlineGameController, GameState>(OnlineGameController.new);

class OnlineGameController extends GameController {
  String? _currentRoomId;
  StreamSubscription<OnlineRoom>? _roomSubscription;
  bool _pendingCleanupAfterGameOver = false;

  @override
  GameState build() {
    // Cleanup on dispose
    ref.onDispose(cleanup);

    // Initial state - will be overridden when joining/creating a room
    return super.build();
  }

  Future<String> createRoom(int size) async {
    try {
      final actions = ref.read(onlineActionsProvider);

      final roomId = await actions.createRoom(size);
      _currentRoomId = roomId;

      await _watchRoom(roomId);

      AppLogger.info('Room created successfully', roomId);
      return roomId;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to create room',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<String?> quickJoin(int size) async {
    try {
      final actions = ref.read(onlineActionsProvider);

      final roomId = await actions.quickJoin(size);

      if (roomId != null) {
        _currentRoomId = roomId;
        await _watchRoom(roomId);
        AppLogger.info('Quick join successful', roomId);
      } else {
        AppLogger.info('No available room found for quick join');
      }

      return roomId;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to quick join',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _watchRoom(String roomId) async {
    await _roomSubscription?.cancel();

    final repository = ref.read(onlineRoomRepositoryProvider);
    int errorCount = 0;
    const maxErrors = 5;

    _roomSubscription = repository
        .watchRoom(roomId)
        .listen(
          (room) async {
            errorCount = 0;
            await _syncFromRoom(room);
          },
          onError: (error) {
            errorCount++;
            if (errorCount >= maxErrors) {
              cleanup(); // Stop listening after 5 errors
            }
          },
          cancelOnError: false,
        );
  }

  Future<void> _syncFromRoom(OnlineRoom room) async {
    final myUid = ref.read(authControllerProvider).user?.uid;
    if (myUid == null) {
      return;
    }

    final myPlayer = room.playerForUid(myUid);
    if (myPlayer == null) {
      return;
    }

    final playerXInfo = PlayerInfo.online(
      displayName: room.playerX.displayName,
      avatarEmoji: emojiCatalog[room.playerX.emojiIndex],
      player: Player.x,
      uid: room.playerX.uid,
    );

    final playerOInfo = room.playerO != null
        ? PlayerInfo.online(
            displayName: room.playerO!.displayName,
            avatarEmoji: emojiCatalog[room.playerO!.emojiIndex],
            player: Player.o,
            uid: room.playerO!.uid,
          )
        : PlayerInfo.guest();

    final board = room.toBoard();

    final config = GameConfig(
      size: room.size,
      mode: GameMode.online,
      difficulty: BotDifficulty.easy, // Not used for online
    );

    final isAbandonment =
        room.status == RoomStatus.finished &&
        room.winnerPlayer != null &&
        room.winningLine.isEmpty;

    final base = GameState(
      config: config,
      board: board,
      currentPlayer: room.currentTurnPlayer,
      status: _statusFromRoom(room.status, room.winnerPlayer),
      winner: room.winnerPlayer,
      winningLine: room.winningLine,
      playerXInfo: playerXInfo,
      playerOInfo: playerOInfo,
    );

    final newState = isAbandonment
        ? base.copyWith(status: GameStatus.abandoned)
        : base.applyResult(Rules.evaluate(board));

    // Save to history if game just ended
    final wasInProgress = state.status == GameStatus.inProgress;
    final isNowOver = newState.isGameOver;
    if (wasInProgress && isNowOver) {
      await _saveOnlineGameToHistory(newState, myUid);

      if (_pendingCleanupAfterGameOver) {
        _pendingCleanupAfterGameOver = false;
        await cleanup();
      }
    }

    state = newState;
  }

  Future<void> _saveOnlineGameToHistory(
    GameState gameState,
    String myUid,
  ) async {
    try {
      final userId = ref.read(authControllerProvider).user?.uid;
      if (userId == null) return;

      // Determine result from my perspective
      GameHistoryResult result;
      if (gameState.status == GameStatus.draw) {
        result = GameHistoryResult.draw;
      } else if (gameState.status == GameStatus.abandoned ||
          gameState.status == GameStatus.won) {
        // Check if I won
        final iWon =
            (gameState.winner == Player.x &&
                gameState.playerXInfo.uid == myUid) ||
            (gameState.winner == Player.o &&
                gameState.playerOInfo.uid == myUid);
        result = iWon ? GameHistoryResult.win : GameHistoryResult.loss;
      } else {
        result = GameHistoryResult.draw;
      }

      final history = GameHistory(
        id: const Uuid().v4(),
        playedAt: DateTime.now(),
        boardSize: gameState.config.size,
        gameMode: gameState.config.mode,
        difficulty: null, // No difficulty for online
        result: result,
        winner: gameState.winner,
        playerXName: gameState.playerXInfo.displayName,
        playerXEmoji: gameState.playerXInfo.avatarEmoji,
        playerOName: gameState.playerOInfo.displayName,
        playerOEmoji: gameState.playerOInfo.avatarEmoji,
        isPlayerOBot: false, // Never bot in online
        userId: userId,
        isAbandonment: gameState.status == GameStatus.abandoned,
      );

      await ref.read(historyControllerProvider).saveGame(history);
    } catch (e) {
      // Don't block game on history save error
    }
  }

  GameStatus _statusFromRoom(RoomStatus status, Player? winner) =>
      switch (status) {
        RoomStatus.waiting => GameStatus.inProgress,
        RoomStatus.playing => GameStatus.inProgress,
        RoomStatus.finished =>
          winner != null ? GameStatus.won : GameStatus.draw,
      };

  @override
  Future<void> tapCell(int index) async {
    if (state.isGameOver || _currentRoomId == null) return;

    if (!state.board.isEmptyAt(index)) return;

    final myUid = ref.read(authControllerProvider).user?.uid;
    if (myUid == null) return;

    Player? myPlayer;
    if (state.playerXInfo.uid == myUid) {
      myPlayer = Player.x;
    } else if (state.playerOInfo.uid == myUid) {
      myPlayer = Player.o;
    } else {
      return;
    }

    if (myPlayer != state.currentPlayer) return;

    try {
      final nextBoard = state.board.placeAt(index, myPlayer);
      final result = Rules.evaluate(nextBoard);

      final newBoardInts = nextBoard.cells.map((cell) {
        if (cell == null) return 0;
        if (cell == Player.x) return 1;
        if (cell == Player.o) return 2;
        return 0;
      }).toList();

      String? winner;
      List<int> winningLine = [];
      RoomStatus newStatus = RoomStatus.playing;
      final String nextTurn = myPlayer.opponent.name;

      if (result is Win) {
        winner = result.winner.name;
        winningLine = result.lineIndices;
        newStatus = RoomStatus.finished;
      } else if (result is Draw) {
        newStatus = RoomStatus.finished;
      }

      await ref
          .read(onlineActionsProvider)
          .playMove(
            _currentRoomId!,
            index,
            newBoard: newBoardInts,
            nextTurn: nextTurn,
            winner: winner,
            winningLine: winningLine,
            newStatus: newStatus,
            moveCount: state.board.cells.where((c) => c != null).length + 1,
          );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to play move',
        error: error,
        stackTrace: stackTrace,
      );
      // Don't rethrow - just log the error silently
    }
  }

  /// Leave current online game - opponent wins
  Future<void> leaveGame() async {
    if (_currentRoomId == null) {
      return;
    }

    try {
      _pendingCleanupAfterGameOver = true;
      await ref.read(onlineActionsProvider).leaveGame(_currentRoomId!);

      AppLogger.info('Left game successfully', _currentRoomId);
    } catch (error, stackTrace) {
      _pendingCleanupAfterGameOver = false;
      AppLogger.error(
        'Failed to leave game',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> cleanup() async {
    _pendingCleanupAfterGameOver = false;

    final sub = _roomSubscription;
    _roomSubscription = null;
    _currentRoomId = null;

    await sub?.cancel();
  }

  /// Reset to initial state (call when switching to local game)
  Future<void> reset() async {
    await cleanup();
    state = super.build();
  }
}
