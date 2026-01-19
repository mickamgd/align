import 'package:align/app/game/game_state.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/game/player.dart';
import 'package:align/ui/game/widgets/player_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class GameStatusDisplay extends StatelessWidget {
  const GameStatusDisplay({required this.state, this.myUid, super.key});

  final GameState state;
  final String? myUid;

  @override
  Widget build(BuildContext context) => _buildPlayerCards();

  Widget _buildPlayerCards() {
    final isGameOver = state.isGameOver;
    final isDraw = state.status == GameStatus.draw;

    // Déterminer qui est "actif" (bordure verte):
    // - Si partie finie: le gagnant
    // - Sinon: le joueur dont c'est le tour
    final playerXActive = isGameOver
        ? (state.winner == Player.x)
        : (state.currentPlayer == Player.x);
    final playerOActive = isGameOver
        ? (state.winner == Player.o)
        : (state.currentPlayer == Player.o);

    // Déterminer si l'utilisateur actuel a gagné (pour le centre)
    bool? currentUserWon;
    if (myUid != null && isGameOver && !isDraw) {
      currentUserWon =
          (state.winner == Player.x && state.playerXInfo.uid == myUid) ||
          (state.winner == Player.o && state.playerOInfo.uid == myUid);
    }

    return Padding(
      padding: AppSpacing.paddingHorizontalXL,
      child: Row(
        children: [
          Expanded(
            child: PlayerInfoCard(
              playerInfo: state.playerXInfo,
              isActive: playerXActive,
              isDraw: isDraw,
              isGameOver: isGameOver,
            ),
          ),

          AppSpacing.horizontalLG,

          _buildCenterIndicator(isDraw, currentUserWon),

          AppSpacing.horizontalLG,

          Expanded(
            child: PlayerInfoCard(
              playerInfo: state.playerOInfo,
              isActive: playerOActive,
              isDraw: isDraw,
              isGameOver: isGameOver,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterIndicator(bool isDraw, bool? currentUserWon) {
    final hasWinner = state.status == GameStatus.won && state.winner != null;

    // Check if it's a win by abandonment (no winning line)
    final isAbandonment = hasWinner && state.winningLine.isEmpty;

    if (isDraw) {
      return Container(
        padding: AppSpacing.paddingMD,
        decoration: BoxDecoration(
          color: AppColors.draw,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.draw.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.handshake_rounded,
          color: Colors.white,
          size: 24,
        ),
      );
    }

    if (hasWinner) {
      // Show cross if current user lost (in online mode)
      if (currentUserWon == false) {
        return Container(
          padding: AppSpacing.paddingMD,
          decoration: BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
        );
      }

      // Show trophy/flag if current user won or in local mode
      // If abandonment, show flag icon instead of trophy
      if (isAbandonment) {
        return Container(
          padding: AppSpacing.paddingMD,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.flag_rounded, color: Colors.white, size: 24),
        );
      }

      // Normal win with trophy
      return Container(
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 24,
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            duration: 1000.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.1, 1.1),
          );
    }

    // En cours : VS
    return Container(
      padding: AppSpacing.paddingHorizontalMD,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: AppBorderRadius.radiusSM,
      ),
      child: Text(
        'VS',
        style: GoogleFonts.poppins(
          fontSize: AppFontSize.md,
          fontWeight: AppFontWeight.black,
          color: Colors.white,
        ),
      ),
    );
  }
}
