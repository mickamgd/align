import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/game/game_config.dart';
import 'package:align/app/game/game_state.dart';
import 'package:align/app/history/history_controller.dart';
import 'package:align/app/online/online_game_controller.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/domain/game/bot/bot_strategy.dart';
import 'package:align/domain/game/game_history.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/domain/game/player_info.dart';
import 'package:align/domain/game/rules.dart';
import 'package:align/domain/profile/emoji_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final gameControllerProvider = NotifierProvider<GameController, GameState>(
  GameController.new,
);

final activeGameStateProvider = Provider<GameState>((ref) {
  final local = ref.watch(gameControllerProvider);
  final online = ref.watch(onlineGameControllerProvider);

  return online.config.mode == GameMode.online ? online : local;
});

class GameController extends Notifier<GameState> {
  DateTime? _gameStartTime;

  @override
  GameState build() {
    final playerXInfo = _createPlayerXInfo('X', 0);
    final playerOInfo = _createPlayerOInfo(
      GameConfig(size: 3, mode: GameMode.pve, difficulty: BotDifficulty.easy),
    );

    return GameState.initial(
      GameConfig(size: 3, mode: GameMode.pve, difficulty: BotDifficulty.easy),
      playerXInfo: playerXInfo,
      playerOInfo: playerOInfo,
    );
  }

  void startNewGame(GameConfig config) {
    final profileState = ref.read(profileControllerProvider);
    final playerXInfo = _createPlayerXInfo(
      profileState.profile?.displayName,
      profileState.profile?.emojiIndex,
    );
    final playerOInfo = _createPlayerOInfo(config);

    state = GameState.initial(
      config,
      playerXInfo: playerXInfo,
      playerOInfo: playerOInfo,
    );
    _gameStartTime = DateTime.now();
  }

  void restart() {
    final profileState = ref.read(profileControllerProvider);
    final playerXInfo = _createPlayerXInfo(
      profileState.profile?.displayName,
      profileState.profile?.emojiIndex,
    );
    final playerOInfo = _createPlayerOInfo(state.config);

    state = GameState.initial(
      state.config,
      playerXInfo: playerXInfo,
      playerOInfo: playerOInfo,
    );
    _gameStartTime = DateTime.now();
  }

  PlayerInfo _createPlayerXInfo(String? displayName, int? emojiIndex) =>
      PlayerInfo.local(
        displayName: displayName ?? 'Joueur',
        avatarEmoji: emojiCatalog[emojiIndex ?? 0],
      );

  PlayerInfo _createPlayerOInfo(GameConfig config) {
    if (config.mode == GameMode.pve) {
      final difficultyLabel = switch (config.difficulty) {
        BotDifficulty.easy => 'Facile',
        BotDifficulty.medium => 'Moyen',
        BotDifficulty.hard => 'Difficile',
      };
      return PlayerInfo.bot(difficulty: difficultyLabel);
    } else {
      return PlayerInfo.guest();
    }
  }

  Future<void> tapCell(int index) async {
    if (state.isGameOver) return;
    if (!state.board.isEmptyAt(index)) return;
    if (state.config.mode == GameMode.pve && state.currentPlayer != Player.x) {
      return;
    }

    _gameStartTime ??= DateTime.now();

    _playMove(index, state.currentPlayer);

    if (state.config.isBotEnabled &&
        !state.isGameOver &&
        state.currentPlayer == Player.o) {
      _playBotMove();
    }
  }

  void _playMove(int index, Player player) {
    final nextBoard = state.board.placeAt(index, player);
    final result = Rules.evaluate(nextBoard);
    final nextState = state.copyWith(board: nextBoard).applyResult(result);

    if (nextState.status == GameStatus.inProgress) {
      state = nextState.copyWith(currentPlayer: player.opponent);
    } else {
      state = nextState;
      _saveGameToHistory();
    }
  }

  void _playBotMove() {
    final strategy = _getBotStrategy(state.config.difficulty);
    final botMove = strategy.selectMove(state.board, Player.o);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!state.isGameOver && state.currentPlayer == Player.o) {
        _playMove(botMove, Player.o);
      }
    });
  }

  BotStrategy _getBotStrategy(BotDifficulty difficulty) => switch (difficulty) {
    BotDifficulty.easy => EasyBotStrategy(),
    BotDifficulty.medium => MediumBotStrategy(),
    BotDifficulty.hard => HardBotStrategy(),
  };

  Future<void> _saveGameToHistory() async {
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.uid;

    if (userId == null) return;

    final result = _determineGameResult();

    final history = GameHistory(
      id: const Uuid().v4(),
      playedAt: DateTime.now(),
      boardSize: state.config.size,
      gameMode: state.config.mode,
      difficulty: state.config.isBotEnabled ? state.config.difficulty : null,
      result: result,
      winner: state.winner,
      playerXName: state.playerXInfo.displayName,
      playerXEmoji: state.playerXInfo.avatarEmoji,
      playerOName: state.playerOInfo.displayName,
      playerOEmoji: state.playerOInfo.avatarEmoji,
      isPlayerOBot: state.playerOInfo.isBot,
      userId: userId,
    );

    try {
      await ref.read(historyControllerProvider).saveGame(history);
    } catch (e) {
      // En cas d'erreur, on ne bloque pas le jeu
      // On pourrait logger l'erreur ici
    }
  }

  GameHistoryResult _determineGameResult() {
    if (state.status == GameStatus.draw) {
      return GameHistoryResult.draw;
    }

    if (state.winner == Player.x) {
      return GameHistoryResult.win;
    } else {
      return GameHistoryResult.loss;
    }
  }
}
