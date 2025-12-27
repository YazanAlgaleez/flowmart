import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
    // 1. الاستماع للثيم الحالي لتغيير اللون تلقائياً
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // 2. تحديد اللون: إذا لم يتم تمرير لون، نستخدم لون الثيم
    final Color effectiveColor = backgroundColor ??
        (isGirlie ? const Color(0xFFFF4081) : AppColors.primaryColor);

    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 331.0.w, height ?? 56.h),
        backgroundColor: effectiveColor,
        // ✅ تم تغيير الشكل إلى Rounded ليتناسق مع حقول الإدخال والبطاقات في التطبيق
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 15.0.r),
        ),
        elevation: 2,
        shadowColor: effectiveColor.withOpacity(0.3),
      ),
      child: Text(
        buttonText ?? 'Click Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold, // ✅ جعل الخط عريضاً ليظهر بوضوح
        ),
      ),
    );
  }
}
