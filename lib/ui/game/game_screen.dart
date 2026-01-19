import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/game/game_config.dart';
import 'package:align/app/game/game_controller.dart';
import 'package:align/app/game/game_state.dart';
import 'package:align/app/online/online_game_controller.dart';
import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/core/ui_helpers.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/ui/game/widgets/game_cell.dart';
import 'package:align/ui/game/widgets/game_status_display.dart';
import 'package:align/ui/game/widgets/game_type_chip.dart';
import 'package:align/ui/shared/back_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late ConfettiController _confettiController;
  late final ProviderSubscription<GameState> _activeGameStateSub;

  bool _didIWinOnline(GameState s, String myUid) =>
      (s.winner == Player.x && s.playerXInfo.uid == myUid) ||
      (s.winner == Player.o && s.playerOInfo.uid == myUid);

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: AppDurations.verySlow);

    _activeGameStateSub = ref.listenManual<GameState>(activeGameStateProvider, (
      previous,
      next,
    ) {
      final isOnline = next.config.mode == GameMode.online;

      final transitionedToWin =
          previous?.status != GameStatus.won && next.status == GameStatus.won;

      final transitionedToAbandoned =
          previous?.status != GameStatus.abandoned &&
          next.status == GameStatus.abandoned;

      if (!transitionedToWin && !transitionedToAbandoned) return;

      if (isOnline) {
        final myUid = ref.read(authControllerProvider).user?.uid;
        if (myUid != null && _didIWinOnline(next, myUid)) {
          _confettiController.play();

          if (next.status == GameStatus.abandoned) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vous avez gagné par abandon !'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        if (next.winner == Player.x) {
          _confettiController.play();
        }
      }
    });
  }

  @override
  void dispose() {
    _activeGameStateSub.close();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeGameStateProvider);
    final isOnline = state.config.mode == GameMode.online;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, state, isOnline),

                  const Spacer(flex: 1),

                  // Status
                  GameStatusDisplay(
                    state: state,
                    myUid: isOnline
                        ? ref.read(authControllerProvider).user?.uid
                        : null,
                  ).animate().fadeIn(delay: 200.ms).scale(delay: 300.ms),

                  AppSpacing.verticalXXL,

                  // Game Board
                  AspectRatio(aspectRatio: 1, child: _buildBoard(state))
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(
                        delay: 500.ms,
                        duration: AppDurations.slow,
                        curve: Curves.easeOutBack,
                      ),

                  const Spacer(flex: 1),

                  // Actions
                  _buildActions(context, state),

                  AppSpacing.verticalSM,
                ],
              ),
            ),

            // Confetti overlay
            _buildConfetti(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GameState state,
    bool isOnline,
  ) => Row(
    children: [
      BackButtonAlign(
        onPressed: () async {
          if (isOnline) {
            try {
              await ref.read(onlineGameControllerProvider.notifier).leaveGame();
            } catch (e) {
              if (context.mounted) {
                UiHelpers.showError(context, 'Impossible de quitter la partie');
              }
            }
          }
          if (context.mounted) {
            context.go(Routes.home);
          }
        },
      ).animate().fadeIn().scale(delay: 100.ms),

      const Spacer(),

      GameTypeChip(
        isPve: state.config.mode == GameMode.pve,
        size: state.board.size,
      ).animate().fadeIn(delay: 200.ms),
    ],
  );

  Widget _buildBoard(GameState state) {
    final isOnline = state.config.mode == GameMode.online;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: state.board.size,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemCount: state.board.size * state.board.size,
      itemBuilder: (context, index) {
        final player = state.board.cells[index];
        final isWinningCell = state.winningLine.contains(index);
        final isCellDisabled = state.isGameOver || player != null;

        return GameCell(
          player: player,
          isWinningCell: isWinningCell,
          isDisabled: isCellDisabled,
          onTap: () {
            if (isOnline) {
              ref.read(onlineGameControllerProvider.notifier).tapCell(index);
            } else {
              ref.read(gameControllerProvider.notifier).tapCell(index);
            }
          },
        );
      },
    );
  }

  Widget _buildActions(BuildContext context, GameState currentState) {
    final isOnline = currentState.config.mode == GameMode.online;
    final state = isOnline
        ? ref.watch(onlineGameControllerProvider)
        : ref.watch(gameControllerProvider);

    return Row(
      children: [
        // Restart (disabled in online mode)
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: isOnline
                  ? null
                  : () => ref.read(gameControllerProvider.notifier).restart(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'Recommencer',
                style: GoogleFonts.poppins(fontWeight: AppFontWeight.bold),
              ),
            ),
          ),
        ),

        AppSpacing.horizontalMD,

        // Home / Resign / Leave
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (isOnline) {
                  try {
                    await ref
                        .read(onlineGameControllerProvider.notifier)
                        .leaveGame();
                  } catch (e) {
                    if (context.mounted) {
                      UiHelpers.showError(
                        context,
                        'Impossible de quitter la partie',
                      );
                    }
                  }
                }
                if (context.mounted) {
                  context.go(Routes.home);
                }
              },
              icon: Icon(
                isOnline && !state.isGameOver
                    ? Icons.flag_rounded
                    : Icons.home_rounded,
              ),
              label: Text(
                'Menu',
                style: GoogleFonts.poppins(fontWeight: AppFontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildConfetti() => Align(
    alignment: Alignment.topCenter,
    child: ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      particleDrag: 0.05,
      emissionFrequency: 0.05,
      numberOfParticles: 30,
      gravity: 0.2,
      colors: const [
        AppColors.yellow,
        AppColors.pink,
        AppColors.purple,
        AppColors.greenLight,
        AppColors.orange,
      ],
    ),
  );
}
