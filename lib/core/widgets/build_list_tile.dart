import 'package:flutter/material.dart';

class BuildListTile extends StatelessWidget {
  // 1. تعريف المتغيرات كـ final داخل الكلاس
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const BuildListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 2. إزالة كلمة const لأن القيم هنا متغيرة وليست ثابتة
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
