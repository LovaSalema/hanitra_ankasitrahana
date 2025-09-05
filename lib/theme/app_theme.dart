import 'package:flutter/material.dart';

class AppColors {
  // Burgundy Red Primary Palette
  static const Color primaryBurgundy = Color(0xFF8B1538);
  static const Color darkBurgundy = Color(0xFF6B0F2A);
  static const Color lightBurgundy = Color(0xFFA91B47);
  static const Color burgundyAccent = Color(0xFFB91C4C);

  // Complementary Colors
  static const Color deepRed = Color(0xFF7F1D1D);
  static const Color crimson = Color(0xFFDC2626);
  static const Color rose = Color(0xFFE11D48);
  static const Color pink = Color(0xFFEC4899);

  // Neutral Colors
  static const Color darkGray = Color(0xFF1F2937);
  static const Color mediumGray = Color(0xFF4B5563);
  static const Color lightGray = Color(0xFF9CA3AF);
  static const Color paleGray = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}

class AppTypography {
  static const String fontFamily = 'Inter';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 50.0;
}

class AppElevation {
  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBurgundy,
        brightness: Brightness.light,
        primary: AppColors.primaryBurgundy,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.burgundyAccent,
        onSecondary: AppColors.textOnPrimary,
        tertiary: AppColors.rose,
        onTertiary: AppColors.textOnPrimary,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
      ),

      // Primary Color
      primaryColor: AppColors.primaryBurgundy,
      primaryColorDark: AppColors.darkBurgundy,
      primaryColorLight: AppColors.lightBurgundy,

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBurgundy,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppElevation.none,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: AppTypography.semiBold,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textOnPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: AppElevation.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBurgundy,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppElevation.sm,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBurgundy,
          side: const BorderSide(color: AppColors.primaryBurgundy, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBurgundy,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBurgundy,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: BorderSide(color: AppColors.lightGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: BorderSide(color: AppColors.lightGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryBurgundy,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primaryBurgundy,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.textOnPrimary,
        size: 24,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.paleGray,
        selectedColor: AppColors.primaryBurgundy,
        secondarySelectedColor: AppColors.lightBurgundy,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryBurgundy,
        linearTrackColor: AppColors.paleGray,
        circularTrackColor: AppColors.paleGray,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryBurgundy,
        inactiveTrackColor: AppColors.lightGray,
        thumbColor: AppColors.primaryBurgundy,
        overlayColor: AppColors.primaryBurgundy.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primaryBurgundy,
        valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBurgundy;
          }
          return AppColors.lightGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightBurgundy;
          }
          return AppColors.paleGray;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBurgundy;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        side: const BorderSide(color: AppColors.lightGray, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xs),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBurgundy;
          }
          return AppColors.lightGray;
        }),
      ),
    );
  }
}
