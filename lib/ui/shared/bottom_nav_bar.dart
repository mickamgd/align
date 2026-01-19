import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.currentRoute, super.key});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.paddingLG,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: AppBorderRadius.radiusXXL,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavButton(
            label: 'Jeux',
            icon: Icons.gamepad_rounded,
            isSelected: currentRoute == '/home',
            onTap: () => context.go(Routes.home),
          ),
          AppSpacing.horizontalSM,
          _NavButton(
            label: 'Historique',
            icon: Icons.leaderboard_rounded,
            isSelected: currentRoute == '/history',
            onTap: () => context.go(Routes.history),
          ),
          AppSpacing.horizontalSM,
          _NavButton(
            label: 'Paramètres',
            icon: Icons.settings_rounded,
            isSelected: currentRoute == '/settings',
            onTap: () => context.go(Routes.settings),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,

        borderRadius: AppBorderRadius.radiusXL,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.greenDark : Colors.white,
            borderRadius: AppBorderRadius.radiusXL,
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.black,
                size: 22,
              ),
              if (isSelected) ...[
                AppSpacing.horizontalSM,
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.black,
                    fontWeight: AppFontWeight.bold,
                    fontSize: AppFontSize.sm,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
