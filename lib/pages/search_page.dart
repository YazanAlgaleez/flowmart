import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowmart/core/providers/product_provider.dart'; // ✅ ضروري للأكشنز
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart'; // ✅ للراوتر
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_fonts.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flowmart/models/product.dart'; // ✅ استيراد Product من models
import 'package:flowmart/services/firebase_service.dart'; // ✅ لخدمات الفايربيس
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService(); // ✅

  List<Product> _allProducts = []; // القائمة الكاملة من الفايربيس
  List<Product> _filteredProducts = []; // نتائج البحث
  bool _isLoading = true; // نبدأ بالتحميل
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _fetchProductsFromFirebase(); // ✅ جلب البيانات الحقيقية

    _searchController.addListener(() {
      setState(() {});
    });
  }

  // ✅ دالة لجلب كل المنتجات مرة واحدة
  Future<void> _fetchProductsFromFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      final products =
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

      if (mounted) {
        setState(() {
          _allProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // يمكنك إظهار رسالة خطأ هنا
      }
      debugPrint("Error fetching products: $e");
    }
  }

  void _performSearch(String query) {
    FocusScope.of(context).unfocus();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _hasSearched = true;
      // ✅ التصفية تتم محلياً من القائمة المحملة من الفايربيس
      _filteredProducts = _allProducts.where((product) {
        final queryLower = query.toLowerCase();
        final nameLower = product.name.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
  }

  // --- Actions ---
  // ✅ تم تفعيل الأكشنز لتعمل مثل الصفحة الرئيسية
  void _onLike(Product product, ProductProvider provider) {
    final user = FirebaseAuth.instance.currentUser;
    provider.toggleLike(product.id);
    if (user != null) {
      _firebaseService.addUserInterest(user.uid, "search_interest");
    }
  }

  void _onAddToCart(String productId, ProductProvider provider) {
    provider.toggleCart(productId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Updated cart'), duration: Duration(milliseconds: 500)),
    );
  }

  void _onChat(Product product) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login required")));
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
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context); // ✅ استدعاء البروفايدر

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

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
            : Colors.white;

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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(color: iconColor),
          title: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
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
              prefixIcon: Icon(Icons.search,
                  color: iconColor.withOpacity(0.7), size: 24.sp),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: iconColor),
                      onPressed: _clearSearch,
                    )
                  : null,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            onSubmitted: _performSearch,
            onChanged: (val) {
              // ✅ بحث فوري أثناء الكتابة (اختياري)
              _performSearch(val);
            },
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: _buildResults(isDark, isGirlie, productProvider))
              ],
            ),
            const WatermarkWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(
      bool isDark, bool isGirlie, ProductProvider productProvider) {
    // إذا كان جاري تحميل البيانات من الفايربيس لأول مرة
    if (_isLoading && _allProducts.isEmpty) {
      return _buildLoadingState();
    }

    if (!_hasSearched && _searchController.text.isEmpty) {
      return _buildInitialState(isDark, isGirlie);
    }

    if (_filteredProducts.isEmpty) {
      return _buildNoResultsState(isDark, isGirlie);
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
            setState(() {
              _filteredProducts.removeAt(index);
            });
            _onAddToCart(product.id, productProvider);
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
                Text('Add to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              ],
            ),
          ),
          child: GestureDetector(
            onDoubleTap: () => _onLike(product, productProvider),
            child: ProductCard(
              product: product, // نمرر المنتج الصحيح

              // ✅ ربط الحالة بالبروفايدر
              isLiked: productProvider.likedProducts.contains(product.id),
              isInCart: productProvider.cartProducts.contains(product.id),

              onLike: () => _onLike(product, productProvider),
              onAddToCart: () => _onAddToCart(product.id, productProvider),

              // ✅ تفعيل الشات
              onChat: () => _onChat(product),

              onComment: () {},
              onArTap: () {},
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, color: color, size: 80.sp),
          SizedBox(height: 20.h),
          Text('Search for products',
              style: TextStyle(color: color.withOpacity(0.7), fontSize: 18.sp)),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
    );
  }

  Widget _buildNoResultsState(bool isDark, bool isGirlie) {
    final color = isDark
        ? Colors.white.withOpacity(0.5)
        : isGirlie
            ? const Color(0xFFDA70D6).withOpacity(0.5)
            : AppColors.secondaryColor.withOpacity(0.5);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: color, size: 80.sp),
          SizedBox(height: 20.h),
          Text('No products found',
              style: TextStyle(color: color.withOpacity(0.7), fontSize: 18.sp)),
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
