import 'package:flowmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isLiked;
  final bool isInCart;
  final VoidCallback onLike;
  final VoidCallback onAddToCart;
  final VoidCallback onChat;
  final VoidCallback onComment;
  final VoidCallback? onArTap; // ✅ هذا الزر اختياري

  const ProductCard({
    super.key,
    required this.product,
    required this.isLiked,
    required this.isInCart,
    required this.onLike,
    required this.onAddToCart,
    required this.onChat,
    required this.onComment,
    this.onArTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. صورة المنتج (خلفية كاملة)
        Positioned.fill(
          child: _buildProductImage(product.imageUrl),
        ),

        // 2. تدرج لوني أسود في الأسفل
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 3. القائمة الجانبية (الأزرار)
        Positioned(
          right: 15.w,
          bottom: 100.h, // ارتفاع عن الحافة السفلية
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر اللايك
              _buildSideButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
                label: "Like",
                onTap: onLike,
              ),
              SizedBox(height: 20.h),

              // زر الشات
              _buildSideButton(
                icon: Icons.chat_bubble_outline,
                color: Colors.white,
                label: "Chat",
                onTap: onChat,
              ),
              SizedBox(height: 20.h),

              // ✅ زر الـ AR (تحت الشات مباشرة)
              _buildSideButton(
                icon: Icons.view_in_ar, // أيقونة المكعب (AR)
                color: Colors.white,
                label: "AR View",
                onTap: onArTap ?? () {}, // استدعاء الدالة
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),

        // 4. تفاصيل المنتج (الاسم والسعر)
        Positioned(
          left: 20.w,
          bottom: 40.h,
          right: 100.w, // نترك مسافة لليمين عشان الأزرار
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${product.price} JOD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (product.description.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ودجت بناء الزر الجانبي
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
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.4),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              shadows: [Shadow(blurRadius: 2, color: Colors.black)],
            ),
          ),
        ],
      ),
    );
  }

  // دالة عرض الصورة
  Widget _buildProductImage(String url) {
    if (url.isEmpty) {
      return Container(
          color: Colors.black,
          child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white)));
    }
    // فحص إذا كان الرابط من النت (فايربيس)
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover, // ملء الشاشة
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        },
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
      );
    }
    // فحص إذا كان صورة محلية (للاختبار)
    else {
      return Image.asset(url, fit: BoxFit.cover);
    }
  }
}
