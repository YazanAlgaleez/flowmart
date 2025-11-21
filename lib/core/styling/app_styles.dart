import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // Reusable TextStyle function
  static TextStyle getTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    String fontFamily = AppFonts.mainFontName,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  // Predefined styles using the reusable function
  static TextStyle get primaryHeadLineStyle => getTextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle get supTitleStyle => getTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryColor,
  );

  static TextStyle get black16w6500 => getTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static TextStyle get gray12Medium => getTextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor,
  );
}
