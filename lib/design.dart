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
  );
}

class AppColors {
  static const primary = Color(0xFF1A1A1A);
  static const secondary = Color(0xFF1E1E1E);
  static const background = Color(0xFF121212);
  static const text = Colors.white;
  static const border = Color(0xFF333333);
}

class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const body = TextStyle(fontSize: 16, color: AppColors.text);
  static const caption = TextStyle(fontSize: 12, color: AppColors.text);
  static const tableHeader = TextStyle(fontSize: 14, color: AppColors.text);
}

class AppSpacing {
  static const double xsmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double tableHeightRatio = 0.5;
}
