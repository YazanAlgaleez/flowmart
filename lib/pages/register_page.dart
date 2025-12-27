import 'package:flowmart/core/providers/locale_provider.dart'; // ✅
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flowmart/core/widgets/social_login_sction.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flowmart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool isLoading = false;

  // ✅ تمرير loc لاستخدام الترجمة في التنبيهات
  void _handleRegister(AppLocalizations loc) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      String? result = await AuthService().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );

      setState(() => isLoading = false);

      if (result == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(loc.translate('account_created'))), // "تم إنشاء الحساب بنجاح"
          );
          context.go(AppRoutes.login);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
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
      appBar: AppbarWidget(title: loc.translate('register')), // "تسجيل"
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 50.0)),
                      Text(
                        loc.translate('register_welcome'), // "مرحباً! سجل لتبدأ"
                        textAlign: TextAlign.center,
                        style: AppStyles.primaryHeadLineStyle.copyWith(
                          color: isDark
                              ? Colors.white
                              : isGirlie
                                  ? const Color(0xFF8B008B)
                                  : AppStyles.primaryHeadLineStyle.color,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      
                      // حقل اسم المستخدم
                      PrimaryTextfieldWidget(
                        controller: _usernameController,
                        hintText: loc.translate('username'), // "اسم المستخدم"
                        keyboardType: TextInputType.name,
                        validator: (val) =>
                            val!.isEmpty ? loc.translate('required') : null, // "مطلوب"
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      
                      // حقل الإيميل
                      PrimaryTextfieldWidget(
                        controller: _emailController,
                        hintText: loc.translate('enter_email'), // "أدخل الإيميل"
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.contains('@')
                            ? null
                            : loc.translate('invalid_email'), // "إيميل غير صحيح"
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      
                      // حقل كلمة المرور
                      PrimaryTextfieldWidget(
                        controller: _passwordController,
                        hintText: loc.translate('password'), // "كلمة المرور"
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) => val!.length < 6
                            ? loc.translate('pass_min_length') // "6 أحرف على الأقل"
                            : null,
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      
                      // حقل تأكيد كلمة المرور
                      PrimaryTextfieldWidget(
                        controller: _confirmPassController,
                        hintText: loc.translate('confirm_pass_hint'), // "تأكيد كلمة المرور"
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) {
                          if (val!.isEmpty) return loc.translate('required');
                          if (val != _passwordController.text) {
                            return loc.translate('pass_no_match'); // "غير متطابقتين"
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.0.h)),
                      
                      isLoading
                          ? const CircularProgressIndicator()
                          : PrimaryButtonWidget(
                              buttonText: loc.translate('register'), // "إنشاء حساب"
                              onPressed: () => _handleRegister(loc),
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
                              loc.translate('home_pages'), // "الصفحة الرئيسية"
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SocialLoginSection(
                        mainText: loc.translate('or_register_social'), // "أو سجل عبر..."
                        promptText: loc.translate('have_account'), // "لديك حساب؟"
                        buttonText: loc.translate('login'), // "دخول"
                        onButtonPressed: () {
                          context.go(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}