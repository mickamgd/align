import 'package:align/domain/game/player.dart';

/// Informations d'affichage d'un joueur dans une partie
class PlayerInfo {
  const PlayerInfo({
    required this.player,
    required this.displayName,
    required this.avatarEmoji,
    required this.isBot,
    this.botDifficulty,
    this.uid,
  });

  final Player player;
  final String displayName;
  final String avatarEmoji;
  final bool isBot;
  final String? botDifficulty;
  final String? uid; // UID Firebase pour les parties en ligne

  factory PlayerInfo.local({
    required String displayName,
    required String avatarEmoji,
  }) {
    return PlayerInfo(
      player: Player.x,
      displayName: displayName,
      avatarEmoji: avatarEmoji,
      isBot: false,
    );
  }

  factory PlayerInfo.bot({required String difficulty}) {
    return PlayerInfo(
      player: Player.o,
      displayName: 'Bot',
      avatarEmoji: '🤖',
      isBot: true,
      botDifficulty: difficulty,
    );
  }

  factory PlayerInfo.guest() {
    return const PlayerInfo(
      player: Player.o,
      displayName: 'Invité',
      avatarEmoji: '👤',
      isBot: false,
    );
  }

  factory PlayerInfo.online({
    required String displayName,
    required String avatarEmoji,
    required Player player,
    required String uid,
  }) {
    return PlayerInfo(
      player: player,
      displayName: displayName,
      avatarEmoji: avatarEmoji,
      isBot: false,
      uid: uid,
    );
  }

  String get subtitle {
    if (isBot && botDifficulty != null) {
      return botDifficulty!;
    }
    return '';
  }
}
