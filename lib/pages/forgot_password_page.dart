import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 50.0)),
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
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text(
                "Don't worry! itc occurs, Please enter the email address linked with you account.  ",
                style: AppStyles.supTitleStyle.copyWith(
                  color: isDark
                      ? Colors.white.withOpacity(0.8)
                      : isGirlie
                      ? const Color(0xFFDA70D6)
                      : AppStyles.supTitleStyle.color,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter Your Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              PrimaryButtonWidget(
                buttonText: "Send Code",
                onPressed: () {
                  // Handle reset link logic here
                  print("Reset link sent");
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
            ],
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
