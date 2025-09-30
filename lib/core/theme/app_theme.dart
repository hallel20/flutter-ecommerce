import 'package:flutter/material.dart';

/// Centralized theme configuration for the application
/// Implements Material 3 design system with consistent colors and typography
class AppTheme {
  // Color scheme constants
  static const Color _primaryColor = Color(0xFF6750A4);
  // ignore: unused_field
  static const Color _secondaryColor = Color(0xFF625B71);
  // ignore: unused_field
  static const Color _surfaceColor = Color(0xFFFFFBFE);
  // ignore: unused_field
  static const Color _errorColor = Color(0xFFBA1A1A);

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ),

      /// Card theme for product cards and other elevated surfaces
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),

      /// App bar theme for consistent header styling
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),

      /// Elevated button theme for primary actions
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      /// Input decoration theme for form fields
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
