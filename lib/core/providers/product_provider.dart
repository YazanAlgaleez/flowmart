import 'package:flutter/material.dart';
import 'package:flowmart/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 99.99,
      discount: 0.2,
      imageUrl: 'lib/assets/images/download.jpg',
      videoUrl: null, // Add video URL if available
      description: 'High-quality wireless headphones with noise cancellation.',
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
      inStock: true,
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
      price: 39.99,
      discount: null,
      imageUrl: 'lib/assets/images/download.jpeg',
      videoUrl: null,
      description: 'Adjustable laptop stand for better ergonomics.',
      inStock: true,
    ),
    Product(
      id: '6',
      name: 'Wireless Keyboard',
      price: 69.99,
      discount: 0.25,
      imageUrl:
          'lib/assets/images/WhatsApp Image 2025-10-31 at 16.23.33_375c0630.jpg',
      videoUrl: null,
      description: 'Slim wireless keyboard with backlit keys.',
      inStock: true,
    ),
  ];

  final Set<String> _likedProducts = {};
  final Set<String> _cartProducts = {};

  List<Product> get products => _products;
  Set<String> get likedProducts => _likedProducts;
  Set<String> get cartProducts => _cartProducts;

  void toggleLike(String productId) {
    if (_likedProducts.contains(productId)) {
      _likedProducts.remove(productId);
    } else {
      _likedProducts.add(productId);
    }
    notifyListeners();
  }

  void toggleCart(String productId) {
    if (_cartProducts.contains(productId)) {
      _cartProducts.remove(productId);
    } else {
      _cartProducts.add(productId);
    }
    notifyListeners();
  }

  void commentOnProduct(String productId) {
    // Implement comment/review functionality
    // For now, just notify listeners if needed
    notifyListeners();
  }
}
