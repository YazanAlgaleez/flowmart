import 'package:email_otp/email_otp.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/pages/forgot_password_page.dart';
import 'package:flowmart/pages/home_page.dart';
import 'package:flowmart/pages/login_page.dart';
import 'package:flowmart/pages/new_password_page.dart'; // 1. تأكد من استدعاء الصفحة هنا
import 'package:flowmart/pages/onBordar_page.dart';
import 'package:flowmart/pages/otp_page.dart';
import 'package:flowmart/pages/register_page.dart';
import 'package:flowmart/pages/search_page.dart';
import 'package:flowmart/pages/test_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
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
      // 2. إضافة التوجيه للصفحة الجديدة
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
    ],
  );
}
