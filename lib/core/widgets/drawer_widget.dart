import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅ استيراد ملف اللغة
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/build_list_tile.dart';
import 'package:flowmart/pages/my_products_page.dart';
import 'package:flowmart/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. جلب بيانات الثيم
    final themeProvider = Provider.of<ThemeProvider>(context);

    // ✅ 2. جلب بيانات اللغة
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    // 3. تحديد الألوان
    final Color backgroundColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.white;

    final Color headerColor = isDark
        ? const Color(0xFF1A1A1A)
        : isGirlie
            ? const Color(0xFFFF80AB)
            : Colors.blue;

    final Color itemsColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF880E4F)
            : Colors.black;

    return Drawer(
      backgroundColor: backgroundColor,
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;
          final bool isLoggedIn = user != null;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // --- رأس القائمة (Header) ---
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: headerColor),
                      accountName: Text(
                        isLoggedIn
                            ? (user.displayName ??
                                loc.translate('user')) // "مستخدم"
                            : loc.translate('guest'), // "زائر"
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      accountEmail: Text(
                        isLoggedIn
                            ? (user.email ?? "")
                            : loc
                                .translate('welcome'), // "أهلاً بك في FlowMart"
                        style: const TextStyle(color: Colors.white70),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: isLoggedIn
                            ? Text(
                                (user.displayName != null &&
                                        user.displayName!.isNotEmpty)
                                    ? user.displayName!
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : "U",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: headerColor,
                                ),
                              )
                            : Icon(Icons.person, color: headerColor, size: 30),
                      ),
                    ),

                    // --- عناصر القائمة ---
                    BuildListTile(
                      icon: Icons.home,
                      title: loc.translate('home'), // "الرئيسية"
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.home);
                      },
                    ),
                    BuildListTile(
                      icon: Icons.search,
                      title: loc.translate('search'), // "البحث"
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.search);
                      },
                    ),

                    // ✅ زر "منتجاتي"
                    if (isLoggedIn)
                      BuildListTile(
                        icon: Icons.inventory_2_outlined,
                        title: loc.translate('my_products'), // "منتجاتي"
                        color: itemsColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyProductsPage()));
                        },
                      ),

                    // ✅ زر "المحادثات"
                    if (isLoggedIn)
                      BuildListTile(
                        icon: Icons.chat,
                        title: loc.translate('chats'), // "المحادثات"
                        color: itemsColor,
                        onTap: () {
                          Navigator.pop(context);
                          context.push(AppRoutes.chatHistory);
                        },
                      ),

                    // ✅ زر "الإعدادات"
                    BuildListTile(
                      icon: Icons.settings,
                      title: loc.translate('settings'), // "الإعدادات"
                      color: itemsColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()));
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: itemsColor.withOpacity(0.2)),

              // --- زر تسجيل الدخول / الخروج ---
              BuildListTile(
                icon: isLoggedIn ? Icons.logout : Icons.login,
                title: isLoggedIn
                    ? loc.translate('logout') // "تسجيل الخروج"
                    : loc.translate('login'), // "تسجيل الدخول"
                color: isLoggedIn ? Colors.red : itemsColor,
                onTap: () async {
                  Navigator.pop(context);
                  if (isLoggedIn) {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(loc.translate(
                                'logout_confirm'))), // "تم تسجيل الخروج"
                      );
                    }
                  } else {
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
}
