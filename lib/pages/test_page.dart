import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_outline_button_widgets.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "Test Page"),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
          ? const Color(0xFFFFF0F5)
          : Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                PrimaryButtonWidget(buttonText: "text app"),
                Padding(padding: const EdgeInsets.all(16.0)),

                PrimaryTextfieldWidget(),
                PrimaryOutlineButtonWidgets(),
              ],
            ),
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }
}
