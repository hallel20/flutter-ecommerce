import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/cart/providers/cart_provider.dart';

/// Entry point of the application
/// Sets up the global providers and runs the app
void main() {
  runApp(
    /// MultiProvider enables dependency injection for state management
    /// across the entire app widget tree
    MultiProvider(
      providers: [
        /// Cart provider manages the shopping cart state globally
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const EcommerceApp(),
    ),
  );
}