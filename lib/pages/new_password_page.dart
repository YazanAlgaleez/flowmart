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

  // ✅ تمرير loc لاستخدام الترجمة في التنبيهات
  void _handleUpdatePassword(AppLocalizations loc) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // محاكاة عملية التحديث
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('pass_changed_success')), // "تم تغيير كلمة المرور..."
            backgroundColor: Colors.green,
          ),
        );
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
    final localeProvider = Provider.of<LocaleProvider>(context); // ✅
    final loc = AppLocalizations(localeProvider.locale); // ✅

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Scaffold(
      appBar: AppbarWidget(title: loc.translate('new_password_title')), // "كلمة المرور الجديدة"
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
                      loc.translate('reset_password'), // "إعادة تعيين كلمة المرور"
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
                        loc.translate('new_pass_msg'), // "يرجى إدخال كلمة المرور الجديدة..."
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
                      hintText: loc.translate('new_pass_hint'), // "كلمة المرور الجديدة"
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) => val!.length < 6
                          ? loc.translate('pass_min_length') // "6 أحرف على الأقل"
                          : null,
                    ),

                    const Padding(padding: EdgeInsets.only(top: 20.0)),

                    // حقل تأكيد كلمة السر
                    PrimaryTextfieldWidget(
                      controller: _confirmController,
                      hintText: loc.translate('confirm_pass_hint'), // "تأكيد كلمة المرور"
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val!.isEmpty) return loc.translate('required'); // "مطلوب"
                        if (val != _passController.text) {
                          return loc.translate('pass_mismatch'); // "كلمتا المرور غير متطابقتين"
                        }
                        return null;
                      },
                    ),

                    const Padding(padding: EdgeInsets.only(top: 40.0)),

                    isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButtonWidget(
                            buttonText: loc.translate('update_pass_btn'), // "تحديث كلمة المرور"
                            onPressed: () => _handleUpdatePassword(loc),
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