import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.5)
            : isGirlie
            ? Colors.pink.withOpacity(0.5)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shop Logo
          Text(
            'FlowMart',
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : AppColors.primaryColor,
              fontSize: 24.sp,
              fontFamily: AppFonts.mainFontName,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Theme Switcher and Search/Filter Icons
          Row(
            children: [
              IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(
                  isDark
                      ? Icons.light_mode
                      : isGirlie
                      ? Icons.palette
                      : Icons.dark_mode,
                  color: isDark
                      ? Colors.white
                      : isGirlie
                      ? const Color(0xFF8B008B)
                      : AppColors.primaryColor,
                  size: 28.sp,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.search);
                },
                icon: Icon(
                  Icons.search,
                  color: isDark
                      ? Colors.white
                      : isGirlie
                      ? const Color(0xFF8B008B)
                      : AppColors.primaryColor,
                  size: 28.sp,
                ),
              ),
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.filter_list,
                  color: isDark
                      ? Colors.white
                      : isGirlie
                      ? const Color(0xFF8B008B)
                      : AppColors.primaryColor,
                  size: 28.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
