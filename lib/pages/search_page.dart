import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/product_card.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flowmart/models/product.dart';
import 'package:flowmart/pages/ar_view_page.dart';
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
  List<Map<String, dynamic>> _allRawData = [];
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _fetchProductsFromFirebase();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _fetchProductsFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'flowmart',
      ).collection('products').get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        _allRawData.add(data);

        return Product(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();

      if (mounted) {
        setState(() {
          _allProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
      _hasSearched = true;
      _filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showLoginWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تنبيه"),
        content: const Text("يرجى تسجيل الدخول للقيام بهذا الإجراء"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء")),
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
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0D0D0D)
            : (isGirlie ? const Color(0xFFFFF0F5) : Colors.white),
        appBar: AppBar(
          backgroundColor: isDark
              ? const Color(0xFF1A1A1A)
              : (isGirlie ? Colors.pink : Colors.blue),
          title: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'ابحث عن منتج...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white70),
            ),
            onSubmitted: _performSearch,
            onChanged: _performSearch,
          ),
        ),
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResults(productProvider, user),
            const WatermarkWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ProductProvider productProvider, User? user) {
    if (!_hasSearched)
      return _buildCenterInfo(Icons.search, "ابدأ البحث عن منتجات");
    if (_filteredProducts.isEmpty)
      return _buildCenterInfo(Icons.search_off, "لم يتم العثور على نتائج");

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final rawData =
            _allRawData.firstWhere((element) => element['id'] == product.id);
        final sellerId = rawData['sellerId'] ?? '';
        final sellerName = rawData['sellerName'] ?? 'ناشر';

        return Dismissible(
          key: Key("search_${product.id}"),
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
          background: _buildSwipeBg(Alignment.centerLeft),
          secondaryBackground: _buildSwipeBg(Alignment.centerRight),
          child: ProductCard(
            product: product,
            sellerName: sellerName,
            isLiked: productProvider.likedProducts.contains(product.id),
            onLike: () => user == null
                ? _showLoginWarning(context)
                : productProvider.toggleLike(product.id),
            onChat: () {
              if (user == null) {
                _showLoginWarning(context);
              } else {
                context.push(AppRoutes.chat, extra: {
                  'receiverUserID': sellerId,
                  'receiverUserEmail': sellerName,
                });
              }
            },
            onArTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ArViewPage(
                        modelUrl:
                            'https://modelviewer.dev/shared-assets/models/Astronaut.glb'))),
            onComment: () {}, // ✅ تمت إضافة الوسيط المطلوب هنا
          ),
        );
      },
    );
  }

  Widget _buildSwipeBg(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      color: Colors.blue.withOpacity(0.2),
      child: const Icon(Icons.chat, color: Colors.white, size: 40),
    );
  }

  Widget _buildCenterInfo(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 80.sp),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 18)),
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
