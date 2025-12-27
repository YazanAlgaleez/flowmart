import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅ استيراد ملف اللغة

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // ✅ استدعاء الترجمة
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // الألوان
    final bgColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.white;
    final textColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF880E4F)
            : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(loc.translate('my_products'), // "منتجاتي"
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
        centerTitle: true,
      ),
      body: user == null
          ? Center(
              child: Text(loc.translate('login_required'), // "تسجيل الدخول مطلوب"
                  style: TextStyle(color: textColor)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instanceFor(
                      app: Firebase.app(), databaseId: 'flowmart')
                  .collection('products')
                  .where('sellerId', isEqualTo: user.uid)
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
                        Icon(Icons.inventory_2_outlined,
                            size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text(loc.translate('no_my_products'), // "لم تقم بنشر أي منتجات"
                            style: TextStyle(color: textColor)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        children: [
                          // صورة المنتج
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              data['imageUrl'] ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey,
                                  child: const Icon(Icons.error)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // تفاصيل المنتج
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['name'] ?? loc.translate('unknown'), // "غير معروف"
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: textColor)),
                                const SizedBox(height: 5),
                                Text("${data['price']} ${loc.translate('jod')}", // "دينار"
                                    style: TextStyle(
                                        color:
                                            isGirlie ? Colors.pink : Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          // زر الحذف
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () async {
                              bool confirm = await showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                      title: Text(loc.translate('delete')), // "حذف"
                                      content: Text(
                                          loc.translate('delete_product_confirm')), // "هل أنت متأكد؟"
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(c, false),
                                            child: Text(loc.translate('cancel'))), // "إلغاء"
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(c, true),
                                            child: Text(loc.translate('delete'), // "حذف"
                                                style: const TextStyle(
                                                    color: Colors.red))),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (confirm) {
                                await doc.reference.delete();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}