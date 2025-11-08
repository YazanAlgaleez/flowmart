import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isLiked;
  final bool isInCart;
  final VoidCallback onLike;
  final VoidCallback onAddToCart;
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontFamily: AppFonts.mainFontName,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '\$${widget.product.discountedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: AppFonts.mainFontName,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.product.hasDiscount) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        fontFamily: AppFonts.mainFontName,
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.mainFontName,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.mainFontName,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Add to Cart Button
              GestureDetector(
                onTap: widget.onAddToCart,
                child: Column(
                  children: [
                    Icon(
                      widget.isInCart
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                      color: widget.isInCart
                          ? AppColors.primaryColor
                          : Colors.white,
                      size: 40.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.mainFontName,
                      ),
                    ),
                  ],
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.mainFontName,
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
