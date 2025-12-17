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

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool isLoading = false;

  void _handleUpdatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // محاكاة عملية التحديث (لأننا في وضع UI Flow)
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password Changed Successfully! Login now."),
            backgroundColor: Colors.green,
          ),
        );
        // العودة لصفحة تسجيل الدخول لإكمال الدورة
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: const AppbarWidget(title: "New Password"),
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
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
                      "Reset Password",
                      style: AppStyles.primaryHeadLineStyle.copyWith(
                        color: isDark
                            ? Colors.white
                            : isGirlie
                                ? const Color(0xFF8B008B)
                                : AppStyles.primaryHeadLineStyle.color,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "Please enter your new password securely.",
                        textAlign: TextAlign.center,
                        style: AppStyles.supTitleStyle.copyWith(
                          color: isDark ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.only(top: 40.0)),

                    // حقل كلمة السر الجديدة
                    PrimaryTextfieldWidget(
                      controller: _passController,
                      hintText: "New Password",
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) =>
                          val!.length < 6 ? "Min 6 characters" : null,
                    ),

                    const Padding(padding: EdgeInsets.only(top: 20.0)),

                    // حقل تأكيد كلمة السر
                    PrimaryTextfieldWidget(
                      controller: _confirmController,
                      hintText: "Confirm Password",
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val!.isEmpty) return "Required";
                        if (val != _passController.text)
                          return "Passwords do not match";
                        return null;
                      },
                    ),

                    const Padding(padding: EdgeInsets.only(top: 40.0)),

                    isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButtonWidget(
                            buttonText: "Update Password",
                            onPressed: _handleUpdatePassword,
                          ),
                  ],
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
