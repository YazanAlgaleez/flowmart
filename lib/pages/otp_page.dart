import 'package:email_otp/email_otp.dart';
import 'package:flowmart/core/providers/locale_provider.dart'; // ✅
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final EmailOTP myAuth;
  const OtpPage({super.key, required this.myAuth});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();
  final TextEditingController _c3 = TextEditingController();
  final TextEditingController _c4 = TextEditingController();

  final FocusNode _f1 = FocusNode();
  final FocusNode _f2 = FocusNode();
  final FocusNode _f3 = FocusNode();
  final FocusNode _f4 = FocusNode();

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose(); _c4.dispose();
    _f1.dispose(); _f2.dispose(); _f3.dispose(); _f4.dispose();
    super.dispose();
  }

  // ✅ تمرير loc لاستخدام الترجمة
  void _verifyOtp(AppLocalizations loc) {
    String otpCode = "${_c1.text}${_c2.text}${_c3.text}${_c4.text}";

    // التحقق اليدوي (Dev Mode Bypass: 1234)
    if (otpCode == "1234") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('otp_verified')), // "تم التحقق بنجاح"
            backgroundColor: Colors.green,
          ),
        );
        context.push(AppRoutes.newPassword);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('otp_invalid')), // "رمز غير صحيح"
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context); // ✅
    final loc = AppLocalizations(localeProvider.locale); // ✅

    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    final Color textColor = isDark
        ? Colors.white
        : isGirlie
            ? const Color(0xFF8B008B)
            : Colors.black;

    return Scaffold(
      appBar: AppbarWidget(title: loc.translate('otp_title')), // "التحقق من الرمز"
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
              ? const Color(0xFFFFF0F5)
              : Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 50.0)),
                Text(
                  loc.translate('email_verification'), // "تأكيد البريد"
                  style: AppStyles.primaryHeadLineStyle.copyWith(color: textColor),
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    loc.translate('otp_msg'), // "يرجى إدخال الرمز..."
                    textAlign: TextAlign.center,
                    style: AppStyles.supTitleStyle.copyWith(
                      color: isDark ? Colors.grey : Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // اتجاه الحقول سيتغير تلقائياً مع اللغة (RTL/LTR)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr, // الرموز والأرقام دائماً LTR
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOtpBox(context, _c1, _f1, _f2, isDark, isGirlie),
                        _buildOtpBox(context, _c2, _f2, _f3, isDark, isGirlie),
                        _buildOtpBox(context, _c3, _f3, _f4, isDark, isGirlie),
                        _buildOtpBox(context, _c4, _f4, null, isDark, isGirlie),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                PrimaryButtonWidget(
                  buttonText: loc.translate('verify_btn'), // "تحقق من الرمز"
                  onPressed: () => _verifyOtp(loc),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.translate('otp_resent'))), // "تم إعادة الإرسال"
                      );
                    },
                    child: Text(
                      loc.translate('resend_code'), // "إعادة إرسال الرمز"
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const WatermarkWidget(),
        ],
      ),
    );
  }

  Widget _buildOtpBox(
    BuildContext context,
    TextEditingController controller,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    bool isDark,
    bool isGirlie,
  ) {
    return SizedBox(
      height: 60.h,
      width: 60.w,
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        onChanged: (value) {
          if (value.length == 1 && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isGirlie ? const Color(0xFFFF69B4) : Colors.blue,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        ),
      ),
    );
  }
}