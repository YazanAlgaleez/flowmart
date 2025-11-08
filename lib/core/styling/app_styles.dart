import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static final TextStyle primaryHeadLineStyle = TextStyle(
    fontSize: 30.sp,
    fontFamily: AppFonts.mainFontName,

    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static final TextStyle supTitleStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFonts.mainFontName,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryColor,
  );
  static final TextStyle black16w6500 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFonts.mainFontName,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static final TextStyle gray12Medium = TextStyle(
    fontSize: 12.sp,
    fontFamily: AppFonts.mainFontName,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor,
  );
}
