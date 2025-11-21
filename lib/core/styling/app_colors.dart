import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF617AFD);
  static const Color secondaryColor = Color(0xFF8391A1);
  static const Color blackColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color TextFieldColor = Color(0xFFF7F8F9);
  static const String ColorReverseThameSwitch = """color: isDark
                  " Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : Colors.black,""";
  //   static  ThemeProvider ColorThameSwitch( bool isDark, bool isGirlie) {
  // isDark
  //           ? const Color(0xFF0D0D0D)
  //           : isGirlie
  //           ? const Color(0xFFFFF0F5)
  //           : Colors.white;}
}
