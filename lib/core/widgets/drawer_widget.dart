import 'package:flowmart/core/providers/theme_provider.dart';
import 'package:flowmart/core/routing/app_routing.dart';
import 'package:flowmart/core/routing/routing_genrtion_config.dart';
import 'package:flowmart/core/styling/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme == AppTheme.dark;
    final isGirlie = themeProvider.currentTheme == AppTheme.girlie;

    return Drawer(
      backgroundColor: isDark
          ? const Color(0xFF0D0D0D)
          : isGirlie
          ? const Color(0xFFFFF0F5)
          : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1A1A1A)
                  : isGirlie
                  ? const Color(0xFFFF69B4)
                  : Colors.blue,
            ),
            child: Text(
              'FlowMart Menu',
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : isGirlie
                    ? const Color(0xFF8B008B)
                    : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              context.go(AppRoutes.home);
            },
            leading: Icon(
              Icons.home,
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : Colors.black,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : isGirlie
                    ? const Color(0xFF8B008B)
                    : Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              context.go(AppRoutes.search);
            },
            leading: Icon(
              Icons.search,
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : Colors.black,
            ),
            title: Text(
              'Search',
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : isGirlie
                    ? const Color(0xFF8B008B)
                    : Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              // Navigate to settings or theme selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Theme: ${themeProvider.currentTheme.name}',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : isGirlie
                          ? const Color(0xFF8B008B)
                          : Colors.black,
                    ),
                  ),
                  backgroundColor: isDark
                      ? const Color(0xFF1A1A1A)
                      : isGirlie
                      ? const Color(0xFFFFC0CB)
                      : Colors.grey[200],
                ),
              );
            },
            leading: Icon(
              Icons.settings,
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : Colors.black,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : isGirlie
                    ? const Color(0xFF8B008B)
                    : Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              context.go(AppRoutes.login);
            },
            leading: Icon(
              Icons.login_outlined,
              color: isDark
                  ? Colors.white
                  : isGirlie
                  ? const Color(0xFF8B008B)
                  : Colors.black,
            ),
            title: Text(
              'Log In',
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : isGirlie
                    ? const Color(0xFF8B008B)
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
