import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:align/domain/game/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class GameCell extends StatefulWidget {
  const GameCell({
    required this.player,
    required this.isWinningCell,
    required this.isDisabled,
    required this.onTap,
    super.key,
  });

  final Player? player;
  final bool isWinningCell;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  State<GameCell> createState() => _GameCellState();
}

class _GameCellState extends State<GameCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDurations.verySlow,
    );
  }

  @override
  void didUpdateWidget(GameCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isWinningCell && widget.isWinningCell) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.player == Player.x
        ? AppColors.purple
        : widget.player == Player.o
        ? AppColors.orange
        : null;

    return GestureDetector(
      onTap: widget.isDisabled ? null : widget.onTap,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: color == null
              ? Colors.white
              : widget.isWinningCell
              ? AppColors.greenLight
              : color,

          borderRadius: AppBorderRadius.radiusLG,
          border: Border.all(
            color: widget.isWinningCell ? AppColors.win : Colors.transparent,
          ),
          boxShadow: widget.player != null || widget.isWinningCell
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isWinningCell ? 0.2 : 0.12,
                    ),
                    blurRadius: widget.isWinningCell ? 20 : 12,
                    offset: Offset(0, widget.isWinningCell ? 8 : 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: widget.player != null
              ? Text(
                      widget.player!.label,
                      style: GoogleFonts.poppins(
                        fontSize: AppFontSize.ultra,
                        fontWeight: AppFontWeight.black,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: AppDurations.fast)
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.0, 1.0),
                      duration: AppDurations.medium,
                      curve: Curves.elasticOut,
                    )
              : null,
        ),
      ),
    );
  }
}
