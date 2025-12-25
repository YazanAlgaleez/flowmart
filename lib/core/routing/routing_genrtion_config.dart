// 📂 المسار: lib/core/routing/app_routing.dart

import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flutter/material.dart'; // ✅ ضروري جداً من أجل GlobalKey
import 'package:email_otp/email_otp.dart';
import 'package:go_router/go_router.dart';

// استدعاء ملف الثوابت

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

class AppRouter {
  // ✅ 1. تعريف مفتاح التنقل العام (Global Key)
  // هذا المفتاح سيسمح لنا بالوصول للنافجيتر من أي مكان في التطبيق (بما في ذلك الزر العائم)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // ✅ 2. ربط المفتاح بالراوتر
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
          return ChatPage(
            receiverUserID: map['id'] ?? '',
            receiverUserEmail: map['name'] ?? map['email'] ?? 'Unknown',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.upload,
        builder: (context, state) => UploadPage(),
      ),
    ],
  );
}
