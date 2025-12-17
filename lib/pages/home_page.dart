import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

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
              );
            },
          ),

          // Top Bar Overlay
          Positioned(top: 0, left: 0, right: 0, child: HomeTopBar()),

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
