import 'package:flutter/material.dart';

/// Constantes d'espacement réutilisables
class AppSpacing {
  AppSpacing._();

  // Spacing de base
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 30.0;
  static const double huge = 32.0;
  static const double massive = 40.0;
  static const double giant = 80.0;

  // SizedBox helpers
  static const Widget verticalXS = SizedBox(height: xs);
  static const Widget verticalSM = SizedBox(height: sm);
  static const Widget verticalMD = SizedBox(height: md);
  static const Widget verticalLG = SizedBox(height: lg);
  static const Widget verticalXL = SizedBox(height: xl);
  static const Widget verticalXXL = SizedBox(height: xxl);
  static const Widget verticalXXXL = SizedBox(height: xxxl);
  static const Widget verticalHuge = SizedBox(height: huge);
  static const Widget verticalMassive = SizedBox(height: massive);
  static const Widget verticalGiant = SizedBox(height: giant);

  static const Widget horizontalXS = SizedBox(width: xs);
  static const Widget horizontalSM = SizedBox(width: sm);
  static const Widget horizontalMD = SizedBox(width: md);
  static const Widget horizontalLG = SizedBox(width: lg);
  static const Widget horizontalXL = SizedBox(width: xl);
  static const Widget horizontalXXL = SizedBox(width: xxl);
  static const Widget horizontalXXXL = SizedBox(width: xxxl);
  static const Widget horizontalHuge = SizedBox(width: huge);
  static const Widget horizontalMassive = SizedBox(width: massive);

  // Padding helpers
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);
  static const EdgeInsets paddingHuge = EdgeInsets.all(huge);
  static const EdgeInsets paddingMassive = EdgeInsets.all(massive);

  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(
    horizontal: xxl,
  );
  static const EdgeInsets paddingHorizontalXXXL = EdgeInsets.symmetric(
    horizontal: xxxl,
  );

  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(
    vertical: xxl,
  );
  static const EdgeInsets paddingVerticalXXXL = EdgeInsets.symmetric(
    vertical: xxxl,
  );
  static const EdgeInsets paddingVerticalHuge = EdgeInsets.symmetric(
    vertical: huge,
  );

  static const EdgeInsets paddingHorizontalHuge = EdgeInsets.symmetric(
    horizontal: huge,
  );
}

/// Constantes de BorderRadius réutilisables
class AppBorderRadius {
  AppBorderRadius._();

  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 30.0;
  static const double massive = 40.0;
  static const double circle = 50.0;
  static const double full = 100.0;

  // BorderRadius helpers
  static final BorderRadius radiusXS = BorderRadius.circular(xs);
  static final BorderRadius radiusSM = BorderRadius.circular(sm);
  static final BorderRadius radiusMD = BorderRadius.circular(md);
  static final BorderRadius radiusLG = BorderRadius.circular(lg);
  static final BorderRadius radiusXL = BorderRadius.circular(xl);
  static final BorderRadius radiusXXL = BorderRadius.circular(xxl);
  static final BorderRadius radiusMassive = BorderRadius.circular(massive);
  static final BorderRadius radiusCircle = BorderRadius.circular(circle);
  static final BorderRadius radiusFull = BorderRadius.circular(full);
}

/// Constantes d'ombres réutilisables
class AppShadows {
  AppShadows._();

  static final List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> standard = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> moderate = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> emphasized = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> strong = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> veryStrong = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Constantes de durées d'animation
class AppDurations {
  AppDurations._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);
  static const Duration long = Duration(seconds: 3);

  // Durées spécifiques
  static const Duration pageTransition = Duration(milliseconds: 220);
}

/// Constantes d'opacité/transparence
class AppOpacity {
  AppOpacity._();

  static const double invisible = 0.0;
  static const double verySubtle = 0.04;
  static const double subtle = 0.06;
  static const double light = 0.08;
  static const double moderate = 0.12;
  static const double medium = 0.15;
  static const double strong = 0.2;
  static const double veryStrong = 0.3;
  static const double semiTransparent = 0.5;
  static const double mostlyOpaque = 0.9;
  static const double opaque = 1.0;
}

class AppFontSize {
  AppFontSize._();

  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xxl = 22.0;
  static const double xxxl = 24.0;
  static const double huge = 28.0;
  static const double massive = 32.0;
  static const double giant = 40.0;
  static const double mega = 50.0;
  static const double ultra = 56.0;
}

/// Constantes de font weights
class AppFontWeight {
  AppFontWeight._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}
