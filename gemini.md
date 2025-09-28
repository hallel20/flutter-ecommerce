# Flutter E-commerce App - Gemini Context

## Project Overview
This is a **Mini E-commerce Storefront app** built with Flutter using modern scalable architecture principles. The app demonstrates best practices for Flutter development with a feature-first folder structure, proper state management, and clean code organization.

## App Features
- **Home Screen**: Product grid with responsive layout
- **Product Detail Screen**: Full product information with hero animations
- **Shopping Cart**: Quantity management and total calculation
- **Checkout Screen**: Customer information form with validation
- **State Management**: Provider pattern for cart operations
- **UI/UX**: Material 3 design with dark mode support

## Architecture & Folder Structure

### Feature-First Organization
```
lib/
├── main.dart                    # App entry point with providers
├── app.dart                     # Root app widget with routing
├── core/                        # Core app configuration
│   ├── router/
│   │   └── app_router.dart      # GoRouter configuration
│   └── theme/
│       └── app_theme.dart       # Material 3 theme setup
├── data/
│   └── products.dart            # Mock product data
├── shared/                      # Shared components
│   ├── models/
│   │   ├── product.dart         # Product model
│   │   └── cart_item.dart       # Cart item model
│   └── widgets/
│       ├── product_card.dart    # Reusable product card
│       ├── cart_item_tile.dart  # Cart item display
│       └── custom_button.dart   # Custom button widget
└── features/                    # Feature modules
    ├── home/
    │   └── screens/
    │       └── home_screen.dart # Product grid screen
    ├── product/
    │   └── screens/
    │       └── product_detail_screen.dart
    ├── cart/
    │   ├── providers/
    │   │   └── cart_provider.dart # Cart state management
    │   └── screens/
    │       └── cart_screen.dart
    └── checkout/
        └── screens/
            └── checkout_screen.dart
```

## Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1      # State management
  go_router: ^12.1.3    # Navigation
  cupertino_icons: ^1.0.6
```

## State Management Pattern
The app uses **Provider** for state management with the following structure:

### CartProvider
- Manages shopping cart state globally
- Handles add/remove/update operations
- Calculates totals and item counts
- Provides cart persistence during app lifecycle

```dart
// Key methods in CartProvider:
void addToCart(Product product)
void removeFromCart(String productId)
void updateQuantity(String productId, int newQuantity)
void incrementQuantity(String productId)
void decrementQuantity(String productId)
void clearCart()
```

## Data Models

### Product Model
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
}
```

### CartItem Model
```dart
class CartItem {
  final Product product;
  final int quantity;
  double get totalPrice => product.price * quantity;
}
```

## Navigation Structure
Using **GoRouter** for type-safe navigation:

- `/` - Home screen (product grid)
- `/product/:id` - Product detail with parameter
- `/cart` - Shopping cart screen
- `/checkout` - Checkout form screen

## UI Components & Widgets

### Reusable Widgets
1. **ProductCard**: Displays product in grid with image, name, price
2. **CartItemTile**: Shows cart item with quantity controls
3. **CustomButton**: Consistent button styling with variants

### Design System
- **Material 3** design language
- **Responsive grid** that adapts to screen size
- **Hero animations** for smooth transitions
- **Consistent color scheme** with primary/secondary colors
- **Typography hierarchy** with proper text styles

## Code Quality Standards

### Documentation
- All classes have `///` documentation comments
- Methods include parameter and return value descriptions
- Complex logic has inline comments explaining business rules

### SOLID Principles
- **Single Responsibility**: Each class has one clear purpose
- **Open/Closed**: Models support extension via copyWith methods
- **Liskov Substitution**: Widgets follow Flutter's contract
- **Interface Segregation**: Providers expose only necessary methods
- **Dependency Inversion**: UI depends on abstractions, not concrete implementations

### Naming Conventions
- Classes: PascalCase (e.g., `ProductCard`, `CartProvider`)
- Methods/Variables: camelCase (e.g., `addToCart`, `totalPrice`)
- Files: snake_case (e.g., `product_detail_screen.dart`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `_PRIMARY_COLOR`)

## Mock Data
Products are stored in `/lib/data/products.dart` with 8 sample items including:
- Electronics (headphones, smartwatch, smartphone, speaker)
- Accessories (laptop backpack)
- Home & Kitchen (coffee maker, desk lamp)
- Sports & Fitness (running shoes)

Each product includes high-quality Pexels stock images.

## Key Features Implementation

### Responsive Design
- Grid adapts column count based on screen width
- Mobile: 2 columns, Tablet: 3 columns, Desktop: 4 columns
- Consistent spacing using 8px grid system

### Cart Management
- Add items with automatic quantity increment
- Remove items completely or decrement quantity
- Real-time total calculation
- Persistent state during navigation

### Form Validation
Checkout form includes validation for:
- Name (minimum 2 characters)
- Email (regex pattern validation)
- Phone (minimum 10 digits)
- Address fields (required validation)

### User Experience
- Snackbar notifications for cart operations
- Loading states during order processing
- Empty state handling for cart
- Error handling for network images

## Development Guidelines

### Adding New Features
1. Create feature folder under `/lib/features/`
2. Separate screens, widgets, and providers
3. Add routes to `app_router.dart`
4. Update providers in `main.dart` if needed

### Extending Models
Use `copyWith` methods for immutable updates:
```dart
final updatedProduct = product.copyWith(price: newPrice);
```

### State Management
- Use `Consumer<T>` for widgets that need to rebuild
- Use `Provider.of<T>(context, listen: false)` for one-time access
- Call `notifyListeners()` after state changes in providers

### Testing Considerations
- Models include `==` operator and `hashCode` for testing
- Providers expose getters for easy state verification
- UI widgets accept required parameters for testability

## Future Enhancements
The architecture supports easy addition of:
- **API Integration**: Replace mock data with HTTP calls
- **User Authentication**: Add user provider and login screens
- **Product Search**: Implement search functionality
- **Categories**: Add category filtering
- **Favorites**: User wishlist feature
- **Order History**: Past orders tracking
- **Payment Integration**: Stripe/PayPal integration
- **Push Notifications**: Order status updates

## Performance Considerations
- Images loaded via `NetworkImage` with error handling
- Lazy loading in product grid using `ListView.builder`
- Efficient state updates with targeted `Consumer` widgets
- Memory management with proper controller disposal

## Debugging Tips
- Use Flutter Inspector for widget tree analysis
- Provider DevTools for state management debugging
- Network tab for image loading issues
- Console logs in cart operations for troubleshooting

## Common Commands
```bash
# Run the app
flutter run

# Build for release
flutter build apk
flutter build ios

# Analyze code
flutter analyze

# Format code
flutter format .

# Clean build
flutter clean
flutter pub get
```

---

This app demonstrates production-ready Flutter development with scalable architecture, proper state management, and modern UI design. The codebase is structured for easy maintenance and future feature additions.