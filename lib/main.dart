import 'package:firebase_core/firebase_core.dart';
import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/providers/product_provider.dart';
import 'package:flowmart/core/routing/routing_genrtion_config.dart';
import 'package:flowmart/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
      );

  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.themeData,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
