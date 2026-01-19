import 'package:align/domain/game/board.dart';
import 'package:align/domain/game/player.dart';

enum RoomStatus { waiting, playing, finished }

class RoomPlayer {
  const RoomPlayer({
    required this.uid,
    required this.displayName,
    required this.emojiIndex,
  });

  final String uid;
  final String displayName;
  final int emojiIndex;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'emojiIndex': emojiIndex,
  };

  factory RoomPlayer.fromJson(Map<String, dynamic> json) => RoomPlayer(
    uid: json['uid'] as String,
    displayName: json['displayName'] as String,
    emojiIndex: json['emojiIndex'] as int,
  );
}

class OnlineRoom {
  const OnlineRoom({
    required this.id,
    required this.size,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.playerX,
    required this.playerO,
    required this.boardInts,
    required this.currentTurn,
    required this.winner,
    required this.winningLine,
    required this.moveCount,
  });

  final String id;
  final int size;
  final RoomStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final RoomPlayer playerX;
  final RoomPlayer? playerO;

  /// 0 empty, 1 X, 2 O
  final List<int> boardInts;

  /// "x" or "o"
  final String currentTurn;

  /// "x" or "o" or null
  final String? winner;

  final List<int> winningLine;
  final int moveCount;

  bool get isFull => playerO != null;

  Player get currentTurnPlayer {
    return Player.values.byName(currentTurn);
  }

  Player? get winnerPlayer {
    if (winner == null) return null;
    return Player.values.byName(winner!);
  }

  Player? playerForUid(String uid) {
    if (playerX.uid == uid) return Player.x;
    if (playerO?.uid == uid) return Player.o;
    return null;
  }

  Board toBoard() {
    final cells = boardInts
        .map<Player?>(
          (v) => switch (v) {
            0 => null,
            1 => Player.x,
            2 => Player.o,
            _ => null,
          },
        )
        .toList(growable: false);

    return Board(size: size, cells: cells);
  }

  factory OnlineRoom.fromJson(String id, Map<String, dynamic> json) {
    return OnlineRoom(
      id: id,
      size: json['size'] as int,
      status: RoomStatus.values.byName(json['status'] as String),
      createdAt: (json['createdAt'] as dynamic).toDate() as DateTime,
      updatedAt: (json['updatedAt'] as dynamic).toDate() as DateTime,
      playerX: RoomPlayer.fromJson(
        Map<String, dynamic>.from(json['playerX'] as Map),
      ),
      playerO: json['playerO'] == null
          ? null
          : RoomPlayer.fromJson(
              Map<String, dynamic>.from(json['playerO'] as Map),
            ),
      boardInts: List<int>.from(json['board'] as List),
      currentTurn: json['currentTurn'] as String,
      winner: json['winner'] as String?,
      winningLine: json['winningLine'] != null
          ? List<int>.from(json['winningLine'] as List)
          : const <int>[],
      moveCount: (json['moveCount'] as int?) ?? 0,
    );
  }
}
