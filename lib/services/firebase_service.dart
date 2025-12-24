import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. إنشاء أو تحديث بيانات المستخدم (يستدعى عند تسجيل الدخول)
  Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    await _db.collection('users').doc(userId).set({
      ...userData,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge: عشان ما نحذف الاهتمامات القديمة
  }

  // 2. الوظيفة الذكية: إضافة اهتمام جديد للمستخدم
  // هذه الدالة رح نستخدمها لما يعمل لايك أو يطول في الصفحة
  Future<void> addUserInterest(String userId, String category) async {
    try {
      await _db.collection('users').doc(userId).update({
        // arrayUnion: بتضيف الاهتمام بس اذا مش موجود (عشان ما يتكرر)
        'interests': FieldValue.arrayUnion([category.toLowerCase()])
      });
      print("✅ Interest Added: $category");
    } catch (e) {
      print("❌ Error adding interest: $e");
    }
  }

  // 3. رفع منتج (للأدمن أو للتجربة حالياً)
  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    await _db.collection('products').add({
      ...productData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. جلب المنتجات (للعرض)
  Stream<QuerySnapshot> getProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
