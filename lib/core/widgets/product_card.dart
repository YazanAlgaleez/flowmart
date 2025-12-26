import 'package:flowmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String sellerName;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onChat;
  final VoidCallback? onArTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.sellerName,
    required this.isLiked,
    required this.onLike,
    required this.onChat,
    this.onArTap,
    required Null Function() onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onDoubleTap: onLike, // ✅ لايك عند النقر المزدوج
            child: Image.network(product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.black)),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 250.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          right: 15.w,
          bottom: 100.h,
          child: Column(
            children: [
              _buildSideButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  label: "Like",
                  onTap: onLike),
              SizedBox(height: 25.h),
              _buildSideButton(
                  icon: Icons.chat_bubble_outline,
                  color: Colors.white,
                  label: "Chat",
                  onTap: onChat),
              SizedBox(height: 25.h),
              _buildSideButton(
                  icon: Icons.view_in_ar,
                  color: Colors.white,
                  label: "AR View",
                  onTap: onArTap ?? () {}),
            ],
          ),
        ),
        Positioned(
          left: 20.w,
          bottom: 40.h,
          right: 100.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("بواسطة: $sellerName",
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
              SizedBox(height: 5.h),
              Text(product.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.r)),
                child: Text('${product.price} JOD',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideButton(
      {required IconData icon,
      required Color color,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 11.sp)),
        ],
      ),
    );
  }
}
