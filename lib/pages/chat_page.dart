import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ أضفنا هذا للاتصال بـ flowmart
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final Map<String, dynamic>? productDetails;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    this.productDetails,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  // ✅ تعديل دالة الإرسال لتدعم السجل والاسم
  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      String messageText = _messageController.text.trim();
      _messageController.clear(); // مسح الحقل فوراً لتجربة مستخدم أفضل

      // استخراج الاسم من الإيميل (أو اسم الناشر)
      String receiverName = widget.receiverUserEmail.split('@')[0];

      await _chatService.sendMessage(
        widget.receiverUserID,
        messageText,
        receiverName, // مررنا الاسم ليحفظ في سجل المحادثات
      );

      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;
    final bool isDark = currentTheme == AppTheme.dark;
    final bool isGirlie = currentTheme == AppTheme.girlie;
    final Color mainColor = isGirlie ? Colors.pink : Colors.blueAccent;
    final Color receiverBubbleColor = isDark
        ? Colors.grey[800]!
        : (isGirlie ? Colors.pink[50]! : Colors.grey[200]!);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: mainColor.withOpacity(0.2),
              child: Icon(Icons.person, color: mainColor),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverUserEmail.split('@')[0], // اسم الناشر
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                Text('متصل الآن',
                    style: TextStyle(color: Colors.green, fontSize: 11.sp)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (widget.productDetails != null)
            _buildProductCard(isDark, mainColor),
          Expanded(
            child: _buildMessageList(mainColor, receiverBubbleColor, isDark),
          ),
          _buildMessageInput(isDark, mainColor),
        ],
      ),
    );
  }

  // 🔥 بطاقة المنتج (التي تظهر في أعلى المحادثة)
  Widget _buildProductCard(bool isDark, Color mainColor) {
    final product = widget.productDetails!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: mainColor.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              product['image'] ?? '',
              width: 45.w,
              height: 45.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.image, color: Colors.grey),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("بخصوص: ${product['name']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13.sp)),
                Text("${product['price']} JOD",
                    style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      Color mainColor, Color receiverBubbleColor, bool isDark) {
    // ✅ القراءة من قاعدة flowmart مباشرة
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'flowmart',
      )
          .collection('chat_rooms')
          .doc(_getChatRoomId(
              widget.receiverUserID, _firebaseAuth.currentUser!.uid))
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Center(child: Text('حدث خطأ في تحميل الرسائل'));
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());

        SchedulerBinding.instance
            .addPostFrameCallback((_) => _scrollToBottom());

        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.all(12.w),
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(
                  doc, mainColor, receiverBubbleColor, isDark))
              .toList(),
        );
      },
    );
  }

  // دالة مساعدة للحصول على معرف الغرفة (نفس المنطق في الخدمة)
  String _getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join("_");
  }

  Widget _buildMessageItem(DocumentSnapshot document, Color mainColor,
      Color receiverBubbleColor, bool isDark) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isCurrentUser = (data['senderId'] == _firebaseAuth.currentUser!.uid);
    Timestamp? timestamp = data['timestamp'];
    String formattedTime = timestamp != null
        ? DateFormat('hh:mm a').format(timestamp.toDate())
        : '';

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isCurrentUser ? mainColor : receiverBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isCurrentUser ? Radius.circular(16.r) : Radius.zero,
                bottomRight:
                    isCurrentUser ? Radius.zero : Radius.circular(16.r),
              ),
            ),
            child: Text(
              data['message'],
              style: TextStyle(
                color: isCurrentUser
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
                fontSize: 14.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h, left: 4.w, right: 4.w),
            child: Text(formattedTime,
                style: TextStyle(color: Colors.grey, fontSize: 9.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark, Color mainColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_circle_outline, color: mainColor)),
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                onSubmitted: (_) => sendMessage(),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: sendMessage,
              child: CircleAvatar(
                backgroundColor: mainColor,
                child: Icon(Icons.send, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
