import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flutter/material.dart';

enum AppTheme { light, dark, girlie }

class AppThemes {
  static ThemeData getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return _lightTheme;
      case AppTheme.dark:
        return _darkTheme;
      case AppTheme.girlie:
        return _girlieTheme;
    }
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF617AFD),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF617AFD),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.blackbackgroundColor,
    appBarTheme: const AppBarTheme(foregroundColor: AppColors.whiteColor),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.whiteColor),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );

  static final ThemeData _girlieTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColorThemeGirly, // Hot Pink
    scaffoldBackgroundColor: const Color(0xFFFFF0F5), // Lavender Blush
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColorThemeGirly,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF8B008B)), // Dark Magenta
      bodyMedium: TextStyle(color: Color(0xFFDA70D6)), // Orchid
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColorThemeGirly,
      secondary: Color(0xFFFFC0CB), // Pink
      surface: Color(0xFFFFF0F5),
    ),
  );
}
