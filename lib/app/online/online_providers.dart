import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/data/online/online_room_repository.dart';
import 'package:align/domain/online/online_room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlineRoomProvider = StreamProvider.family<OnlineRoom, String>(
  (ref, id) => ref.read(onlineRoomRepositoryProvider).watchRoom(id),
);

final onlineActionsProvider = Provider<OnlineActions>(OnlineActions.new);

class OnlineActions {
  OnlineActions(this._ref);
  final Ref _ref;

  RoomPlayer _me() {
    final auth = _ref.read(authControllerProvider);
    final profile = _ref.read(profileControllerProvider).profile;

    final uid = auth.user?.uid;
    if (uid == null) throw StateError('Not authenticated');
    if (profile == null) throw StateError('Profile missing');

    return RoomPlayer(
      uid: uid,
      displayName: profile.displayName,
      emojiIndex: profile.emojiIndex,
    );
  }

  String get myUid {
    final uid = _ref.read(authControllerProvider).user?.uid;
    if (uid == null) throw StateError('Not authenticated');
    return uid;
  }

  Future<String> createRoom(int size) =>
      _ref.read(onlineRoomRepositoryProvider).createRoom(size: size, me: _me());

  Future<String?> quickJoin(int size) =>
      _ref.read(onlineRoomRepositoryProvider).quickJoin(size: size, me: _me());

  Future<void> playMove(
    String roomId,
    int index, {
    required List<int> newBoard,
    required String nextTurn,
    required String? winner,
    required List<int> winningLine,
    required RoomStatus newStatus,
    required int moveCount,
  }) => _ref
      .read(onlineRoomRepositoryProvider)
      .playMove(
        roomId: roomId,
        index: index,
        newBoard: newBoard,
        nextTurn: nextTurn,
        winner: winner,
        winningLine: winningLine,
        newStatus: newStatus,
        moveCount: moveCount,
      );

  Future<void> leaveGame(String roomId) => _ref
      .read(onlineRoomRepositoryProvider)
      .leaveGame(roomId: roomId, uid: myUid);
}
