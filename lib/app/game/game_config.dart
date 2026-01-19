enum GameMode { pvp, pve, online }

enum BotDifficulty { easy, medium, hard }

class GameConfig {
  GameConfig({
    required this.size,
    required this.mode,
    required this.difficulty,
  });

  final int size;
  final GameMode mode;
  final BotDifficulty difficulty;

  bool get isBotEnabled => mode == GameMode.pve;
}
