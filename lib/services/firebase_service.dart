import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  // ✅ التعديل هنا: ربطنا الكود بقاعدة "Flowmart" بدلاً من الافتراضية
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId:
        'Flowmart', // 👈 تأكد أن الاسم يطابق تماماً ما كتبته في الفايربيس (Case Sensitive)
  );

  // 1. إنشاء أو تحديث بيانات المستخدم
  Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    await _db.collection('users').doc(userId).set({
      ...userData,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 2. إضافة اهتمام جديد للمستخدم
  Future<void> addUserInterest(String userId, String category) async {
    try {
      await _db.collection('users').doc(userId).update({
        'interests': FieldValue.arrayUnion([category.toLowerCase()])
      });
      print("✅ Interest Added: $category");
    } catch (e) {
      print("❌ Error adding interest: $e");
    }
  }

  // 3. رفع منتج (يستخدم في صفحة UploadPage)
  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    await _db.collection('products').add({
      ...productData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. جلب المنتجات (يستخدم في صفحة HomePage)
  Stream<QuerySnapshot> getProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
