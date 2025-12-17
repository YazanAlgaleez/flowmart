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

  void _handleRegister() async {
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
            const SnackBar(content: Text("Account Created Successfully!")),
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
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "Register"),
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
                        "Hello ! Register to get             started",
                        style: AppStyles.primaryHeadLineStyle.copyWith(
                          color: isDark
                              ? Colors.white
                              : isGirlie
                                  ? const Color(0xFF8B008B)
                                  : AppStyles.primaryHeadLineStyle.color,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      PrimaryTextfieldWidget(
                        controller: _usernameController,
                        hintText: "Username",
                        keyboardType: TextInputType.name,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      PrimaryTextfieldWidget(
                        controller: _emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val!.contains('@') ? null : "Invalid Email",
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      PrimaryTextfieldWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        keyboardType: TextInputType.visiblePassword,
                      
                        validator: (val) =>
                            val!.length < 6 ? "Min 6 characters" : null,
                      ),
                      Padding(padding: EdgeInsets.only(top: 12.0.h)),
                      PrimaryTextfieldWidget(
                        controller: _confirmPassController,
                        hintText: "Confirm Password",
                        keyboardType: TextInputType.visiblePassword,
                      
                        validator: (val) {
                          if (val!.isEmpty) return "Required";
                          if (val != _passwordController.text) return "No Match";
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.0.h)),
                      isLoading
                          ? const CircularProgressIndicator()
                          : PrimaryButtonWidget(
                              buttonText: "Register",
                              onPressed: _handleRegister,
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
                        mainText: "Or register with social account",
                        promptText: "Already have an account?",
                        buttonText: "Login",
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