import 'package:email_otp/email_otp.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅
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
  final EmailOTP myAuth = EmailOTP();
  bool isLoading = false;

  // ✅ نمرر loc للدالة لاستخدام الترجمة في الرسائل
  void _handleSendCode(AppLocalizations loc) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      bool result = await EmailOTP.sendOTP(email: _emailController.text.trim());

      setState(() => isLoading = false);

      if (result) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.translate('code_sent'))), // ✅ تم الترجمة
          );
          context.push(AppRoutes.otp, extra: myAuth);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.translate('simulating_send'))), // ✅ تم الترجمة
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
    final localeProvider = Provider.of<LocaleProvider>(context); // ✅
    final loc = AppLocalizations(localeProvider.locale); // ✅

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: AppbarWidget(title: loc.translate('forgot_password')), // ✅ تم الترجمة
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
                    loc.translate('forgot_password'), // ✅ تم الترجمة
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
                      loc.translate('forgot_pass_msg'), // ✅ تم الترجمة
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
                    hintText: loc.translate('enter_email'), // ✅ تم الترجمة
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.contains('@') ? null : loc.translate('invalid_email'), // ✅ تم الترجمة
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30.0)),
                  isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButtonWidget(
                          buttonText: loc.translate('send_code'), // ✅ تم الترجمة
                          onPressed: () => _handleSendCode(loc), // مررنا loc هنا
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
                          loc.translate('home_pages'), // ✅ تم الترجمة
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