import 'package:align/app/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 Design System - Kawaii Gaming Theme (inspiré de la maquette)
class AppColors {
  // Background
  static const background = Color(0xFFFBF7F0);
  static const surface = Color(0xFFFFFFFF);

  // Couleurs
  static const yellow = Color(0xFFFBD144);
  static const pink = Color(0xFFFFA5F4);
  static const purple = Color(0xFF9B72FF);
  static const greenLight = Color(0xFF5DD39E);
  static const greenDark = Color(0xFF009179);
  static const orange = Color(0xFFFFA26B);
  static const black = Color(0xFF212121);

  // Player colors
  static const playerX = Color(0xFF6366F1);
  static const playerO = Color(0xFFFF6B9D);

  // Status
  static const win = Color(0xFF5DD39E);
  static const draw = Color(0xFFFBD144);
  static const error = Color(0xFFFF6B9D);

  // Text
  static const textPrimary = Color(0xFF2D2D2D);
  static const textSecondary = Color(0xFF8B8B8B);
  static const textMuted = Color(0xFFBBBBBB);

  // Gradients
  static const gradientPlayerX = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientPlayerO = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientWin = LinearGradient(
    colors: [Color(0xFF5DD39E), Color(0xFF7AE7B9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientYellow = LinearGradient(
    colors: [Color(0xFFFBD144), Color(0xFFFFE17B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF9B72FF), Color(0xFFB895FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientOrange = LinearGradient(
    colors: [Color(0xFFFFA26B), Color(0xFFFFB88C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Styles de texte centralisés pour l'application
class AppTextStyles {
  // Display styles (très grands titres)
  static final displayLarge = GoogleFonts.archivoBlack(
    fontSize: AppFontSize.mega,
    fontWeight: AppFontWeight.black,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final displayMedium = GoogleFonts.archivoBlack(
    fontSize: AppFontSize.massive,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final displaySmall = GoogleFonts.archivoBlack(
    fontSize: AppFontSize.massive,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Headline styles (grands titres)
  static final headlineLarge = GoogleFonts.poppins(
    fontSize: AppFontSize.huge,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  static final headlineMedium = GoogleFonts.poppins(
    fontSize: AppFontSize.xxxl,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  static final headlineSmall = GoogleFonts.poppins(
    fontSize: AppFontSize.xxl,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  // Title styles (titres de sections)
  static final titleLarge = GoogleFonts.poppins(
    fontSize: AppFontSize.xl,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final titleMedium = GoogleFonts.poppins(
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
  );

  static final titleSmall = GoogleFonts.poppins(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
  );

  // Body styles (texte courant)
  static final bodyLarge = GoogleFonts.poppins(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final bodyMedium = GoogleFonts.poppins(
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final bodySmall = GoogleFonts.poppins(
    fontSize: AppFontSize.xs,
    fontWeight: AppFontWeight.regular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Label styles (labels de boutons, etc.)
  static final labelLarge = GoogleFonts.poppins(
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: Colors.white,
  );

  static final labelMedium = GoogleFonts.poppins(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.semiBold,
    color: Colors.white,
  );

  static final labelSmall = GoogleFonts.poppins(
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.medium,
    color: Colors.white,
  );
}

ThemeData buildTheme() {
  final baseTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.playerX,
      secondary: AppColors.playerO,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
  );

  return baseTheme.copyWith(
    // TextTheme centralisé
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimary,
        foregroundColor: Colors.white,
        padding: AppSpacing.paddingHorizontalHuge,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusFull),
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: AppTextStyles.labelMedium,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: AppSpacing.paddingHorizontalXXL,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusFull),
        textStyle: AppTextStyles.labelSmall,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.textSecondary, width: 2),
        padding: AppSpacing.paddingHorizontalXXL,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusFull),
        textStyle: AppTextStyles.labelSmall,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: AppOpacity.subtle),
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radiusXL),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.radiusMD,
        borderSide: const BorderSide(color: AppColors.textMuted),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.radiusMD,
        borderSide: const BorderSide(color: AppColors.textMuted),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.radiusMD,
        borderSide: const BorderSide(color: AppColors.playerX, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.radiusMD,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textSecondary,
      ),
      hintStyle: AppTextStyles.bodySmall,
    ),
  );
}
