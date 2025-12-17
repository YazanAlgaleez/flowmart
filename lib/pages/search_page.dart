import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart'; // إذا لم تكن مستخدمة يمكن حذفها
import 'package:flowmart/models/product.dart';
import 'package:flowmart/core/widgets/home_top_bar.dart'; // إذا لم تكن مستخدمة يمكن حذفها
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
    // إضافة مستمع لتحديث زر المسح (X) عند الكتابة
    _searchController.addListener(() {
      setState(() {});
    });
  }

  void _loadProducts() {
    // Mock Data
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
    // إخفاء الكيبورد عند البدء بالبحث
    FocusScope.of(context).unfocus();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true; // نعتبر أن المستخدم بحث حتى لو لم تظهر نتائج بعد
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _allProducts.where((product) {
        final queryLower = query.toLowerCase();
        final nameLower = product.name.toLowerCase();
        // يمكن إضافة البحث في الوصف أيضاً
        return nameLower.contains(queryLower) && product.inStock;
      }).toList();

      if (mounted) {
        setState(() {
          _filteredProducts = results;
          _isLoading = false;
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
  }

  // --- Actions ---
  void _onLike(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked product $productId'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onAddToCart(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added product $productId to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onComment(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment for product $productId'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // --- تعريف الألوان مرة واحدة لتنظيف الكود ---
    final Color backgroundColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
        ? const Color(0xFFFFF0F5)
        : AppColors.whiteColor;

    final Color appBarColor = isDark
        ? const Color(0xFF1A1A1A)
        : isGirlie
        ? const Color(0xFFFF69B4)
        : Colors.blue;

    final Color iconColor = isDark
        ? Colors.white
        : isGirlie
        ? const Color(0xFF8B008B)
        : Colors.white; // أيقونة العودة والبحث

    final Color textColor = isDark
        ? Colors.white
        : isGirlie
        ? const Color(0xFF8B008B)
        : AppColors.blackColor;

    final Color hintColor = isDark
        ? Colors.white.withOpacity(0.7)
        : isGirlie
        ? const Color(0xFFDA70D6)
        : AppColors.secondaryColor;

    return GestureDetector(
      // إغلاق الكيبورد عند النقر في أي مكان فارغ
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(color: iconColor),
          title: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search, // زر البحث في الكيبورد
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontFamily: AppFonts.mainFontName,
            ),
            decoration: InputDecoration(
              hintText: 'Search for a product...',
              hintStyle: TextStyle(
                color: hintColor,
                fontSize: 16.sp,
                fontFamily: AppFonts.mainFontName,
              ),
              border: InputBorder.none,
              // أيقونة البحث
              prefixIcon: Icon(
                Icons.search,
                color: iconColor.withOpacity(0.7), // شفافية قليلة
                size: 24.sp,
              ),
              // زر المسح (X)
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: iconColor),
                      onPressed: _clearSearch,
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
            ),
            onSubmitted: _performSearch,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [Expanded(child: _buildResults(isDark, isGirlie))],
            ),
            const WatermarkWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(bool isDark, bool isGirlie) {
    if (!_hasSearched && _searchController.text.isEmpty) {
      return _buildInitialState(isDark, isGirlie);
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredProducts.isEmpty) {
      return _buildNoResultsState(isDark, isGirlie);
    }

    // استخدام PageView لعرض نمط الـ TikTok أو التمرير العمودي لكل منتج
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Dismissible(
          key: Key(product.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // حذفنا العنصر من القائمة الظاهرة لتجنب خطأ الـ Dismissible
            setState(() {
              _filteredProducts.removeAt(index);
            });
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
            // منطق السحب للأعلى لفتح التفاصيل (يمكن تفعيله إذا كان هناك صفحة تفاصيل)
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < -500) {
                // Swipe up logic
              }
            },
            child: ProductCard(
              product: product,
              isLiked: false,
              isInCart: false,
              onLike: () => _onLike(product.id),
              onAddToCart: () => _onAddToCart(product.id),
              onComment: () => _onComment(product.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialState(bool isDark, bool isGirlie) {
    final color = isDark
        ? Colors.white.withOpacity(0.5)
        : isGirlie
        ? const Color(0xFFDA70D6).withOpacity(0.5)
        : AppColors.secondaryColor.withOpacity(0.5);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: color, size: 80.sp),
            SizedBox(height: 20.h),
            Text(
              'Search for products',
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 18.sp,
                fontFamily: AppFonts.mainFontName,
              ),
            ),
          ],
        ),
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

  Widget _buildNoResultsState(bool isDark, bool isGirlie) {
    final color = isDark
        ? Colors.white.withOpacity(0.5)
        : isGirlie
        ? const Color(0xFFDA70D6).withOpacity(0.5)
        : AppColors.secondaryColor.withOpacity(0.5);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: color, size: 80.sp),
            SizedBox(height: 20.h),
            Text(
              'No products found',
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 18.sp,
                fontFamily: AppFonts.mainFontName,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Try different keywords',
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontFamily: AppFonts.mainFontName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
