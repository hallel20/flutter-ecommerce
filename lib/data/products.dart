import '../shared/models/product.dart';

/// Mock product data for the storefront
/// In a real application, this would come from an API or database
class ProductData {
  static const List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium noise-cancelling wireless headphones with 30-hour battery life. Perfect for music lovers and professionals who need crystal clear audio quality.',
      imageUrl: 'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 199.99,
      category: 'Electronics',
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Advanced fitness tracker with heart rate monitoring, GPS, and 5-day battery life. Track your workouts and stay connected on the go.',
      imageUrl: 'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 299.99,
      category: 'Electronics',
    ),
    Product(
      id: '3',
      name: 'Laptop Backpack',
      description: 'Durable water-resistant laptop backpack with multiple compartments. Fits laptops up to 15.6 inches and includes USB charging port.',
      imageUrl: 'https://images.pexels.com/photos/2905238/pexels-photo-2905238.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 79.99,
      category: 'Accessories',
    ),
    Product(
      id: '4',
      name: 'Smartphone',
      description: 'Latest flagship smartphone with advanced camera system, 5G connectivity, and all-day battery life. Perfect for photography enthusiasts.',
      imageUrl: 'https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 699.99,
      category: 'Electronics',
    ),
    Product(
      id: '5',
      name: 'Coffee Maker',
      description: 'Programmable drip coffee maker with 12-cup capacity and thermal carafe. Brew perfect coffee every morning with customizable settings.',
      imageUrl: 'https://images.pexels.com/photos/324028/pexels-photo-324028.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 129.99,
      category: 'Home & Kitchen',
    ),
    Product(
      id: '6',
      name: 'Running Shoes',
      description: 'Lightweight running shoes with responsive cushioning and breathable mesh upper. Perfect for daily runs and long-distance training.',
      imageUrl: 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 159.99,
      category: 'Sports & Fitness',
    ),
    Product(
      id: '7',
      name: 'Desk Lamp',
      description: 'Modern LED desk lamp with adjustable brightness and color temperature. Perfect for reading, working, and studying with eye-care technology.',
      imageUrl: 'https://images.pexels.com/photos/4298629/pexels-photo-4298629.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 49.99,
      category: 'Home & Office',
    ),
    Product(
      id: '8',
      name: 'Bluetooth Speaker',
      description: 'Portable Bluetooth speaker with 360-degree sound and waterproof design. Perfect for outdoor adventures and pool parties.',
      imageUrl: 'https://images.pexels.com/photos/3394658/pexels-photo-3394658.jpeg?auto=compress&cs=tinysrgb&w=500',
      price: 89.99,
      category: 'Electronics',
    ),
  ];

  /// Get all products
  /// In a real app, this might include filtering and sorting parameters
  static List<Product> getAllProducts() {
    return products;
  }

  /// Get a specific product by ID
  /// Returns null if product is not found
  static Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get products by category
  /// Useful for implementing category filtering
  static List<Product> getProductsByCategory(String category) {
    return products.where((product) => 
        product.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Search products by name or description
  /// Implements basic text search functionality
  static List<Product> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return products.where((product) =>
        product.name.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}