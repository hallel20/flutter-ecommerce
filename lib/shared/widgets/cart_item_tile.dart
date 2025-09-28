import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../../features/cart/providers/cart_provider.dart';

/// Reusable cart item tile widget for displaying items in cart
/// Includes quantity controls and remove functionality
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image_not_supported,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(width: 12),
            
            /// Product information and controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Product name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.product.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      /// Remove item button
                      IconButton(
                        onPressed: () {
                          cartProvider.removeFromCart(cartItem.product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${cartItem.product.name} removed from cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        tooltip: 'Remove item',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  /// Price and quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Unit price and total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${cartItem.product.price.toStringAsFixed(2)} each',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      /// Quantity controls
                      Row(
                        children: [
                          /// Decrease quantity button
                          IconButton(
                            onPressed: () {
                              cartProvider.decrementQuantity(cartItem.product.id);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            tooltip: 'Decrease quantity',
                          ),
                          
                          /// Quantity display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${cartItem.quantity}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          /// Increase quantity button
                          IconButton(
                            onPressed: () {
                              cartProvider.incrementQuantity(cartItem.product.id);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Increase quantity',
                          ),
                        ],
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