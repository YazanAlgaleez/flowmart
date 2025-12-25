import 'package:firebase_core/firebase_core.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/providers/product_provider.dart';
// تأكد من أن هذا المسار يشير للملف الذي يحتوي على AppRouter وتعديلاتنا الأخيرة
import 'package:flowmart/core/routing/routing_genrtion_config.dart';
import 'package:flowmart/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// --- إضافات الـ AI Toolkit ---
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: themeProvider.themeData,
                routerConfig: AppRouter
                    .router, // تأكد أن AppRouter يحتوي على navigatorKey

                // --- الـ Builder العام لوضع الزر فوق كل الصفحات ---
                builder: (context, child) {
                  return Stack(
                    children: [
                      // 1. التطبيق الأساسي
                      child!,

                      // 2. زر الـ AI العائم القابل للتحريك
                      const GlobalAiChatFloatingButton(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// --- ويدجت الزر العائم القابل للتحريك ---
class GlobalAiChatFloatingButton extends StatefulWidget {
  const GlobalAiChatFloatingButton({super.key});

  @override
  State<GlobalAiChatFloatingButton> createState() =>
      _GlobalAiChatFloatingButtonState();
}

class _GlobalAiChatFloatingButtonState
    extends State<GlobalAiChatFloatingButton> {
  double _left = 0.0;
  double _top = 0.0;
  bool _isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      final size = MediaQuery.of(context).size;
      _left = size.width - 75.w;
      _top = size.height - 100.h;
      _isFirstBuild = false;
    }

    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _left += details.delta.dx;
            _top += details.delta.dy;

            // حدود الشاشة لمنع الزر من الاختفاء
            final size = MediaQuery.of(context).size;
            if (_left < 0) _left = 0;
            if (_left > size.width - 60) _left = size.width - 60;
            if (_top < 50) _top = 50;
            if (_top > size.height - 80) _top = size.height - 80;
          });
        },
        child: FloatingActionButton(
          heroTag: 'ai_chat_fab',
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.auto_awesome, color: Colors.white),
          onPressed: () {
            // ✅ التعديل الأهم هنا: استخدام سياق النافجيتر العام
            final currentContext = AppRouter.navigatorKey.currentContext;

            if (currentContext != null) {
              showModalBottomSheet(
                context:
                    currentContext, // نستخدم السياق الصحيح المرتبط بالراوتر
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return SizedBox(
                    height: 0.8.sh,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: LlmChatView(
                        provider: FirebaseProvider(
                          model: FirebaseAI.googleAI().generativeModel(
                            model: 'gemini-2.0-flash',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              debugPrint("Error: Navigator context is null!");
            }
          },
        ),
      ),
    );
  }
}
