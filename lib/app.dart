import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root application widget that configures the Material app
/// with theme, routing, and global settings
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-commerce Storefront',
      debugShowCheckedModeBanner: false,
      
      /// Apply Material 3 theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follows system theme preference
      
      /// Configure app routing using GoRouter
      routerConfig: AppRouter.router,
    );
  }
}