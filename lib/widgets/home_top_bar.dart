import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onFilter;

  const HomeTopBar({super.key, required this.onSearch, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
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
              color: Colors.white,
              fontSize: 24.sp,
              fontFamily: AppFonts.mainFontName,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Search and Filter Icons
          Row(
            children: [
              IconButton(
                onPressed: onSearch,
                icon: Icon(Icons.search, color: Colors.white, size: 28.sp),
              ),
              IconButton(
                onPressed: onFilter,
                icon: Icon(Icons.filter_list, color: Colors.white, size: 28.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
