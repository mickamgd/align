import 'package:align/domain/game/game_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryRepository {
  HistoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _historyCollection() {
    return _firestore.collection('game_history');
  }

  /// Sauvegarde une partie terminée dans l'historique
  Future<void> saveGame(GameHistory history) async {
    await _historyCollection().doc(history.id).set(history.toJson());
  }

  /// Récupère l'historique des parties d'un utilisateur
  Future<List<GameHistory>> getUserHistory(String? userId) async {
    final snapshot = await _historyCollection()
        .where('userId', isEqualTo: userId)
        .orderBy('playedAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => GameHistory.fromJson(doc.data()))
        .toList();
  }

  /// Écoute les changements de l'historique en temps réel
  Stream<List<GameHistory>> watchUserHistory(String? userId) {
    if (userId == null) return Stream.value([]);

    return _historyCollection()
        .where('userId', isEqualTo: userId)
        .orderBy('playedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameHistory.fromJson(doc.data()))
            .toList());
  }

  /// Supprime une partie de l'historique
  Future<void> deleteGame(String gameId) async {
    await _historyCollection().doc(gameId).delete();
  }
}
