import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    // 🇺🇸 English
    'en': {
      // --- General (عام) ---
      'app_name': 'FlowMart',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'yes_delete': 'Yes, Delete',
      'edit': 'Edit',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'jod': 'JOD',
      'required': 'Required',
      'unknown': 'Unknown',
      'alert': 'Alert',

      // --- Navigation & Drawer (التنقل) ---
      'home': 'Home',
      'search': 'Search',
      'my_products': 'My Products',
      'chats': 'Chats',
      'settings': 'Settings',
      'welcome': 'Welcome to FlowMart',
      'welcome_title': 'Welcome',
      'profile': 'Profile',

      // --- Auth (الدخول والتسجيل) ---
      'login': 'Log In',
      'logout': 'Log Out',
      'guest': 'Guest User',
      'login_required': 'Login Required',
      'login_msg': 'Please login to perform this action.',
      'login_btn': 'Login / Sign Up',
      'logout_confirm': 'Logged out successfully',
      'welcome_back': 'Welcome back!',
      'enter_email': 'Enter Your Email',
      'invalid_email': 'Invalid Email',
      'enter_password': 'Enter Your Password',
      'login_success': 'Login Successful!',
      'google_failed': 'Google Sign In Failed',
      'or_social': 'Or login with social account',
      'or_register_social': 'Or register with social account',
      'no_account': 'Don\'t have an account?',
      'have_account': 'Already have an account?',
      'register': 'Register',
      'register_welcome': 'Hello! Register to get started',
      'username': 'Username',
      'password': 'Password',
      'account_created': 'Account Created Successfully!',
      'home_pages': 'Home Page',

      // --- Passwords (كلمات المرور) ---
      'forgot_password': 'Forgot Password?',
      'forgot_pass_msg':
          'Don\'t worry! It happens. Please enter the email address linked with your account.',
      'send_code': 'Send Code',
      'code_sent': 'Code sent successfully!',
      'simulating_send': 'Simulating Send (Dev Mode)',
      'otp_title': 'OTP Verification',
      'email_verification': 'Email Verification',
      'otp_msg': 'Please enter the code sent to your email.',
      'verify_btn': 'Verify Code',
      'resend_code': 'Resend Code',
      'otp_verified': 'Verified Successfully!',
      'otp_invalid': 'Invalid Code',
      'otp_resent': 'Code resent!',
      'new_password_title': 'New Password',
      'reset_password': 'Reset Password',
      'new_pass_msg': 'Please enter your new password securely.',
      'new_pass_hint': 'New Password',
      'confirm_pass_hint': 'Confirm Password',
      'pass_min_length': 'Min 6 characters',
      'pass_mismatch': 'Passwords do not match',
      'update_pass_btn': 'Update Password',
      'pass_changed_success': 'Password Changed Successfully! Login now.',

      // --- Upload & Products (الرفع والمنتجات) ---
      'upload_title': 'Upload Product',
      'product_name': 'Product Name',
      'price_label': 'Price (JOD)',
      'desc_label': 'Description (Optional)',
      'upload_cover_hint': 'Tap to upload cover image',
      'ar_file_tab': 'AR File',
      'image_tab': 'Product Image',
      'file_selected': 'File Selected',
      'upload_3d_hint': 'Tap to upload 3D file',
      'publish_btn': 'Publish Product',
      'fill_data_error': 'Please fill basic data and image',
      'upload_success': 'Product uploaded successfully!',
      'no_products': 'No products found',
      'unknown_publisher': 'Unknown Publisher',
      'error_snapshot': 'Error: ',
      'search_hint': 'Search for a product...',
      'start_search': 'Start searching for products',
      'no_results': 'No results found',
      'no_my_products': 'You haven\'t published any products yet',
      'delete_product_confirm': 'Are you sure you want to delete this product?',

      // --- Chat (المحادثة) ---
      'chat_history': 'Chat History',
      'no_chats': 'No previous chats',
      'user': 'User',
      'online': 'Online now',
      'type_message': 'Type a message...',
      'about_product': 'About:',
      'error_loading_messages': 'Error loading messages',
      'send': 'Send',

      // --- Settings (الإعدادات) ---
      'settings_title': 'Settings',
      'appearance_app': 'Appearance & App',
      'app_theme': 'App Theme',
      'language_label': 'Language',
      'account_section': 'Account Management',
      'logout_title': 'Log Out',
      'delete_acc_title': 'Delete Account',
      'delete_confirm_title': 'Delete Account Permanently?',
      'delete_confirm_msg':
          'Warning: This will permanently delete your account and data. This action cannot be undone.',
      'cancel_btn': 'Cancel',
      'delete_btn': 'Yes, Delete Account',
      'delete_success_msg': 'Account deleted successfully',
      'delete_fail_msg': 'Deletion failed (Re-login might be required): ',
      'guest_user': 'Guest User',
      'guest_login_btn': 'Login / Create Account',
      'theme_light': 'Light ☀️',
      'theme_dark': 'Dark 🌑',
      'theme_girlie': 'Girlie 🌸',
      'lang_ar': 'Arabic 🇯🇴',
      'lang_en': 'English 🇺🇸',
    },

    // 🇯🇴 Arabic
    'ar': {
      // --- عام ---
      'app_name': 'فلو مارت',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'delete': 'حذف',
      'yes_delete': 'نعم، احذف',
      'edit': 'تعديل',
      'error': 'خطأ',
      'success': 'تم بنجاح',
      'loading': 'جاري التحميل...',
      'jod': 'دينار',
      'required': 'مطلوب',
      'unknown': 'غير معروف',
      'alert': 'تنبيه',

      // --- التنقل ---
      'home': 'الرئيسية',
      'search': 'البحث',
      'my_products': 'منتجاتي',
      'chats': 'المحادثات',
      'settings': 'الإعدادات',
      'welcome': 'أهلاً بك في فلو مارت',
      'welcome_title': 'مرحباً',
      'profile': 'الملف الشخصي',

      // --- الدخول ---
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'guest': 'زائر',
      'login_required': 'تسجيل الدخول مطلوب',
      'login_msg': 'يرجى تسجيل الدخول لتتمكن من إضافة منتجات أو التفاعل.',
      'login_btn': 'تسجيل الدخول / إنشاء حساب',
      'logout_confirm': 'تم تسجيل الخروج بنجاح',
      'welcome_back': 'أهلاً بعودتك مجدداً!',
      'enter_email': 'أدخل بريدك الإلكتروني',
      'invalid_email': 'بريد إلكتروني غير صحيح',
      'enter_password': 'أدخل كلمة المرور',
      'login_success': 'تم تسجيل الدخول بنجاح',
      'google_failed': 'فشل تسجيل الدخول عبر جوجل',
      'or_social': 'أو تابع عبر وسائل التواصل',
      'or_register_social': 'أو سجل عبر وسائل التواصل',
      'no_account': 'ليس لديك حساب؟',
      'have_account': 'لديك حساب بالفعل؟',
      'register': 'إنشاء حساب',
      'register_welcome': 'مرحباً! أنشئ حسابك لتبدأ',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'account_created': 'تم إنشاء الحساب بنجاح!',
      'home_pages': 'الصفحة الرئيسية',

      // --- كلمات المرور ---
      'forgot_password': 'نسيت كلمة المرور؟',
      'forgot_pass_msg':
          'لا تقلق! يحدث ذلك. يرجى إدخال البريد الإلكتروني المرتبط بحسابك.',
      'send_code': 'أرسل الرمز',
      'code_sent': 'تم إرسال الرمز بنجاح!',
      'simulating_send': 'محاكاة الإرسال (وضع المطور)',
      'otp_title': 'التحقق من الرمز',
      'email_verification': 'تأكيد البريد الإلكتروني',
      'otp_msg': 'يرجى إدخال الرمز المكون من 4 أرقام المرسل إليك.',
      'verify_btn': 'تحقق من الرمز',
      'resend_code': 'إعادة إرسال الرمز',
      'otp_verified': 'تم التحقق بنجاح!',
      'otp_invalid': 'رمز غير صحيح',
      'otp_resent': 'تم إعادة إرسال الرمز!',
      'new_password_title': 'كلمة المرور الجديدة',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'new_pass_msg': 'يرجى إدخال كلمة المرور الجديدة بأمان.',
      'new_pass_hint': 'كلمة المرور الجديدة',
      'confirm_pass_hint': 'تأكيد كلمة المرور',
      'pass_min_length': '6 أحرف على الأقل',
      'pass_mismatch': 'كلمتا المرور غير متطابقتين',
      'update_pass_btn': 'تحديث كلمة المرور',
      'pass_changed_success': 'تم تغيير كلمة المرور بنجاح! سجل دخولك الآن.',

      // --- الرفع والمنتجات ---
      'upload_title': 'إضافة منتج',
      'product_name': 'اسم المنتج',
      'price_label': 'السعر (دينار)',
      'desc_label': 'وصف المنتج (اختياري)',
      'upload_cover_hint': 'اضغط لإضافة صورة الغلاف',
      'ar_file_tab': 'ملف AR',
      'image_tab': 'صورة المنتج',
      'file_selected': 'تم اختيار الملف',
      'upload_3d_hint': 'اضغط لرفع ملف 3D',
      'publish_btn': 'نشر المنتج',
      'fill_data_error': 'يرجى تعبئة البيانات الأساسية والصورة',
      'upload_success': 'تم رفع المنتج بنجاح!',
      'no_products': 'لا يوجد منتجات حالياً',
      'unknown_publisher': 'ناشر غير معروف',
      'error_snapshot': 'حدث خطأ: ',
      'search_hint': 'ابحث عن منتج...',
      'start_search': 'ابدأ البحث عن منتجات',
      'no_results': 'لم يتم العثور على نتائج',
      'no_my_products': 'لم تقم بنشر أي منتجات بعد',
      'delete_product_confirm': 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟',

      // --- المحادثة ---
      'chat_history': 'سجل المحادثات',
      'no_chats': 'لا توجد محادثات سابقة',
      'user': 'مستخدم',
      'online': 'متصل الآن',
      'type_message': 'اكتب رسالتك...',
      'about_product': 'بخصوص:',
      'error_loading_messages': 'حدث خطأ في تحميل الرسائل',
      'send': 'إرسال',

      // --- الإعدادات ---
      'settings_title': 'الإعدادات',
      'appearance_app': 'المظهر والتطبيق',
      'app_theme': 'ثيم التطبيق',
      'language_label': 'اللغة',
      'account_section': 'إدارة الحساب',
      'logout_title': 'تسجيل الخروج',
      'delete_acc_title': 'حذف الحساب',
      'delete_confirm_title': 'حذف الحساب نهائياً؟',
      'delete_confirm_msg':
          'تحذير: سيتم حذف حسابك وجميع بياناتك ولن تتمكن من استعادتها.',
      'cancel_btn': 'تراجع',
      'delete_btn': 'نعم، احذف الحساب',
      'delete_success_msg': 'تم حذف الحساب بنجاح',
      'delete_fail_msg': 'فشل الحذف (قد تحتاج لإعادة تسجيل الدخول): ',
      'guest_user': 'أنت تتصفح كزائر',
      'guest_login_btn': 'تسجيل الدخول / إنشاء حساب',
      'theme_light': 'نهاري ☀️',
      'theme_dark': 'ليلي 🌑',
      'theme_girlie': 'بناتي 🌸',
      'lang_ar': 'العربية 🇯🇴',
      'lang_en': 'English 🇺🇸',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // اللغة الافتراضية

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}
