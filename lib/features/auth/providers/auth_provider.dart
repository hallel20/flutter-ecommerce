import 'package:flutter/material.dart';
import '../../../shared/models/user.dart';

/// Authentication Provider - Manages authentication state across the app
/// This is like the "brain" that remembers if you're logged in or not
/// 
/// ChangeNotifier = tells widgets to rebuild when data changes
/// Think of it like a notification system that alerts the UI when auth status changes
class AuthProvider extends ChangeNotifier {
  /// Current authentication status
  AuthStatus _status = AuthStatus.unauthenticated;
  
  /// Currently logged in user (null if not logged in)
  User? _currentUser;
  
  /// Error message if login/register fails
  String? _errorMessage;
  
  /// Loading state for async operations
  bool _isLoading = false;

  // Getters - Ways to read the private data from outside
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Initialize authentication
  /// Check if user is already logged in (like from saved session)
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners(); // Tell UI to rebuild
    
    // Simulate checking for saved login session
    // In a real app, you'd check SharedPreferences or secure storage
    await Future.delayed(const Duration(seconds: 1));
    
    // For now, no saved session
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Login user with email and password
  /// Returns true if successful, false if failed
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Clear any previous errors
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call to login endpoint
      // In a real app, you'd call your backend API here
      await Future.delayed(const Duration(seconds: 2));

      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please enter both email and password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Email format validation
      if (!email.contains('@')) {
        _errorMessage = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simulate checking credentials
      // In a real app, your API would verify these
      if (password.length < 6) {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Success! Create user object
      // In a real app, this data would come from your API
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@')[0], // Use email prefix as name
        email: email,
        createdAt: DateTime.now(),
      );

      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  /// Returns true if successful, false if failed
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Clear any previous errors
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call to register endpoint
      await Future.delayed(const Duration(seconds: 2));

      // Validation checks
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please fill in all fields';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!email.contains('@')) {
        _errorMessage = 'Please enter a valid email address';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password != confirmPassword) {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Success! Create new user
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}