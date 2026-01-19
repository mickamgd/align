import 'package:align/app/game/game_config.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/game/game_history.dart';
import 'package:align/ui/game/widgets/game_type_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({required this.game, super.key});

  final GameHistory game;

  @override
  Widget build(BuildContext context) {
    final resultColor = _getResultColor(game.result);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resultColor.withAlpha(50),
        borderRadius: AppBorderRadius.radiusMD,
        boxShadow: AppShadows.subtle,
        border: BoxBorder.all(color: resultColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    game.resultLabel,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: resultColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                GameTypeChip(
                  isPve: game.gameMode == GameMode.pve,
                  size: game.boardSize,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        game.playerXEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        game.playerXName,
                        style: AppTextStyles.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'vs',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        game.playerOEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        game.opponentLabel,
                        style: AppTextStyles.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(game.playedAt),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getResultColor(GameHistoryResult result) => switch (result) {
    GameHistoryResult.win => AppColors.greenLight,
    GameHistoryResult.loss => Colors.redAccent,
    GameHistoryResult.draw => Colors.orangeAccent,
  };
}
