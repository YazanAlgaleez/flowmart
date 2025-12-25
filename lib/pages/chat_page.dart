import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowmart/core/providers/theme_provider.dart'; // ✅ تأكد من المسار
import 'package:flowmart/core/styling/app_themes.dart'; // ✅ تأكد من المسار لـ AppTheme Enum
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // ✅ ضروري للوصول للثيم
import '../services/chat_service.dart';
import '../core/widgets/chat_bubble.dart';

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
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text.trim(),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 1. الوصول للثيم الحالي
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;

    // ✅ 2. تحديد الألوان بناءً على الثيم
    final bool isDark = currentTheme == AppTheme.dark;
    final bool isGirlie = currentTheme == AppTheme.girlie;

    // اللون الرئيسي: وردي للـ Girlie، وأزرق للباقي
    final Color mainColor = isGirlie ? Colors.pink : Colors.blueAccent;

    // لون خلفية فقاعة "الطرف الآخر"
    final Color receiverBubbleColor = isDark
        ? Colors.grey[800]!
        : (isGirlie ? Colors.pink[50]! : Colors.grey[200]!);

    return Scaffold(
      // الخلفية تؤخذ تلقائياً من ThemeData الذي عرفته في AppThemes
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: mainColor.withOpacity(0.2),
              backgroundImage:
                  const AssetImage('assets/images/user_placeholder.png'),
              child: Icon(Icons.person, color: mainColor),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverUserEmail.split('@')[0],
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                Text('Online',
                    style: TextStyle(color: Colors.green, fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // عرض بطاقة المنتج
          if (widget.productDetails != null)
            _buildProductCard(isDark, mainColor),

          // قائمة الرسائل
          Expanded(
            child: _buildMessageList(mainColor, receiverBubbleColor, isDark),
          ),

          // حقل الإدخال
          _buildMessageInput(isDark, mainColor),
        ],
      ),
    );
  }

  // 🔥 بطاقة المنتج
  Widget _buildProductCard(bool isDark, Color mainColor) {
    final product = widget.productDetails!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : mainColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              product['image'] ?? '',
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "بخصوص: ${product['name']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${product['price']} JOD",
                  style: TextStyle(
                    color: mainColor, // ✅ السعر يأخذ لون الثيم
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      Color mainColor, Color receiverBubbleColor, bool isDark) {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        SchedulerBinding.instance
            .addPostFrameCallback((_) => _scrollToBottom());

        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(
                  doc, mainColor, receiverBubbleColor, isDark))
              .toList(),
        );
      },
    );
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
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              // ✅ لون الفقاعة يعتمد على الثيم المختار
              color: isCurrentUser ? mainColor : receiverBubbleColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              data['message'],
              style: TextStyle(
                // النص أبيض إذا أنا المرسل، أو إذا كان الوضع ليلي
                // أسود إذا كان الطرف الآخر والوضع فاتح/جيرلي
                color: isCurrentUser
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
                fontSize: 15.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h, left: 4.w, right: 4.w),
            child: Text(formattedTime,
                style: TextStyle(color: Colors.grey, fontSize: 10.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark, Color mainColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_photo_alternate, color: mainColor)),
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: sendMessage,
              child: CircleAvatar(
                backgroundColor: mainColor, // ✅ زر الإرسال يأخذ لون الثيم
                child: Icon(Icons.send, color: Colors.white, size: 20.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
