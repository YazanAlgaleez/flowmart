import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser; // عشان نميز لونه ومكانه

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // لون أزرق لرسائلي، ورمادي للطرف الآخر
        color: isCurrentUser ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
          bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: isCurrentUser ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
