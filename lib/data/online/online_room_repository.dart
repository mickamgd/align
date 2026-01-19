import 'package:align/domain/game/player.dart';
import 'package:align/domain/online/online_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlineRoomRepositoryProvider = Provider<OnlineRoomRepository>((ref) {
  return OnlineRoomRepository(FirebaseFirestore.instance);
});

class OnlineRoomRepository {
  OnlineRoomRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('rooms');

  Stream<OnlineRoom> watchRoom(String roomId) {
    return _rooms.doc(roomId).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) {
        throw StateError('Room not found: $roomId');
      }
      return OnlineRoom.fromJson(snap.id, data);
    });
  }

  Future<OnlineRoom?> getRoom(String roomId) async {
    final snap = await _rooms.doc(roomId).get();
    final data = snap.data();
    if (data == null) return null;
    return OnlineRoom.fromJson(snap.id, data);
  }

  Future<String> createRoom({required int size, required RoomPlayer me}) async {
    final ref = _rooms.doc();

    final now = Timestamp.now();
    final board = List<int>.filled(size * size, 0);

    await ref.set({
      'size': size,
      'status': RoomStatus.waiting.name,
      'createdAt': now,
      'updatedAt': now,
      'playerX': me.toJson(),
      'playerO': null,
      'board': board,
      'currentTurn': Player.x.name,
      'winner': null,
      'winningLine': <int>[],
      'moveCount': 0,
    });

    return ref.id;
  }

  Future<void> joinRoom({
    required String roomId,
    required RoomPlayer me,
  }) async {
    final docRef = _rooms.doc(roomId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data();
      if (data == null) throw StateError('Room not found');

      final status = data['status'] as String;
      if (status != RoomStatus.waiting.name) {
        throw StateError('Room not joinable (status=$status)');
      }

      final playerX = Map<String, dynamic>.from(data['playerX'] as Map);
      if (playerX['uid'] == me.uid) {
        throw StateError('You are already in this room');
      }

      final existingO = data['playerO'];
      if (existingO != null) {
        throw StateError('Room already full');
      }

      tx.update(docRef, {
        'playerO': me.toJson(),
        'status': RoomStatus.playing.name,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  Future<String?> quickJoin({required int size, required RoomPlayer me}) async {
    final snap = await _rooms
        .where('status', isEqualTo: RoomStatus.waiting.name)
        .limit(20)
        .get();

    for (final doc in snap.docs) {
      final data = doc.data();
      final roomSize = data['size'] as int;
      if (roomSize != size) continue;

      try {
        await joinRoom(roomId: doc.id, me: me);
        return doc.id;
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  Future<void> playMove({
    required String roomId,
    required int index,
    required List<int> newBoard,
    required String nextTurn,
    required String? winner,
    required List<int> winningLine,
    required RoomStatus newStatus,
    required int moveCount,
  }) async {
    final docRef = _rooms.doc(roomId);

    await docRef.update({
      'board': newBoard,
      'currentTurn': nextTurn,
      'winner': winner,
      'winningLine': winningLine,
      'status': newStatus.name,
      'moveCount': moveCount,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Leave game - opponent wins if present, otherwise delete room
  Future<void> leaveGame({required String roomId, required String uid}) async {
    final docRef = _rooms.doc(roomId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data();
      if (data == null) {
        return;
      }

      final status = data['status'] as String;

      // Parse player data
      final playerXData = Map<String, dynamic>.from(data['playerX'] as Map);
      final playerXUid = playerXData['uid'] as String;

      final playerOData = data['playerO'] as Map?;
      final String? playerOUid = playerOData != null
          ? (Map<String, dynamic>.from(playerOData)['uid'] as String)
          : null;

      // Case 1: Room is waiting (no opponent yet) - just delete it
      if (playerOUid == null && status == RoomStatus.waiting.name) {
        tx.delete(docRef);
        return;
      }

      // Case 2: Game already finished - nothing to do
      if (status == RoomStatus.finished.name) {
        return;
      }

      // Case 3: Both players present - determine winner
      if (playerOUid != null) {
        // Check who is leaving
        final bool isLeavingPlayerX = playerXUid == uid;
        final bool isLeavingPlayerO = playerOUid == uid;

        // Verify the leaving player is actually in the room
        if (!isLeavingPlayerX && !isLeavingPlayerO) {
          return;
        }

        // The winner is the opponent of whoever is leaving
        final String winnerName;
        if (isLeavingPlayerX) {
          winnerName = Player.o.name; // Player X leaves, Player O wins
        } else {
          winnerName = Player.x.name; // Player O leaves, Player X wins
        }

        tx.update(docRef, {
          'status': RoomStatus.finished.name,
          'winner': winnerName,
          'updatedAt': Timestamp.now(),
        });
      }
    });
  }
}
