import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // ضروري لـ instanceFor
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ✅ الاتصال بقاعدة البيانات المخصصة flowmart
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'flowmart',
  );

  Future<void> sendMessage(
      String receiverId, String message, String receiverName) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // 1. إنشاء كائن الرسالة
    Map<String, dynamic> newMessage = {
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };

    // 2. إنشاء معرف غرفة المحادثة
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // 3. حفظ الرسالة في الغرفة
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage);

    // 4. ✅ تحديث "سجل المحادثات" عند المرسل والمستقبل
    // لضمان ظهور المحادثة في قائمة ChatHistoryScreen
    await _updateChatHistory(
        currentUserId, receiverId, receiverName, message, timestamp);
    await _updateChatHistory(receiverId, currentUserId,
        currentUserEmail.split('@')[0], message, timestamp);
  }

  // دالة مساعدة لتحديث السجل
  Future<void> _updateChatHistory(String ownerId, String peerId,
      String peerName, String lastMsg, Timestamp time) async {
    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('chats')
        .doc(peerId) // نستخدم ID الطرف الآخر كـ Doc ID ليسهل الوصول إليه
        .set({
      'peerId': peerId,
      'peerName': peerName,
      'lastMessage': lastMsg,
      'timestamp': time,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
