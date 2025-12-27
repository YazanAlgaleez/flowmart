import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmart/core/routing/routing_genrtion_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ للغة
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ للتخزين

// ✅ استيراد ملفات المشروع
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/providers/locale_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart'
    hide AppRoutes; // تأكد من المسار
import 'package:flowmart/services/firebase_api.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  // 1️⃣ فحص الذاكرة وحالة المستخدم لتحديد صفحة البداية
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final user = FirebaseAuth.instance.currentUser;

  String initialRoute;
  if (!seenOnboarding) {
    initialRoute = AppRoutes.onboarding; // أول مرة
  } else if (user != null) {
    initialRoute = AppRoutes.home; // مسجل دخول
  } else {
    initialRoute = AppRoutes.login; // شاهد البداية وغير مسجل
  }

  // 2️⃣ تمرير المسار للتطبيق
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute; // متغير لاستقبال المسار
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          final localeProvider = Provider.of<LocaleProvider>(context);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'FlowMart',

            // إعدادات اللغة
            locale: localeProvider.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: themeProvider.themeData,

            // ✅ هنا التصحيح: نستخدم الدالة ونمرر لها المسار
            routerConfig: AppRouter.createRouter(initialRoute),

            // الزر العائم فوق التطبيق
            builder: (context, child) => Stack(
              children: [
                child!,
                const GlobalAiChatFloatingButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// ✨ زر الذكاء الاصطناعي العائم ✨
// ---------------------------------------------------------

class GlobalAiChatFloatingButton extends StatefulWidget {
  const GlobalAiChatFloatingButton({super.key});

  @override
  State<GlobalAiChatFloatingButton> createState() =>
      _GlobalAiChatFloatingButtonState();
}

class _GlobalAiChatFloatingButtonState extends State<GlobalAiChatFloatingButton>
    with SingleTickerProviderStateMixin {
  double _left = 0.0;
  double _top = 0.0;
  bool _isFirstBuild = true;

  AnimationController? _particleController;
  final List<MagicSpark> _sparks = [];

  @override
  void initState() {
    super.initState();
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _particleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      final size = MediaQuery.of(context).size;
      final bool isRtl = Directionality.of(context) == TextDirection.rtl;
      _left = isRtl ? 20.w : size.width - 80.w;
      _top = size.height - 120.h;
      _isFirstBuild = false;
    }

    return Stack(
      children: [
        if (_particleController != null)
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _particleController!,
              builder: (context, child) {
                for (var i = 0; i < _sparks.length; i++) {
                  _sparks[i].update();
                }
                _sparks.removeWhere((p) => p.isDead);
                return CustomPaint(
                  painter: LightningPainter(_sparks),
                  size: Size.infinite,
                );
              },
            ),
          ),
        Positioned(
          left: _left,
          top: _top,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _left += details.delta.dx;
                _top += details.delta.dy;
                _addSparks(details.delta);
              });
            },
            child: _buildMagicalButton(),
          ),
        ),
      ],
    );
  }

  void _addSparks(Offset delta) {
    for (int i = 0; i < 4; i++) {
      _sparks.add(MagicSpark(
        _left + 30.w,
        _top + 30.w,
        delta,
      ));
    }
  }

  Widget _buildMagicalButton() {
    return GestureDetector(
      onTap: _openAiChat,
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2575FC).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
      ),
    );
  }

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 0.85.sh,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: LlmChatView(
            provider: FirebaseProvider(
              model: FirebaseAI.googleAI().generativeModel(
                model: 'gemini-1.5-flash',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// الكلاسات المساعدة (MagicSpark و LightningPainter)
class MagicSpark {
  double x, y, thickness, opacity, speedX, speedY;
  Color color;
  final Random _random = Random();

  MagicSpark(this.x, this.y, Offset delta)
      : thickness = Random().nextDouble() * 1.5 + 0.5,
        opacity = 1.0,
        speedX = -delta.dx * 0.8 + (Random().nextDouble() - 0.5) * 4,
        speedY = -delta.dy * 0.8 + (Random().nextDouble() - 0.5) * 4,
        color = [
          Colors.white,
          Colors.cyanAccent,
          const Color(0xFF00F7FF)
        ][Random().nextInt(3)];

  void update() {
    x += speedX;
    y += speedY;
    opacity -= 0.08;
  }

  bool get isDead => opacity <= 0;
}

class LightningPainter extends CustomPainter {
  final List<MagicSpark> sparks;
  LightningPainter(this.sparks);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    for (var spark in sparks) {
      final paint = Paint()
        ..color = spark.color.withOpacity(spark.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = spark.thickness
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(spark.x, spark.y);
      double currentX = spark.x;
      double currentY = spark.y;

      // رسم خط متعرج قصير
      path.lineTo(currentX + spark.speedX * 2, currentY + spark.speedY * 2);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
