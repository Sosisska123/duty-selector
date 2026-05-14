import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: .fromSeed(seedColor: AppColors.primary),
    primaryColor: AppColors.text,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(AppSpacing.small),
        ),
        side: const BorderSide(color: AppColors.border),
        elevation: 0,
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: AppColors.primary,
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: .circular(AppSpacing.small)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: .circular(AppSpacing.small),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.text,
      unselectedItemColor: AppColors.text.withValues(alpha: 0.5),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: AppColors.text),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.background,

      focusedBorder: OutlineInputBorder(
        borderRadius: .circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      border: OutlineInputBorder(
        borderRadius: .circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      hintStyle: AppTextStyles.accent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.secondary,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.background,
      todayForegroundColor: .all(AppColors.text),
      dayForegroundColor: .all(AppColors.text),
      yearForegroundColor: .all(AppColors.text),
      dayStyle: AppTextStyles.regular,
      toggleButtonTextStyle: AppTextStyles.regular,
      weekdayStyle: const TextStyle(color: AppColors.text),
      headerForegroundColor: AppColors.text,
      locale: const Locale('ru', 'RU'),
    ),
    timePickerTheme: TimePickerThemeData(
      helpTextStyle: TextStyle(color: AppColors.text),
      backgroundColor: AppColors.background,
      dayPeriodColor: AppColors.secondary,
      dialBackgroundColor: AppColors.secondary,
      dialTextColor: AppColors.text,
      dialHandColor: AppColors.accent,
      hourMinuteColor: AppColors.secondary,
      dayPeriodTextColor: AppColors.text,
      hourMinuteTextColor: AppColors.text,
      confirmButtonStyle: ButtonStyle(
        foregroundColor: .all(AppColors.text),
        backgroundColor: .all(AppColors.secondary),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: .all(AppColors.text),
        backgroundColor: .all(AppColors.secondary),
      ),
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

class AppRadius {
  static const double small = 4.0;
  static const double medium = 8.0;
}

class AppRoutes {
  static const home = '/';
  static const list = '/list';
  static const settings = '/settings';
}

class AppSpacing {
  static const double xsmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
  static const double tableHeightRatio = 0.6;
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
    letterSpacing: 0.1,
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
  static const bigRegular = TextStyle(
    fontSize: 18,
    color: AppColors.text,
    fontFamily: "SFPro",
    fontWeight: FontWeight.w600,
  );
  static const inactive = TextStyle(
    fontSize: 16,
    color: AppColors.accent,
    fontFamily: "SFPro",
    fontWeight: FontWeight.w600,
  );
}
