import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/product/screens/product_detail_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../shared/models/product.dart';

/// Centralized routing configuration using GoRouter
/// Provides type-safe navigation with parameter validation
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      /// Home route - displays product grid
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      /// Product detail route with product parameter
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
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),

      /// Checkout route
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}
