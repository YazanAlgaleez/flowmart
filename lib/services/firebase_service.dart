import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'flowmart',
  );

  Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    await _db.collection('users').doc(userId).set({
      ...userData,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addUserInterest(String userId, String category) async {
    try {
      await _db.collection('users').doc(userId).update({
        'interests': FieldValue.arrayUnion([category.toLowerCase()])
      });
    } catch (e) {
      await _db.collection('users').doc(userId).set({
        'interests': [category.toLowerCase()]
      }, SetOptions(merge: true));
    }
  }

  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    final user = FirebaseAuth.instance.currentUser;
    await _db.collection('products').add({
      ...productData,
      'sellerId': user?.uid,
      'sellerName': user?.displayName ?? user?.email?.split('@')[0],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
