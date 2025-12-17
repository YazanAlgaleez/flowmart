import 'dart:ui';

import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AppbarWidget({super.key, this.title = "FlowMart"});

  @override
  Widget build(BuildContext context) {
    // App bar maintains FlowMart's visual identity with consistent branding
    return AppBar(
      centerTitle: true,
      title: Text(
        textAlign: TextAlign.center,
        title!,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 23.sp,
          fontFamily: AppFonts.mainFontName,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      elevation: 4,
      shadowColor: AppColors.primaryColor.withOpacity(0.3),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
