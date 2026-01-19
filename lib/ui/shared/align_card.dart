import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';

class AlignCard extends StatelessWidget {
  const AlignCard({
    required this.child,
    super.key,
    this.color,
    this.gradient,
    this.padding,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.paddingXL,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: AppBorderRadius.radiusXL,
        boxShadow: AppShadows.card,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }

    return widget;
  }
}
