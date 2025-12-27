import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PrimaryOutlineButtonWidgets extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;

  const PrimaryOutlineButtonWidgets({
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
    // 1. الاستماع للثيم
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;
    final isDark = themeProvider.currentTheme == AppTheme.dark;

    // 2. تحديد لون الحدود والنص (إما زهري أو اللون الأساسي)
    final Color effectiveColor =
        isGirlie ? const Color(0xFFFF4081) : AppColors.primaryColor;

    // 3. تحديد لون الخلفية (شفاف في الوضع الليلي لجمالية أكثر)
    final Color effectiveBgColor =
        backgroundColor ?? (isDark ? Colors.transparent : Colors.white);

    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 331.0.w, height ?? 56.h),
        backgroundColor: effectiveBgColor,
        elevation: 0, // إزالة الظل لأنه زر مفرغ

        // ✅ حواف دائرية مع إطار ملون
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 15.0.r),
          side: BorderSide(
            width: 1.5, // سماكة الإطار
            color: effectiveColor, // لون الإطار يتغير مع الثيم
          ),
        ),
      ),
      child: Text(
        buttonText ?? 'Click Me',
        style: TextStyle(
          color: effectiveColor, // ✅ لون النص يطابق لون الإطار
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
