import 'dart:async';

import 'package:align/app/router.dart';
import 'package:align/app/theme.dart';
import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef BackButtonCallback = FutureOr<void> Function();

class BackButtonAlign extends StatelessWidget {
  const BackButtonAlign({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorderRadius.radiusSM,
        boxShadow: AppShadows.standard,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: onPressed ?? () => context.go(Routes.home),
      ),
    );
  }
}
