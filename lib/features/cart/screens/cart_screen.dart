import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/cart_item_tile.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/cart_provider.dart';

/// Shopping cart screen displaying all cart items
/// Allows quantity management and checkout navigation
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          /// Clear cart button
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.isEmpty) return const SizedBox.shrink();
              
              return IconButton(
                onPressed: () => _showClearCartDialog(context, cartProvider),
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear cart',
              );
            },
          ),
        ],
      ),
      
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          /// Show empty cart message if cart is empty
          if (cartProvider.isEmpty) {
            return _buildEmptyCartView(context);
          }
          
          /// Show cart items with summary
          return Column(
            children: [
              /// Cart items list
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    return CartItemTile(
                      cartItem: cartProvider.items[index],
                    );
                  },
                ),
              ),
              
              /// Cart summary and checkout
              _buildCartSummary(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  /// Build empty cart view with illustration and action
  Widget _buildEmptyCartView(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Empty cart icon
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            
            const SizedBox(height: 24),
            
            /// Empty cart title
            Text(
              'Your Cart is Empty',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            /// Empty cart description
            Text(
              'Looks like you haven\'t added any items to your cart yet.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            /// Continue shopping button
            CustomButton.primary(
              text: 'Start Shopping',
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () => context.goNamed('home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build cart summary with total and checkout button
  /// FIXED: All text now uses Flexible/Expanded to prevent overflow
  Widget _buildCartSummary(BuildContext context, CartProvider cartProvider) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Order summary
            /// CRITICAL FIX: Wrapped columns in Flexible to handle overflow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left side - Total Items
                /// Flexible allows text to shrink if needed
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Items',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1, // CRITICAL: Prevents overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${cartProvider.itemCount}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // CRITICAL: Prevents overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16), // Space between columns
                
                /// Right side - Total Price
                /// Flexible allows text to shrink if needed
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Price',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1, // CRITICAL: Prevents overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // CRITICAL: Prevents overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            /// Action buttons
            Row(
              children: [
                /// Continue shopping button
                Expanded(
                  child: CustomButton.secondary(
                    text: 'Continue Shopping',
                    onPressed: () => context.goNamed('home'),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                /// Checkout button
                Expanded(
                  child: CustomButton.primary(
                    text: 'Checkout',
                    icon: const Icon(Icons.payment),
                    onPressed: () => context.pushNamed('checkout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog to confirm clearing the cart
  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}