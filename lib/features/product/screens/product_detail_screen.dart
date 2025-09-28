import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/products.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../cart/providers/cart_provider.dart';

/// Product detail screen showing full product information
/// Allows users to view details and add items to cart
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final Product? product;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> 
    with SingleTickerProviderStateMixin {
  late Product? _product;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    /// Initialize product data
    _product = widget.product ?? ProductData.getProductById(widget.productId);
    
    /// Set up animations for smooth UI transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    /// Start animation when screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Handle case when product is not found
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Not Found'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Product not found',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// App bar with hero image background
          _buildSliverAppBar(context, _product!),
          
          /// Product information section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProductInfo(context, _product!),
            ),
          ),
        ],
      ),
      
      /// Floating action button for adding to cart
      bottomNavigationBar: _buildBottomActionBar(context, _product!),
    );
  }

  /// Build sliver app bar with product image
  Widget _buildSliverAppBar(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product-${product.id}',
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build product information section
  Widget _buildProductInfo(BuildContext context, Product product) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Product category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              product.category,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          /// Product name
          Text(
            product.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          /// Product price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          /// Description section
          Text(
            'Description',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            product.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 100), // Space for bottom action bar
        ],
      ),
    );
  }

  /// Build bottom action bar with add to cart button
  Widget _buildBottomActionBar(BuildContext context, Product product) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(product.id);
        final quantity = cartProvider.getQuantity(product.id);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                /// Quantity controls if item is in cart
                if (isInCart) ...[
                  _buildQuantityControls(context, product, cartProvider, quantity),
                  const SizedBox(width: 16),
                ],
                
                /// Add to cart / View cart button
                Expanded(
                  child: CustomButton.primary(
                    text: isInCart ? 'View Cart' : 'Add to Cart',
                    icon: Icon(isInCart ? Icons.shopping_cart : Icons.add_shopping_cart),
                    onPressed: () {
                      if (isInCart) {
                        Navigator.of(context).pushNamed('/cart');
                      } else {
                        cartProvider.addToCart(product);
                        _showAddedToCartSnackBar(context, product);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build quantity control buttons
  Widget _buildQuantityControls(
    BuildContext context, 
    Product product, 
    CartProvider cartProvider, 
    int quantity,
  ) {
    return Row(
      children: [
        /// Decrease quantity
        IconButton(
          onPressed: () => cartProvider.decrementQuantity(product.id),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        
        /// Quantity display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        /// Increase quantity
        IconButton(
          onPressed: () => cartProvider.incrementQuantity(product.id),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  /// Show confirmation snackbar when item is added to cart
  void _showAddedToCartSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}