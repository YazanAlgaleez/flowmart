import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final FirebaseService _firebaseService = FirebaseService();
  Timer? _dwellTimer;

  @override
  void initState() {
    super.initState();
    // كود استقبال الإشعارات
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.notification!.title ?? 'New Notification',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(message.notification!.body ?? ''),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  // منطق الذكاء الاصطناعي (مؤقت 5 ثواني)
  void _startTimer(String category) {
    _dwellTimer?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _dwellTimer = Timer(const Duration(seconds: 5), () {
      _firebaseService.addUserInterest(user.uid, category);
      // print("🎯 Interest Detected: $category"); // للتأكد
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dwellTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : Colors.white,

      // 🔥 الزر العائم للانتقال لصفحة الرفع
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/upload'); // تأكد من وجود هذا المسار في AppRoutes
        },
        backgroundColor: Colors.redAccent,
        elevation: 5,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),

      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: productProvider.products.length,
            onPageChanged: (index) {
              final product = productProvider.products[index];
              // شغل المؤقت للمنتج الجديد
              _startTimer("general"); // عدلها لاحقاً لتأخذ من product.category
            },
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              String category = "general";

              return ProductCard(
                product: product,
                isLiked: productProvider.likedProducts.contains(product.id),
                isInCart: productProvider.cartProducts.contains(product.id),

                // 1. زر اللايك
                onLike: () {
                  productProvider.toggleLike(product.id);
                  if (user != null) {
                    _firebaseService.addUserInterest(user.uid, category);
                  }
                },

                // 2. زر السلة
                onAddToCart: () => productProvider.toggleCart(product.id),

                // 3. زر الشات
                onChat: () {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("سجل دخول أولاً"),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }
                  context.push(AppRoutes.chat,
                      extra: {'id': product.id, 'name': product.name});
                },

                // 4. زر الـ AR
                onArTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("AR Loading for ${product.name}...")),
                  );
                },

                // ✅ 5. زر التعليق (الحل للخطأ الأحمر)
                // نمرر دالة فارغة عشان نرضي الكود، بس ما رح تعمل اشي
                onComment: () {},
              );
            },
          ),
          const Positioned(top: 0, left: 0, right: 0, child: HomeTopBar()),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
