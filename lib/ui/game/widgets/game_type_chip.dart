import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTypeChip extends StatelessWidget {
  const GameTypeChip({required this.isPve, required this.size, super.key});

  final bool isPve;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingHorizontalLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.radiusFull,
        boxShadow: AppShadows.standard,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPve ? Icons.smart_toy_rounded : Icons.people_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          AppSpacing.horizontalSM,
          Text(
            '$size×$size',
            style: GoogleFonts.poppins(
              fontSize: AppFontSize.sm,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
