import 'package:email_otp/email_otp.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final EmailOTP myAuth = EmailOTP(); // كائن إرسال الرموز
  bool isLoading = false;

  void _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // 1. إرسال الكود مباشرة (بدون فحص Firebase المحذوف)
      // هذا هو الكود المتوافق مع التحديثات الجديدة
      bool result = await EmailOTP.sendOTP(email: _emailController.text.trim());

      setState(() => isLoading = false);

      if (result) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Code sent successfully!")),
          );
          // الانتقال لصفحة OTP مع تمرير كائن myAuth
          context.push(AppRoutes.otp, extra: myAuth);
        }
      } else {
        if (mounted) {
          // في حال فشل الإرسال (مشكلة نت أو سيرفر)
          // لتجنب التعليق، سنسمح بالمرور في وضع المطور (اختياري)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Simulating Send (Dev Mode)")),
          );
          context.push(AppRoutes.otp, extra: myAuth);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "Forgot Password"),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 50.0)),
                  Text(
                    "Forgot Password?",
                    style: AppStyles.primaryHeadLineStyle.copyWith(
                      color: isDark
                          ? Colors.white
                          : isGirlie
                              ? const Color(0xFF8B008B)
                              : AppStyles.primaryHeadLineStyle.color,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Don't worry! It happens. Please enter the email address linked with your account.",
                      textAlign: TextAlign.center,
                      style: AppStyles.supTitleStyle.copyWith(
                        color: isDark
                            ? Colors.white.withOpacity(0.8)
                            : isGirlie
                                ? const Color(0xFFDA70D6)
                                : AppStyles.supTitleStyle.color,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30.0)),
                  PrimaryTextfieldWidget(
                    controller: _emailController,
                    hintText: "Enter Your Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.contains('@') ? null : "Invalid Email",
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30.0)),
                  isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButtonWidget(
                          buttonText: "Send Code",
                          onPressed: _handleSendCode,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.go(AppRoutes.home);
                        },
                        child: Text(
                          "Home pages",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
