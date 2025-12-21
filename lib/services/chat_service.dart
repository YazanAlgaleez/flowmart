import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // الحصول على نسخة من الفايربيز
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إرسال رسالة
  Future<void> sendMessage(String receiverId, String message) async {
    // 1. معرفة مين اللي بيبعت (المستخدم الحالي)
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // 2. إنشاء كائن الرسالة
    Map<String, dynamic> newMessage = {
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };

    // 3. إنشاء معرف غرفة محادثة فريد (ترتيب الايديهات عشان يكون نفسه للطرفين)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // ترتيب أبجدي لضمان التوافق
    String chatRoomId = ids.join("_"); // مثال: user1_user2

    // 4. حفظ الرسالة في الداتابيس
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage);
  }

  // استقبال الرسائل (بث مباشر)
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // بناء نفس معرف الغرفة
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // ترتيب حسب الوقت
        .snapshots();
  }
}
