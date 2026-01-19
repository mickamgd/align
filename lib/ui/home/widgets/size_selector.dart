import 'package:align/app/home/home_providers.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SizeSelector extends ConsumerWidget {
  const SizeSelector({required this.selectedSize, super.key});

  final int selectedSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 5,
      children: [3, 4, 5].map((size) {
        final isSelected = selectedSize == size;
        final colors = [AppColors.purple, AppColors.orange, AppColors.yellow];
        final Color color = colors[[3, 4, 5].indexOf(size)];

        return GestureDetector(
          onTap: () => ref.read(selectedSizeProvider.notifier).setSize(size),
          child: AnimatedContainer(
            duration: AppDurations.normal,
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              //gradient: isSelected ? gradient : null,
              color: isSelected ? color : AppColors.surface,
              borderRadius: AppBorderRadius.radiusCircle,
              //border: Border.all(
              //  color: isSelected ? Colors.transparent : AppColors.textMuted,
              //  width: 2,
              //),
              boxShadow: isSelected ? AppShadows.strong : AppShadows.subtle,
            ),
            child: Center(
              child: Text(
                '$size×$size',
                style: GoogleFonts.poppins(
                  fontSize: AppFontSize.sm,
                  fontWeight: AppFontWeight.extraBold,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
