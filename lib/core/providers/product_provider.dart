import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  // ❌ قمنا بحذف القائمة _products لأن البيانات الآن تأتي من الإنترنت مباشرة

  // تخزين معرفات (IDs) المنتجات التي تفاعل معها المستخدم
  final Set<String> _likedProducts = {};
  final Set<String> _cartProducts = {};

  // Getters
  Set<String> get likedProducts => _likedProducts;
  Set<String> get cartProducts => _cartProducts;

  // ❤ دالة الإعجاب
  void toggleLike(String productId) {
    if (_likedProducts.contains(productId)) {
      _likedProducts.remove(productId);
    } else {
      _likedProducts.add(productId);
    }
    notifyListeners();
  }

  // 🛒 دالة السلة
  void toggleCart(String productId) {
    if (_cartProducts.contains(productId)) {
      _cartProducts.remove(productId);
    } else {
      _cartProducts.add(productId);
    }
    notifyListeners();
  }
}
