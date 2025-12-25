import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final bool isLiked;
  final bool isInCart;
  final VoidCallback onLike;
  final VoidCallback onAddToCart;
  final VoidCallback onComment;
  final VoidCallback? onChat;
  final VoidCallback? onArTap;
  const ProductCard({
    super.key,
    required this.product,
    required this.isLiked,
    required this.isInCart,
    required this.onLike,
    required this.onAddToCart,
    required this.onComment,
    this.onChat,
    this.onArTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية (صورة المنتج)
        Positioned.fill(
          child: Image.asset(
            // ✅ 1. التعديل الأول: غيرنا image إلى imageUrl
            // (إذا طلع خطأ، جرب: product.img أو product.imagePath)
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: Colors.grey),
          ),
        ),

        // التدرج اللوني
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),

        // الأزرار الجانبية
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            children: [
              _sideBtn(isLiked ? Icons.favorite : Icons.favorite_border, "Like",
                  onLike, isLiked ? Colors.red : Colors.white),
              const SizedBox(height: 20),

              // زر الشات
              _sideBtn(Icons.chat_bubble_outline, "Chat", onChat ?? () {},
                  Colors.white),
              const SizedBox(height: 20),

              // زر الـ AR
              _sideBtn(
                  Icons.view_in_ar, "AR View", onArTap ?? () {}, Colors.white),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // تفاصيل المنتج بالأسفل
        Positioned(
          left: 16,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 2. التعديل الثاني: غيرنا title إلى name (لأن الموديل عندك يستخدم name)
              Text(product.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text("${product.price} JOD",
                  style: const TextStyle(color: Colors.green, fontSize: 18)),
            ],
          ),
        )
      ],
    );
  }

  Widget _sideBtn(
      IconData icon, String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: Colors.black45, child: Icon(icon, color: color)),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10))
        ],
      ),
    );
  }
}
