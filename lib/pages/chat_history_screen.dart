import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flowmart/core/routing/app_routing.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null)
      return const Scaffold(body: Center(child: Text("يرجى تسجيل الدخول")));

    return Scaffold(
      appBar: AppBar(title: const Text("سجل المحادثات"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instanceFor(
                app: Firebase.app(), databaseId: 'flowmart')
            .collection('users')
            .doc(userId)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("لا توجد محادثات"));

          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;
              final String peerId = chatData['peerId'] ?? '';
              final String peerName = chatData['peerName'] ?? 'مستخدم';
              final Timestamp? timestamp = chatData['timestamp'] as Timestamp?;

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(peerName),
                subtitle: Text(chatData['lastMessage'] ?? ''),
                trailing: Text(timestamp != null
                    ? DateFormat('hh:mm a').format(timestamp.toDate())
                    : ''),
                onTap: () => context.push(AppRoutes.chat, extra: {
                  'receiverUserID': peerId,
                  'receiverUserEmail': peerName,
                }),
              );
            },
          );
        },
      ),
    );
  }
}
