import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // دالة الحذف
  Future<void> _deleteAccount(AppLocalizations loc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
                loc.translate('delete_confirm_title')), // "حذف الحساب نهائياً؟"
            content: Text(loc.translate('delete_confirm_msg')), // "تحذير..."
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(loc.translate('cancel_btn'))), // "تراجع"
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(loc.translate('delete_btn')), // "نعم، احذف"
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        await user.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.translate('delete_success_msg'))));
          context.go(AppRoutes.login);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${loc.translate('delete_fail_msg')}$e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // ✅ استدعاء بروفايدر اللغة
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);
    final user = FirebaseAuth.instance.currentUser;

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    final Color bgColor = isDark
        ? const Color(0xFF0D0D0D)
        : isGirlie
            ? const Color(0xFFFFF0F5)
            : Colors.grey[50]!;

    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final Color textColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF880E4F)
            : Colors.black87;

    final Color accentColor = isDark
        ? Colors.redAccent
        : isGirlie
            ? const Color(0xFFFF4081)
            : AppColors.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(loc.translate('settings_title'), // "الإعدادات"
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 قسم البروفايل
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1)
                ],
              ),
              child: user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: accentColor.withOpacity(0.1),
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? Icon(Icons.person, size: 45, color: accentColor)
                              : null,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          user.displayName ?? loc.translate('user'),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        Text(
                          user.email ?? "",
                          style: TextStyle(color: textColor.withOpacity(0.6)),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Icon(Icons.account_circle_outlined,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(loc.translate('guest_user'),
                            style: TextStyle(color: textColor)),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () => context.push(AppRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(loc.translate('guest_login_btn'),
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 25),

            // 🎨 قسم المظهر واللغة
            _buildSectionHeader(loc.translate('appearance_app'), textColor),

            // 1. ثيم التطبيق
            _buildSettingsTile(
              icon: Icons.palette_outlined,
              title: loc.translate('app_theme'),
              textColor: textColor,
              cardColor: cardColor,
              trailing: DropdownButton<AppTheme>(
                value: themeProvider.currentTheme,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                underline: Container(),
                icon: Icon(Icons.keyboard_arrow_down, color: accentColor),
                items: [
                  DropdownMenuItem(
                      value: AppTheme.light,
                      child: Text(loc.translate('theme_light'))),
                  DropdownMenuItem(
                      value: AppTheme.dark,
                      child: Text(loc.translate('theme_dark'))),
                  DropdownMenuItem(
                      value: AppTheme.girlie,
                      child: Text(loc.translate('theme_girlie'))),
                ],
                onChanged: (val) {
                  if (val != null) themeProvider.setTheme(val);
                },
              ),
            ),

            // 2. اللغة (Language) - ✅ هنا يتم التغيير
            _buildSettingsTile(
              icon: Icons.language,
              title: loc.translate('language_label'), // "اللغة"
              textColor: textColor,
              cardColor: cardColor,
              trailing: DropdownButton<String>(
                value: localeProvider.locale.languageCode, // 'ar' or 'en'
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                underline: Container(),
                icon: Icon(Icons.keyboard_arrow_down, color: accentColor),
                items: [
                  DropdownMenuItem(
                      value: 'ar',
                      child: Text(loc.translate('lang_ar'))), // "العربية"
                  DropdownMenuItem(
                      value: 'en',
                      child: Text(loc.translate('lang_en'))), // "English"
                ],
                onChanged: (val) {
                  if (val != null) {
                    // ✅ تغيير اللغة فوراً
                    localeProvider.setLocale(Locale(val));
                  }
                },
              ),
            ),

            // ⚠️ قسم الحساب
            if (user != null) ...[
              const SizedBox(height: 25),
              _buildSectionHeader(loc.translate('account_section'), textColor),
              _buildSettingsTile(
                icon: Icons.logout_rounded,
                title: loc.translate('logout_title'),
                textColor: textColor,
                cardColor: cardColor,
                iconColor: Colors.orange,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) context.go(AppRoutes.login);
                },
              ),
              _buildSettingsTile(
                icon: Icons.delete_forever_rounded,
                title: loc.translate('delete_acc_title'),
                textColor: Colors.red,
                cardColor: cardColor,
                iconColor: Colors.red,
                onTap: () => _deleteAccount(loc),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Widgets مساعدة ---
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color textColor,
    required Color cardColor,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? textColor).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? textColor, size: 22),
        ),
        title: Text(title,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: textColor.withOpacity(0.3)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
