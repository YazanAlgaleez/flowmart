import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ✅ استيراد ملفات اللغة والثيم
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/providers/locale_provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. إعدادات الثيم
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // 2. ✅ إعدادات اللغة (الجديد)
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale); // كائن الترجمة

    // تعريف الألوان
    final Color bgColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.white;
    final Color textColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF880E4F)
            : Colors.black87;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color accentColor = isDark
        ? Colors.blueAccent
        : isGirlie
            ? const Color(0xFFFF4081)
            : Colors.blue;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Center(
            child: Text(
          loc.translate('login_required'), // ✅ ترجمة: يرجى تسجيل الدخول
          style: TextStyle(color: textColor),
        )),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          loc.translate('chat_history'), // ✅ ترجمة: سجل المحادثات
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // الاتصال بقاعدة flowmart
        stream: FirebaseFirestore.instanceFor(
                app: Firebase.app(), databaseId: 'flowmart')
            .collection('users')
            .doc(userId)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    loc.translate('no_chats'), // ✅ ترجمة: لا توجد محادثات
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            );
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;
              final String peerId = chatData['peerId'] ?? '';
              
              // ✅ ترجمة الاسم الافتراضي إذا كان فارغاً
              final String peerName = chatData['peerName'] ?? loc.translate('user');
              
              final String lastMsg = chatData['lastMessage'] ?? '';
              final Timestamp? timestamp = chatData['timestamp'] as Timestamp?;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: accentColor.withOpacity(0.1),
                    child: Icon(Icons.person, color: accentColor),
                  ),
                  title: Text(peerName,
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor.withOpacity(0.6)),
                  ),
                  trailing: Text(
                    timestamp != null
                        // ✅ جعل الوقت يظهر حسب لغة التطبيق (AM/PM أو ص/م)
                        ? DateFormat('hh:mm a', localeProvider.locale.languageCode)
                            .format(timestamp.toDate())
                        : '',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () => context.push(AppRoutes.chat, extra: {
                    'receiverUserID': peerId,
                    'receiverUserEmail': peerName,
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}