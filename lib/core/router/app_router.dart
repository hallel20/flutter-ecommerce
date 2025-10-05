import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/welcome_screen.dart';
import '../../features/product/screens/product_detail_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../shared/models/product.dart';

/// Centralized routing configuration using GoRouter
/// Provides type-safe navigation with parameter validation
/// 
/// BEGINNER EXPLANATION:
/// This is like a "map" of your app. It tells Flutter which screen
/// to show when you navigate to a specific path (like a URL).
class AppRouter {
  static final GoRouter router = GoRouter(
    /// Initial location - where the app starts
    /// Changed to '/welcome' so users see the welcome screen first
    initialLocation: '/welcome',
    
    routes: [
      /// Welcome route - First screen with login/register options
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      /// Login route - Where users log in
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      /// Register route - Where users create new accounts
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      /// Home route - displays product grid
      /// This is the main shopping screen
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      /// Product detail route with product parameter
      /// Shows detailed info about a single product
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          final product = state.extra as Product?;
          
          return ProductDetailScreen(
            productId: productId,
            product: product,
          );
        },
      ),
      
      /// Shopping cart route
      /// Shows all items in the user's cart
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      
      /// Checkout route
      /// Where users complete their purchase
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}