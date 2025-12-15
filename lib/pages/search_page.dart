import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flowmart/models/product.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Mock product data - in real app, this would come from API
    _allProducts = [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        price: 99.99,
        discount: 0.2,
        imageUrl: 'lib/assets/images/download.jpg',
        videoUrl: null,
        description:
            'High-quality wireless headphones with noise cancellation.',
        inStock: true,
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        price: 199.99,
        discount: 0.15,
        imageUrl: 'lib/assets/images/download.jpeg',
        videoUrl: null,
        description: 'Feature-packed smart watch with health tracking.',
        inStock: true,
      ),
      Product(
        id: '3',
        name: 'Gaming Mouse',
        price: 49.99,
        discount: null,
        imageUrl:
            'lib/assets/images/WhatsApp Image 2025-10-31 at 16.23.33_375c0630.jpg',
        videoUrl: null,
        description: 'Ergonomic gaming mouse with customizable buttons.',
        inStock: false,
      ),
      Product(
        id: '4',
        name: 'Bluetooth Speaker',
        price: 79.99,
        discount: 0.1,
        imageUrl: 'lib/assets/images/download.jpg',
        videoUrl: null,
        description: 'Portable Bluetooth speaker with deep bass.',
        inStock: true,
      ),
      Product(
        id: '5',
        name: 'Laptop Stand',
        price: 29.99,
        discount: null,
        imageUrl: 'lib/assets/images/download.jpeg',
        videoUrl: null,
        description: 'Adjustable laptop stand for better ergonomics.',
        inStock: true,
      ),
    ];
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) &&
                product.inStock,
          )
          .toList();

      setState(() {
        _filteredProducts = results;
        _isLoading = false;
        _hasSearched = true;
      });
    });
  }

  void _onLike(String productId) {
    // Handle like functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Liked product $productId')));
  }

  void _onAddToCart(String productId) {
    // Handle add to cart functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added product $productId to cart')));
  }

  void _onComment(String productId) {
    // Handle comment functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Comment for product $productId')));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : isGirlie
                ? const Color(0xFF8B008B)
                : AppColors.blackColor,
            fontSize: 16.sp,
            fontFamily: AppFonts.mainFontName,
          ),
          decoration: InputDecoration(
            hintText: 'Search for a product',
            hintStyle: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : isGirlie
                  ? const Color(0xFFDA70D6)
                  : AppColors.secondaryColor,
              fontSize: 16.sp,
              fontFamily: AppFonts.mainFontName,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : AppColors.secondaryColor,
              size: 24.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 15.h,
            ),
          ),
          onSubmitted: _performSearch,
        ),
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : isGirlie
            ? const Color(0xFFFF69B4)
            : Colors.blue,
        iconTheme: IconThemeData(
          color: isDark
              ? Colors.white
              : isGirlie
              ? const Color(0xFF8B008B)
              : Colors.white,
        ),
      ),

      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
          ? const Color(0xFFFFF0F5)
          : AppColors.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar

              // Results
              Expanded(child: _buildResults()),
            ],
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (!_hasSearched) {
      return _buildInitialState();
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredProducts.isEmpty) {
      return _buildNoResultsState();
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Dismissible(
          key: Key(product.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _onAddToCart(product.id);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.w),
            color: AppColors.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_shopping_cart, color: Colors.white, size: 40.sp),
                SizedBox(height: 8.h),
                Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: AppFonts.mainFontName,
                  ),
                ),
              ],
            ),
          ),
          child: GestureDetector(
            onDoubleTap: () => _onLike(product.id),
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < -500) {
                // Swipe up - open product details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Open details for ${product.name}')),
                );
              }
            },
            child: ProductCard(
              product: product,
              isLiked: false, // In real app, check from state
              isInCart: false, // In real app, check from state
              onLike: () => _onLike(product.id),
              onAddToCart: () => _onAddToCart(product.id),
              onComment: () => _onComment(product.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialState() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : isGirlie
                ? const Color(0xFFDA70D6).withOpacity(0.5)
                : AppColors.secondaryColor.withOpacity(0.5),
            size: 80.sp,
          ),
          SizedBox(height: 20.h),
          Text(
            'Search for products',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : isGirlie
                  ? const Color(0xFFDA70D6).withOpacity(0.7)
                  : AppColors.secondaryColor.withOpacity(0.7),
              fontSize: 18.sp,
              fontFamily: AppFonts.mainFontName,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildNoResultsState() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : isGirlie
                ? const Color(0xFFDA70D6).withOpacity(0.5)
                : AppColors.secondaryColor.withOpacity(0.5),
            size: 80.sp,
          ),
          SizedBox(height: 20.h),
          Text(
            'No products found',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : isGirlie
                  ? const Color(0xFFDA70D6).withOpacity(0.7)
                  : AppColors.secondaryColor.withOpacity(0.7),
              fontSize: 18.sp,
              fontFamily: AppFonts.mainFontName,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Try different keywords',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : isGirlie
                  ? const Color(0xFFDA70D6).withOpacity(0.5)
                  : AppColors.secondaryColor.withOpacity(0.5),
              fontSize: 14.sp,
              fontFamily: AppFonts.mainFontName,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
