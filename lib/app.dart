import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/cart/providers/cart_provider.dart';

/// Root application widget that configures the Material app
/// with theme, routing, and global state management
/// 
/// BEGINNER EXPLANATION:
/// This is the "root" of your entire app - everything starts here.
/// It sets up the theme, routing, and state management (Provider).
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// MultiProvider wraps the entire app
    /// This makes AuthProvider and CartProvider available everywhere
    /// 
    /// Think of it like a "toolbox" that any screen can access
    /// to get authentication info or cart data
    return MultiProvider(
      providers: [
        /// AuthProvider - Manages user login/logout state
        /// ChangeNotifierProvider automatically rebuilds widgets
        /// when the provider's data changes
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),
        
        /// CartProvider - Manages shopping cart
        /// You probably already have this one!
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        
        /// You can add more providers here as your app grows
        /// For example: WishlistProvider, OrderProvider, etc.
      ],
      
      child: MaterialApp.router(
        title: 'E-commerce Storefront',
        debugShowCheckedModeBanner: false,
       
        /// Apply Material 3 theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Follows system theme preference
       
        /// Configure app routing using GoRouter
        routerConfig: AppRouter.router,
      ),
    );
  }
}