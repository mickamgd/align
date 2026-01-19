import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/game/player_info.dart';
import 'package:flutter/material.dart';

/// Carte affichant les informations d'un joueur avec état actif/inactif
class PlayerInfoCard extends StatelessWidget {
  const PlayerInfoCard({
    required this.playerInfo,
    required this.isActive,
    super.key,
    this.isDraw = false,
    this.isGameOver = false,
  });

  final PlayerInfo playerInfo;
  final bool isActive;
  final bool isDraw;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    // isActive = true signifie bordure verte (gagnant ou son tour selon le contexte)
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.greenDark : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.greenDark.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: isActive ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar avec badge X/O et indicateurs de victoire/défaite
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.greenLight : AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    playerInfo.avatarEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              // Badge X ou O
              Positioned(
                left: -4,
                bottom: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: playerInfo.player.name == 'x'
                        ? AppColors.purple
                        : AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      playerInfo.player.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Trophée pour le gagnant
              if (isGameOver && isActive && !isDraw)
                Positioned(
                  top: -10,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              // Croix pour le perdant
              if (isGameOver && !isActive && !isDraw)
                Positioned(
                  top: -10,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Nom du joueur
          Text(
            playerInfo.displayName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? AppColors.black
                  : AppColors.black.withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Sous-titre (difficulté bot ou vide)
          if (playerInfo.subtitle.isNotEmpty) ...[
            AppSpacing.verticalXS,
            Text(
              playerInfo.subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? AppColors.black.withValues(alpha: 0.6)
                    : AppColors.black.withValues(alpha: 0.3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
