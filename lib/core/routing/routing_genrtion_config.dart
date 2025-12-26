// 📂 المسار: lib/core/routing/app_routing.dart

import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:go_router/go_router.dart';

// ✅ تم حذف سطر الاستيراد المتعارض

// استدعاء الصفحات
import 'package:flowmart/pages/chat_history_screen.dart';
import 'package:flowmart/pages/chat_page.dart';
import 'package:flowmart/pages/forgot_password_page.dart';
import 'package:flowmart/pages/home_page.dart';
import 'package:flowmart/pages/login_page.dart';
import 'package:flowmart/pages/new_password_page.dart';
import 'package:flowmart/pages/onBordar_page.dart';
import 'package:flowmart/pages/otp_page.dart';
import 'package:flowmart/pages/register_page.dart';
import 'package:flowmart/pages/search_page.dart';
import 'package:flowmart/pages/test_page.dart';
import 'package:flowmart/pages/upload_page.dart';

// ✅ أضف كلاس AppRoutes هنا إذا لم يكن موجوداً في ملف منفصل
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgotPassword';
  static const String chatHistory = '/chatHistory';
  static const String newPassword = '/newPassword';
  static const String test = '/test';
  static const String search = '/search';
  static const String spacingWidgets = '/spacingWidgets';
  static const String chat = '/chat';
  static const String upload = '/upload';
}

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnbordarPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final myAuth = state.extra as EmailOTP;
          return OtpPage(myAuth: myAuth);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.chatHistory,
        builder: (context, state) => const ChatHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        builder: (context, state) => const NewPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.test,
        builder: (context, state) => const TestPage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.spacingWidgets,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>? ?? {};
          // ✅ التأكد من جلب المفاتيح الصحيحة التي نرسلها من HomePage
          return ChatPage(
            receiverUserID: map['receiverUserID'] ?? map['id'] ?? '',
            receiverUserEmail:
                map['receiverUserEmail'] ?? map['name'] ?? 'ناشر',
            productDetails:
                map['productDetails'], // إضافة تفاصيل المنتج إذا وجدت
          );
        },
      ),
      GoRoute(
        path: AppRoutes.upload,
        builder: (context, state) => const UploadPage(),
      ),
    ],
  );
}
