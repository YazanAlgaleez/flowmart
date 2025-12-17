import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flowmart/core/widgets/social_login_sction.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      String? result = await AuthService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (result == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Login Successful!")));
          context.go(AppRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _handleGoogleLogin() async {
    setState(() => isLoading = true);
    final user = await AuthService().signIn(email: '', password: '');
    setState(() => isLoading = false);

    if (user != null) {
      if (mounted) context.go(AppRoutes.home);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Google Sign In Failed")));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "Login"),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
          ? const Color(0xFFFFF0F5)
          : Colors.white,
      body: Positioned.fill(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 50.0)),
                      Text(
                        "Welcome back!              Again",
                        style: AppStyles.primaryHeadLineStyle.copyWith(
                          color: isDark
                              ? Colors.white
                              : isGirlie
                              ? const Color(0xFF8B008B)
                              : AppStyles.primaryHeadLineStyle.color,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),

                      PrimaryTextfieldWidget(
                        controller: _emailController,
                        hintText: "Enter Your Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val!.contains('@') ? null : "Invalid Email",
                      ),

                      Padding(padding: EdgeInsets.only(top: 20.0)),

                      PrimaryTextfieldWidget(
                        controller: _passwordController,
                        hintText: "Enter Your Password",
                        keyboardType: TextInputType.visiblePassword,

                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),

                      Padding(padding: EdgeInsets.only(top: 30.0.h)),

                      isLoading
                          ? const CircularProgressIndicator()
                          : PrimaryButtonWidget(
                              buttonText: "Login",
                              onPressed: _handleLogin,
                            ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.go(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
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
                      SocialLoginSection(
                        mainText: "Or login with social account",
                        promptText: "Don't have an account?",
                        buttonText: "Register",
                        onButtonPressed: () {
                          context.go(AppRoutes.register);
                        },
                        // تأكد أنك عدلت SocialLoginSection لتستقبل هذا
                        // onGooglePressed: _handleGoogleLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const WatermarkWidget(),
          ],
        ),
      ),
    );
  }
}
