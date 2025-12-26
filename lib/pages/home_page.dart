import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  // ✅ دالة إظهار تنبيه تسجيل الدخول
  void _showLoginWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تسجيل الدخول مطلوب"),
        content:
            const Text("يرجى تسجيل الدخول لتتمكن من التفاعل ومراسلة الناشرين."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.login);
            },
            child: const Text("دخول"),
          ),
        ],
      ),
    );
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
                return Center(
                    child: Text("خطأ في جلب البيانات: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("لا يوجد منتجات حالياً"));
              }

              final docs = snapshot.data!.docs;

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  // ✅ الحل النهائي: تحويل القيم لنصوص باستخدام .toString() لتجنب خطأ الـ int
                  final String sellerId = (data['sellerId'] ?? '').toString();
                  final String sellerName =
                      (data['sellerName'] ?? 'ناشر غير معروف').toString();
                  final String productId = docs[index].id.toString();

                  final product = Product(
                    id: productId,
                    name: (data['name'] ?? '').toString(),
                    price: (data['price'] ?? 0).toDouble(),
                    imageUrl: (data['imageUrl'] ?? '').toString(),
                    description: (data['description'] ?? '').toString(),
                  );

                  return Dismissible(
                    key: Key(productId),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (user == null) {
                        _showLoginWarning(context);
                      } else {
                        context.push(AppRoutes.chat, extra: {
                          'receiverUserID': sellerId,
                          'receiverUserEmail': sellerName,
                          'productDetails': {
                            'name': product.name,
                            'price': product.price,
                            'image': product.imageUrl
                          }
                        });
                      }
                      return false;
                    },
                    background: _buildSwipeBackground(Alignment.centerLeft),
                    secondaryBackground:
                        _buildSwipeBackground(Alignment.centerRight),
                    child: ProductCard(
                      product: product,
                      sellerName: sellerName,
                      isLiked:
                          productProvider.likedProducts.contains(productId),
                      onLike: () {
                        if (user == null) {
                          _showLoginWarning(context);
                        } else {
                          productProvider.toggleLike(productId);
                        }
                      },
                      onChat: () {
                        if (user == null) {
                          _showLoginWarning(context);
                        } else {
                          context.push(AppRoutes.chat, extra: {
                            'receiverUserID': sellerId,
                            'receiverUserEmail': sellerName,
                            'productDetails': {
                              'name': product.name,
                              'price': product.price,
                              'image': product.imageUrl
                            }
                          });
                        }
                      },
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
                    ),
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

  Widget _buildSwipeBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      color: Colors.blueAccent.withOpacity(0.2),
      child: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 45.sp),
    );
  }
}
