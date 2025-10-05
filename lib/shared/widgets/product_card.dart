import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../../features/cart/providers/cart_provider.dart';

/// Reusable product card widget for displaying products in grid
/// Provides consistent styling and navigation behavior
class ProductCard extends StatelessWidget {
  final Product product;
  
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        /// Navigate to product detail with hero animation
        onTap: () {
          context.pushNamed(
            'product-detail',
            pathParameters: {'id': product.id},
            extra: product,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product image with hero animation
            /// Uses AspectRatio to control image size predictably
            /// This prevents the image from taking unpredictable space
            Expanded(
              flex: 3, // Makes a square (1:1 ratio)
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Fallback background color if image fails
                    color: Colors.grey[200],
                    image: product.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                            // Error handler for failed image loads
                            onError: (exception, stackTrace) {
                              debugPrint('Error loading image: $exception');
                            },
                          )
                        : null,
                  ),
                  // Show placeholder icon if no image URL
                  child: product.imageUrl.isEmpty
                      ? Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
              ),
            ),
           
            /// Product information section
            /// Uses Padding instead of Expanded to prevent overflow
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize.min = only use the space actually needed
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Product name with overflow handling
                  /// CRITICAL: maxLines prevents text from overflowing
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2, // Maximum 2 lines
                    overflow: TextOverflow.ellipsis, // Shows "..." if too long
                  ),
                   
                  const SizedBox(height: 4),
                   
                  /// Product category
                  /// CRITICAL: maxLines prevents overflow
                  Text(
                    product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1, // Only 1 line for category
                    overflow: TextOverflow.ellipsis,
                  ),
                   
                  const SizedBox(height: 8),
                   
                  /// Price and Add to Cart button row
                  /// CRITICAL: Using Row with Expanded to prevent overflow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Product price - wrapped in Expanded to handle long prices
                      Expanded(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Prevent price from taking multiple lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      /// Add to Cart button
                      /// Uses Consumer to rebuild when cart changes
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          // Check if this product is already in cart
                          final isInCart = cartProvider.items.any(
                            (item) => item.product.id == product.id,
                          );
                          
                          return IconButton(
                            onPressed: () {
                              // Add product to cart
                              cartProvider.addToCart(product);
                              
                              // Show confirmation message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added ${product.name} to cart',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    onPressed: () {
                                      context.goNamed('cart');
                                    },
                                  ),
                                ),
                              );
                            },
                            // Change icon if product is already in cart
                            icon: Icon(
                              isInCart 
                                  ? Icons.shopping_cart 
                                  : Icons.add_shopping_cart,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              foregroundColor: theme.colorScheme.onPrimaryContainer,
                            ),
                            tooltip: isInCart ? 'In cart' : 'Add to cart',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}