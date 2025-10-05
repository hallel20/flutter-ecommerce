import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/rendering.dart';
import '../../../data/products.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/models/product.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';

/// Home screen displaying the product grid with authentication integration
/// Main entry point showing all available products
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductData.getAllProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-commerce Store'),
        actions: [
          /// Cart icon with item count badge
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => context.pushNamed('cart'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'View cart',
                  ),

                  /// Item count badge
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          
          /// User profile menu or login button
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              /// If user is logged in, show profile menu
              if (authProvider.isAuthenticated && authProvider.currentUser != null) {
                return PopupMenuButton<String>(
                  icon: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      authProvider.currentUser!.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'profile') {
                      _showProfileDialog(context, authProvider);
                    } else if (value == 'logout') {
                      _showLogoutDialog(context, authProvider);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outlined),
                          SizedBox(width: 12),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 12),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              
              /// If not logged in, show login button
              return TextButton(
                onPressed: () => context.pushNamed('login'),
                child: const Text('Login'),
              );
            },
          ),
          
          const SizedBox(width: 8),
        ],
      ),
      body: _buildProductGrid(context, products),
    );
  }

  /// Build responsive product grid
  /// Adapts column count based on screen width
  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return CustomScrollView(
      slivers: [
        /// Welcome section header with personalized greeting
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Show personalized greeting if logged in
                    if (authProvider.isAuthenticated && authProvider.currentUser != null)
                      Text(
                        'Hello, ${authProvider.currentUser!.name}!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      )
                    else
                      Text(
                        'Welcome to our Store',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover amazing products at great prices',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),

        /// Product grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithResponsiveColumns(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75, // Height is 1.33x width
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProductCard(product: products[index]);
              },
              childCount: products.length,
            ),
          ),
        ),

        /// Bottom padding for better scrolling experience
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  /// Show profile information dialog
  void _showProfileDialog(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser!;
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              user.name,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Email',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              user.email,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Member Since',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pop();
              context.goNamed('welcome');
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom grid delegate that adapts column count based on screen width
/// Provides responsive behavior for different device sizes
class SliverGridDelegateWithResponsiveColumns extends SliverGridDelegate {
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const SliverGridDelegateWithResponsiveColumns({
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.childAspectRatio,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    /// Calculate number of columns based on screen width
    final screenWidth = constraints.crossAxisExtent;
    int crossAxisCount;

    if (screenWidth > 1200) {
      crossAxisCount = 4; // Desktop: 4 columns
    } else if (screenWidth > 800) {
      crossAxisCount = 3; // Tablet: 3 columns
    } else if (screenWidth > 600) {
      crossAxisCount = 2; // Large phone: 2 columns
    } else {
      crossAxisCount = 2; // Phone: 2 columns
    }

    /// Calculate item width considering spacing
    final totalSpacing = crossAxisSpacing * (crossAxisCount - 1);
    final childWidth = (screenWidth - totalSpacing) / crossAxisCount;
    final childHeight = childWidth / childAspectRatio;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childHeight + mainAxisSpacing,
      crossAxisStride: childWidth + crossAxisSpacing,
      childMainAxisExtent: childHeight,
      childCrossAxisExtent: childWidth,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) {
    return false;
  }
}