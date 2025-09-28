import 'product.dart';

/// Represents an item in the shopping cart
/// Extends Product model with quantity information
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  /// Calculate the total price for this cart item
  /// Based on product price and quantity
  double get totalPrice => product.price * quantity;

  /// Create a copy of CartItem with modified quantity
  /// Useful for incrementing/decrementing quantities
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product;

  @override
  int get hashCode => product.hashCode;

  @override
  String toString() =>
      'CartItem(product: ${product.name}, quantity: $quantity, total: \$${totalPrice.toStringAsFixed(2)})';
}