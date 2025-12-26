import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flowmart/models/product.dart';
import 'package:flowmart/pages/ar_view_page.dart';
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title ?? 'New Notification'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _startTimer(String category) {
    _dwellTimer?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _dwellTimer = Timer(const Duration(seconds: 5), () {
      _firebaseService.addUserInterest(user.uid, category);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.upload),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            // الاتصال بقاعدة flowmart
            stream: FirebaseFirestore.instanceFor(
              app: Firebase.app(),
              databaseId: 'flowmart',
            )
                .collection('products')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("حدث خطأ: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("لا يوجد منتجات حالياً، كن أول من يضيف! 📸",
                      style: TextStyle(fontSize: 16)),
                );
              }

              final docs = snapshot.data!.docs;

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: docs.length,
                onPageChanged: (index) {
                  _startTimer("general");
                },
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  final product = Product(
                    id: docs[index].id,
                    name: data['name'] ?? 'بدون اسم',
                    price: (data['price'] ?? 0).toDouble(),
                    imageUrl: data['imageUrl'] ?? '',
                    description: data['description'] ?? '',
                  );

                  return ProductCard(
                    product: product,
                    isLiked: productProvider.likedProducts.contains(product.id),
                    isInCart: productProvider.cartProducts.contains(product.id),
                    onLike: () {
                      productProvider.toggleLike(product.id);
                      if (user != null) {
                        _firebaseService.addUserInterest(user.uid, "general");
                      }
                    },
                    onAddToCart: () => productProvider.toggleCart(product.id),
                    onChat: () {
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("يرجى تسجيل الدخول")));
                        return;
                      }
                      context.push(AppRoutes.chat, extra: {
                        'id': product.id,
                        'name': product.name,
                        'product': {
                          'name': product.name,
                          'price': product.price,
                          'image': product.imageUrl
                        }
                      });
                    },

                    // ✅ هنا التصحيح: إضافة modelUrl
                    onArTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArViewPage(
                            modelUrl:
                                'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
                          ),
                        ),
                      );
                    },

                    onComment: () {},
                  );
                },
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
