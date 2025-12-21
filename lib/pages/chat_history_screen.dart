import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:flowmart/core/routing/app_routing.dart'; // تأكد من المسار

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على معرف المستخدم الحالي
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view history")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // سنفترض أن هيكلة البيانات لديك هي: users -> uid -> chats
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('chats')
            .orderBy('timestamp', descending: true) // الأحدث أولاً
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading history"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No chat history found"),
                ],
              ),
            );
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;
              final chatId = chatDocs[index].id;

              // بيانات المحادثة (تعتمد على طريقة حفظك لها)
              final lastMessage = chatData['lastMessage'] ?? 'New Chat';
              final timestamp = chatData['timestamp'] as Timestamp?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.smart_toy), // أيقونة البوت
                  ),
                  title: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    timestamp != null
                        ? _formatDate(timestamp.toDate())
                        : "No Date",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // عند الضغط، نذهب لشاشة الشات ونمرر لها الـ ID لاستكمال المحادثة
                    // context.pushNamed(AppRoutes.chatScreen, extra: chatId);
                    debugPrint("Open chat: $chatId");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} - ${date.hour}:${date.minute}";
  }
}
