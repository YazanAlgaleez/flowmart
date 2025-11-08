import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  const PrimaryButtonWidget({
    super.key,
    this.buttonText,
    this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 331.0.w, height ?? 56.h),
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        shape: BeveledRectangleBorder(
          //borderRadius: BorderRadius.circular(borderRadius ?? 8.0.r),
        ),
      ),

      child: Text(
        buttonText ?? 'Click Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          // fontWeight:
          //     AppFonts.mainFontName == 'bold'
          //         ? FontWeight.bold
          //         : FontWeight.normal,
        ),
      ),
    );
  }
}
