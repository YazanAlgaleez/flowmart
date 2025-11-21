import 'package:flutter/material.dart';
import 'package:flowmart/core/styling/app_themes.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData => AppThemes.getTheme(_currentTheme);

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void toggleTheme() {
    switch (_currentTheme) {
      case AppTheme.light:
        _currentTheme = AppTheme.dark;
        break;
      case AppTheme.dark:
        _currentTheme = AppTheme.girlie;
        break;
      case AppTheme.girlie:
        _currentTheme = AppTheme.light;
        break;
    }
    notifyListeners();
  }
}
