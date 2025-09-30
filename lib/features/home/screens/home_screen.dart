import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/rendering.dart';
import '../../../data/products.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/models/product.dart';
import '../../cart/providers/cart_provider.dart';

/// Home screen displaying the product grid
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
        /// Welcome section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
