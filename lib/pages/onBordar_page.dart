import 'package:flowmart/core/providers/locale_provider.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_outline_button_widgets.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ إضافة المكتبة

class OnbordarPage extends StatelessWidget {
  const OnbordarPage({super.key});

  // ✅ دالة لحفظ أن المستخدم شاهد الصفحة والانتقال
  Future<void> _finishOnboarding(BuildContext context, String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true); // حفظ العلامة

    if (context.mounted) {
      context.go(route); // الانتقال
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations(localeProvider.locale);

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: AppbarWidget(title: loc.translate('welcome_title')),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: Image.asset(
                  "lib/assets/images/onborderimage.jpeg",
                  width: 375.w,
                  height: 580.h,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20.0)),

              // زر تسجيل الدخول
              PrimaryButtonWidget(
                buttonText: loc.translate('login'),
                onPressed: () {
                  _finishOnboarding(
                      context, AppRoutes.login); // ✅ استخدام الدالة
                },
              ),

              const Padding(padding: EdgeInsets.only(bottom: 16.0)),

              // زر التسجيل
              PrimaryOutlineButtonWidgets(
                buttonText: loc.translate('register'),
                onPressed: () {
                  _finishOnboarding(
                      context, AppRoutes.register); // ✅ استخدام الدالة
                },
              ),
            ],
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
