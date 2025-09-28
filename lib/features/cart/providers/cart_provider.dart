import 'package:flutter/foundation.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/cart_item.dart';

/// Cart state management provider
/// Handles all cart operations including add, remove, and quantity updates
class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  /// Get all items in the cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get total number of items in cart
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  /// Calculate total price of all items in cart
  double get totalPrice => _items.fold(0.0, (total, item) => total + item.totalPrice);

  /// Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => _items.isNotEmpty;

  /// Add a product to the cart
  /// If product already exists, increment quantity
  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Product already in cart, increment quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      // New product, add to cart with quantity 1
      _items.add(CartItem(product: product, quantity: 1));
    }
    
    notifyListeners();
  }

  /// Remove a product from the cart completely
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update the quantity of a specific item in cart
  /// If quantity becomes 0 or negative, remove the item
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Increment quantity of a specific item
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  /// Decrement quantity of a specific item
  /// Removes item if quantity becomes 0
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final currentQuantity = _items[index].quantity;
      if (currentQuantity > 1) {
        _items[index] = _items[index].copyWith(quantity: currentQuantity - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Get quantity of a specific product in cart
  int getQuantity(String productId) {
    final item = _items.where((item) => item.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  /// Check if a product is in the cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Clear all items from cart
  /// Typically used after successful checkout
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}