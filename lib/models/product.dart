import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  // الحقول الإضافية (جعلناها اختيارية لتجنب الأخطاء إذا لم تكن موجودة في الفايربيس)
  final double? discount;
  final String? videoUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.discount,
    this.videoUrl,
    this.inStock = true, // افتراضياً المنتج متوفر
  });

  // 🔹 دالة التحويل من الفايربيس (الأهم)
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'] ?? 'منتج غير معروف',
      // تحويل السعر بأمان سواء كان int أو double في قاعدة البيانات
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '', // هنا سيأتي رابط الصورة من Storage
      description: data['description'] ?? '',

      // التعامل مع الحقول الاختيارية
      discount: data['discount'] != null
          ? (data['discount'] as num).toDouble()
          : null,
      videoUrl: data['videoUrl'],
      inStock: data['inStock'] ?? true,
    );
  }
}
