import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_outline_button_widgets.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OnbordarPage extends StatelessWidget {
  const OnbordarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "Welcome"),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
          ? const Color(0xFFFFF0F5)
          : Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: Image.asset(
                  "lib/assets/images/WhatsApp Image 2025-10-31 at 16.23.33_375c0630.jpg",
                  width: 375.w,
                  height: 580.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: const EdgeInsets.only(bottom: 20.0)),
              PrimaryButtonWidget(buttonText: "Login"),
              Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              PrimaryOutlineButtonWidgets(buttonText: "Register"),
            ],
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
