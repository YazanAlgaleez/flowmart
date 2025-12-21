import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 1. إضافة مكتبة الإشعارات
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart'; // 2. إضافة التوجيه
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 3. مكتبة التنقل
import 'package:provider/provider.dart';

final user = FirebaseAuth.instance.currentUser;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  // ✅ كود تفعيل الإشعارات عند فتح الصفحة
  @override
  void initState() {
    super.initState();

    // الاستماع للإشعارات والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.notification!.title ?? 'New Notification',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message.notification!.body ?? ''),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
        children: [
          // Vertical PageView for products
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductCard(
                product: product,
                isLiked: productProvider.likedProducts.contains(product.id),
                isInCart: productProvider.cartProducts.contains(product.id),

                // الأزرار القديمة
                onLike: () => productProvider.toggleLike(product.id),
                onAddToCart: () => productProvider.toggleCart(product.id),
                onComment: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Comment for product ${product.id}'),
                    ),
                  );
                  productProvider.commentOnProduct(product.id);
                },

                // ✅ 1. زر الشات الجديد
                // لا تنسَ إضافة هذا السطر فوق مع الـ imports

// ... داخل ProductCard
                onChat: () {
                  // 1. فحص هل المستخدم مسجل دخول؟

                  if (user == null) {
                    // إذا لم يكن مسجل دخول، أظهر رسالة خطأ ولا تفتح الشات
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يجب عليك تسجيل الدخول أولاً!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // وقف الكود هنا
                  }

                  // 2. إذا كان مسجل دخول، افتح الشات
                  context.push(
                    AppRoutes.chat,
                    extra: {
                      'id': product.id,
                      // تأكدنا سابقاً أن الاسم الصحيح هو name
                      'name': product.name,
                    },
                  );
                },

                // ✅ 2. زر الـ AR الجديد
                onArTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Opening AR for ${product.name}..."),
                      backgroundColor: Colors.purple,
                    ),
                  );
                  // مستقبلاً هنا سنضع: context.push(AppRoutes.arView);
                },
              );
            },
          ),

          // Top Bar Overlay
          const Positioned(top: 0, left: 0, right: 0, child: HomeTopBar()),

          // Watermark
          const WatermarkWidget(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
