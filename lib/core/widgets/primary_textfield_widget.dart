import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PrimaryTextfieldWidget extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PrimaryTextfieldWidget({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // 1. الاستماع للثيم الحالي
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // 2. تحديد الألوان بناءً على الثيم
    final Color fillColor = isDark
        ? const Color(0xFF1E1E1E) // رمادي غامق جداً للوضع الليلي
        : const Color(0xFFF5F5F5); // رمادي فاتح جداً للوضع النهاري

    final Color textColor = isDark ? Colors.white : Colors.black;

    final Color hintColor = isDark ? Colors.grey[500]! : Colors.grey[600]!;

    // لون الحدود عند التركيز (Focus)
    final Color focusBorderColor = isGirlie
        ? const Color(0xFFFF4081) // وردي للثيم البناتي
        : AppColors.primaryColor; // اللون الأساسي للباقي

    return SizedBox(
      height: 56.h, // ارتفاع متجاوب
      width: 331.w, // عرض متجاوب
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: keyboardType == TextInputType.visiblePassword,

        // لون النص المدخل
        style: TextStyle(
            color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w500),

        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,

          hintText: hintText ?? 'Enter text',
          hintStyle: TextStyle(color: hintColor, fontSize: 14.sp),

          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),

          // الحدود في الحالة العادية (بدون تركيز) - جعلناها نظيفة وبدون لون
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r), // ✅ نفس انحناء الأزرار
            borderSide: const BorderSide(color: Colors.transparent),
          ),

          // الحدود عند الكتابة (Focus) - تأخذ لون الثيم
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: focusBorderColor,
              width: 1.5,
            ),
          ),

          // الحدود عند وجود خطأ (Error)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}
