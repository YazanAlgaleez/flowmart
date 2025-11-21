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

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 50.0)),
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
                    hintText: "Username",
                    keyboardType: TextInputType.name,
                  ),
                  Padding(padding: EdgeInsets.only(top: 12.0.h)),
                  PrimaryTextfieldWidget(
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(padding: EdgeInsets.only(top: 12.0.h)),
                  PrimaryTextfieldWidget(
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Padding(padding: EdgeInsets.only(top: 12.0.h)),
                  PrimaryTextfieldWidget(
                    hintText: "Confirm Password",
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Padding(padding: EdgeInsets.only(top: 30.0.h)),
                  PrimaryButtonWidget(
                    buttonText: "Register",
                    onPressed: () {
                      // Handle registration logic here
                    },
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

          const WatermarkWidget(),
        ],
      ),
    );
  }
}
