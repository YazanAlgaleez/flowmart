import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅ استيراد ملف اللغة
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

// 1. استخدام AutomaticKeepAliveClientMixin للحفاظ على حالة الصفحة
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();

  // 2. متغير لتخزين الستريم لمنع إعادة تحميله
  late Stream<QuerySnapshot> _productsStream;

  @override
  void initState() {
    super.initState();
    // 3. تعريف الستريم مرة واحدة فقط عند بدء الصفحة
    _productsStream = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'flowmart',
    ).collection('products').orderBy('createdAt', descending: true).snapshots();
  }

  // 4. تفعيل الحفاظ على الحالة
  @override
  bool get wantKeepAlive => true;

  // ✅ تمرير loc للترجمة
  void _showLoginWarning(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('login_required')), // "تسجيل الدخول مطلوب"
        content: Text(loc.translate('login_msg')), // "يرجى تسجيل الدخول..."
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('cancel'))), // "إلغاء"
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.login);
            },
            child: Text(loc.translate('login')), // "دخول"
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 5. ضروري جداً لعمل KeepAlive

    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    // ✅ استدعاء الترجمة
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    final Color backgroundColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.white;

    final List<Color> fabGradient = isGirlie
        ? [const Color(0xFFFF80AB), const Color(0xFFFF4081)]
        : [const Color(0xFFFF512F), const Color(0xFFDD2476)];

    final Color fabShadowColor = isGirlie
        ? const Color(0xFFFF4081).withOpacity(0.5)
        : const Color(0xFFDD2476).withOpacity(0.5);

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: backgroundColor,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: GestureDetector(
            onTap: () {
              if (user == null) {
                _showLoginWarning(context, loc); // ✅
              } else {
                context.push(AppRoutes.upload);
              }
            },
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: fabGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: fabShadowColor,
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.add_a_photo_outlined,
                  color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 6. استخدام المتغير المخزن
          StreamBuilder<QuerySnapshot>(
            stream: _productsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        "${loc.translate('error_snapshot')} ${snapshot.error}")); // "خطأ..."
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                    child:
                        Text(loc.translate('no_products'))); // "لا توجد منتجات"
              }

              final docs = snapshot.data!.docs;

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  final String sellerId = (data['sellerId'] ?? '').toString();
                  final String sellerName = (data['sellerName'] ??
                          loc.translate(
                              'unknown_publisher')) // "ناشر غير معروف"
                      .toString();
                  final String productId = docs[index].id.toString();
                  final String productName = (data['name'] ?? '').toString();
                  final String productDesc =
                      (data['description'] ?? '').toString();
                  final String productImg = (data['imageUrl'] ?? '').toString();
                  final double productPrice = (data['price'] ?? 0).toDouble();

                  final product = Product(
                    id: productId,
                    name: productName,
                    price: productPrice,
                    imageUrl: productImg,
                    description: productDesc,
                  );

                  return Dismissible(
                    key: Key(productId),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (user == null) {
                        _showLoginWarning(context, loc); // ✅
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
                          _showLoginWarning(context, loc); // ✅
                        } else {
                          productProvider.toggleLike(productId);
                        }
                      },
                      onChat: () {
                        if (user == null) {
                          _showLoginWarning(context, loc); // ✅
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
                                        'https://modelviewer.dev/shared-assets/models/Astronaut.glb')));
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
