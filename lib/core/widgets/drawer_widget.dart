import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import '../../services/auth_service.dart'; // لم نعد بحاجة له للخروج فقط، يمكننا استخدام Firebase مباشرة

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    final Color backgroundColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
        ? const Color(0xFFFFF0F5)
        : Colors.white;

    final Color headerColor = isDark
        ? const Color(0xFF1A1A1A)
        : isGirlie
        ? const Color(0xFFFF69B4)
        : Colors.blue;

    final Color itemsColor = isDark
        ? Colors.white
        : isGirlie
        ? const Color(0xFF8B008B)
        : Colors.black;

    return Drawer(
      backgroundColor: backgroundColor,
      // 1. هنا أضفنا StreamBuilder لمراقبة حالة المستخدم لحظة بلحظة
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // جلب بيانات المستخدم الحية
          final User? user = snapshot.data;
          final bool isLoggedIn = user != null;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: headerColor),
                      accountName: Text(
                        // 2. تحديث الاسم بناءً على الحالة
                        isLoggedIn
                            ? (user.displayName ?? "No Name")
                            : "Guest User",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      accountEmail: Text(
                        // 3. تحديث الإيميل
                        isLoggedIn ? (user.email ?? "") : "Welcome to FlowMart",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: isLoggedIn
                            ? Text(
                                // التأكد من أن الاسم ليس فارغاً قبل أخذ الحرف الأول
                                (user.displayName != null &&
                                        user.displayName!.isNotEmpty)
                                    ? user.displayName!
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : "U",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: headerColor,
                                ),
                              )
                            : Icon(Icons.person, color: headerColor, size: 30),
                      ),
                    ),
                    _buildListTile(
                      icon: Icons.home,
                      title: 'Home',
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.home);
                      },
                    ),
                    _buildListTile(
                      icon: Icons.search,
                      title: 'Search',
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.search);
                      },
                    ),
                    _buildListTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        // context.go(AppRoutes.settings); // أضف المسار لاحقاً
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: itemsColor.withOpacity(0.2)),

              // 4. زر الدخول/الخروج المتغير
              _buildListTile(
                icon: isLoggedIn ? Icons.logout : Icons.login,
                title: isLoggedIn ? 'Log Out' : 'Log In',
                color: isLoggedIn ? Colors.red : itemsColor,
                onTap: () async {
                  Navigator.pop(context); // إغلاق الـ Drawer

                  if (isLoggedIn) {
                    // تسجيل الخروج
                    await FirebaseAuth.instance.signOut();

                    if (context.mounted) {
                      context.go(AppRoutes.login);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Logged out successfully"),
                        ),
                      );
                    }
                  } else {
                    // الذهاب لتسجيل الدخول
                    context.go(AppRoutes.login);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      onTap: onTap,
    );
  }
}
