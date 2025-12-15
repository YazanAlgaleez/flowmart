import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isLiked;
  final bool isInCart; // <-- الاسم الأصلي
  final VoidCallback onLike;
  final VoidCallback onAddToCart; // <-- الاسم الأصلي
  final VoidCallback onComment;

  const ProductCard({
    super.key,
    required this.product,
    required this.isLiked,
    required this.isInCart,
    required this.onLike,
    required this.onAddToCart,
    required this.onComment,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.videoUrl != null) {
      _initializeVideo();
    }
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset(widget.product.videoUrl!)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController!.setLooping(true);
        _videoController!.play();
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background: Image or Video
        widget.product.videoUrl != null && _isVideoInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : Image.asset(widget.product.imageUrl, fit: BoxFit.cover),

        // Overlay gradient for text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),

        // Product Info Overlay
        Positioned(
          bottom: 20.h,
          left: 16.w,
          right: 80.w, // Leave space for buttons
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: AppStyles.getTextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '\$${widget.product.discountedPrice.toStringAsFixed(2)}',
                    style: AppStyles.getTextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.product.hasDiscount) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: AppStyles.getTextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${(widget.product.discount! * 100).toInt()}% OFF',
                        style: AppStyles.getTextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.product.inStock
                      ? Colors.green.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.product.inStock ? 'Available' : 'Out of stock',
                  style: AppStyles.getTextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Action Buttons (Right Side)
        Positioned(
          right: 16.w,
          bottom: 100.h,
          child: Column(
            children: [
              // Like Button
              GestureDetector(
                onTap: widget.onLike,
                child: Column(
                  children: [
                    Icon(
                      widget.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: widget.isLiked ? Colors.red : Colors.white,
                      size: 40.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Like',
                      style: AppStyles.getTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Chat Button (الذي يستخدم متغيرات onAddToCart)
              Draggable<String>(
                data: widget.product.id,
                feedback: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline, // <-- 1. الأيقونة معدلة
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
                childWhenDragging: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline, // <-- 2. الأيقونة معدلة
                    color: Colors.grey,
                    size: 25.sp,
                  ),
                ),
                onDragEnd: (details) {
                  if (details.offset.dy >
                      MediaQuery.of(context).size.height * 0.8) {
                    widget.onAddToCart(); // <-- 3. تستخدم الاسم القديم
                  }
                },
                child: GestureDetector(
                  onTap: widget.onAddToCart, // <-- 4. تستخدم الاسم القديم
                  onLongPress: widget.onAddToCart, // <-- 5. تستخدم الاسم القديم
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline, // <-- 6. الأيقونة معدلة
                        color: widget.isInCart
                            ? AppColors.primaryColor
                            : Colors.white,
                        size: 40.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Chat', // <-- 7. النص معدل
                        style: AppStyles.getTextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Comment Button
              GestureDetector(
                onTap: widget.onComment,
                child: Column(
                  children: [
                    Icon(Icons.comment, color: Colors.white, size: 40.sp),
                    SizedBox(height: 4.h),
                    Text(
                      'Comment',
                      style: AppStyles.getTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Double-tap to like gesture
        GestureDetector(
          onDoubleTap: widget.onLike,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ],
    );
  }
}
