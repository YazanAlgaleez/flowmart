import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flowmart/widgets/social_login_sction.dart';
import 'package:flowmart/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 50.0)),
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
                    hintText: "Enter Your Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  PrimaryTextfieldWidget(
                    hintText: "Enter Your Password",
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Padding(padding: EdgeInsets.only(top: 30.0.h)),
                  PrimaryButtonWidget(buttonText: "Login", onPressed: () {}),
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
                  ),

                  const WatermarkWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
