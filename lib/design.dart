import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    primaryColor: AppColors.text,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.small),
        ),
        side: BorderSide(color: AppColors.border),
        elevation: 0,
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: AppColors.primary,
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.small),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.small),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.text,
      unselectedItemColor: AppColors.text.withValues(alpha: 0.5),
    ),
  );
}

class AppColors {
  static const primary = Color(0xFF141414);
  static const secondary = Color(0xFF292929);
  static const accent = Color(0xFF4D4D4D);
  static const background = Color(0xFF141414);
  static const text = Colors.white;
  static const border = Color(0xFFE0E0E1);
}

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 30,
    color: AppColors.text,
    height: 1.1,
    fontWeight: FontWeight.w600,
    fontFamily: "SFPro",
  );
  static const accent = TextStyle(
    fontSize: 20,
    color: AppColors.accent,
    fontWeight: FontWeight.w600,
    fontFamily: "SFPro",
  );
  static const smallAccent = TextStyle(
    fontSize: 17,
    color: AppColors.accent,
    fontWeight: FontWeight.w600,
    fontFamily: "SFPro",
  );
  static const regularBold = TextStyle(
    fontSize: 17,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: "SFPro",
  );
  static const regular = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    fontFamily: "SFPro",
    fontWeight: FontWeight.w600,
  );
}

class AppSpacing {
  static const double xsmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
}

class AppRadius {
  static const double small = 4.0;
  static const double medium = 8.0;
}

class AppRoutes {
  static const home = '/';
  static const list = '/list';
  static const settings = '/settings';
}
