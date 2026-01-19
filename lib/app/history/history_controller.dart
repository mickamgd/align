import 'package:align/app/auth/auth_controller.dart';
import 'package:align/core/logger.dart';
import 'package:align/data/game/history_repository.dart';
import 'package:align/domain/game/game_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider du repository d'historique
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(FirebaseFirestore.instance);
});

/// Récupère l'historique du user courant en temps réel
final userHistoryProvider = StreamProvider.autoDispose<List<GameHistory>>((ref) {
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.uid;
  final repository = ref.watch(historyRepositoryProvider);
  return repository.watchUserHistory(userId);
});

/// Controller pour gérer l'historique
final historyControllerProvider = Provider<HistoryController>((ref) {
  return HistoryController(ref);
});

class HistoryController {
  HistoryController(this._ref);

  final Ref _ref;

  HistoryRepository get _repository => _ref.read(historyRepositoryProvider);

  /// Sauvegarde une partie dans l'historique
  Future<void> saveGame(GameHistory history) async {
    try {
      await _repository.saveGame(history);
      AppLogger.info('Game saved to history', history.id);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save game to history', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Supprime une partie de l'historique
  Future<void> deleteGame(String gameId) async {
    try {
      await _repository.deleteGame(gameId);
      AppLogger.info('Game deleted from history', gameId);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete game from history', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
