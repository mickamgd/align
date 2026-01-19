import 'package:align/app/game/game_config.dart';
import 'package:align/app/game/game_state.dart';
import 'package:align/app/online/online_game_controller.dart';
import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/core/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnlineLobbyScreen extends ConsumerStatefulWidget {
  const OnlineLobbyScreen({required this.selectedSize, super.key});

  final int selectedSize;

  @override
  ConsumerState<OnlineLobbyScreen> createState() => _OnlineLobbyScreenState();
}

class _OnlineLobbyScreenState extends ConsumerState<OnlineLobbyScreen> {
  bool _isWaitingForOpponent = false;
  late final ProviderSubscription<GameState> _onlineSub;

  @override
  void initState() {
    super.initState();
    _onlineSub = ref.listenManual<GameState>(onlineGameControllerProvider, (
      previous,
      next,
    ) {
      if (!_isWaitingForOpponent) return;

      final opponentJoined =
          next.config.mode == GameMode.online &&
          next.status == GameStatus.inProgress &&
          next.playerOInfo.displayName != 'Invité';

      final wasNotJoinedBefore =
          previous == null ||
          previous.playerOInfo.displayName == 'Invité' ||
          previous.status != GameStatus.inProgress;

      if (opponentJoined && wasNotJoinedBefore) {
        if (!mounted) return;
        context.go('${Routes.home}/${Routes.game}');
      }
    });
    _startMatchmaking();
  }

  Future<void> _startMatchmaking() async {
    try {
      final controller = ref.read(onlineGameControllerProvider.notifier);

      final roomId = await controller.quickJoin(widget.selectedSize);

      if (roomId != null && mounted) {
        context.go('${Routes.home}/${Routes.game}');
      } else {
        await controller.createRoom(widget.selectedSize);
        if (mounted) {
          setState(() {
            _isWaitingForOpponent = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        UiHelpers.showError(context, 'Impossible de rejoindre une partie');
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _onlineSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partie en ligne'),
        backgroundColor: AppColors.background,
      ),
      body: Center(child: _buildMatchmaking()),
    );
  }

  Widget _buildMatchmaking() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
      ),
      AppSpacing.verticalXXL,
      Text(
        _isWaitingForOpponent
            ? 'En attente d\'un adversaire...'
            : 'Recherche d\'adversaire...',
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
      AppSpacing.verticalMD,
      Text(
        'Le matchmaking se fait automatiquement',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      AppSpacing.verticalXXXL,
      TextButton(
        onPressed: () {
          if (_isWaitingForOpponent) {
            ref.read(onlineGameControllerProvider.notifier).leaveGame();
          }
          context.pop();
        },
        child: const Text(
          'Annuler',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}
