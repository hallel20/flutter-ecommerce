/// User model representing an authenticated user
/// This is like a blueprint for user data in your app
class User {
  /// Unique identifier for the user
  final String id;
  
  /// User's full name
  final String name;
  
  /// User's email address (used for login)
  final String email;
  
  /// Optional profile image URL
  final String? profileImageUrl;
  
  /// When the user account was created
  final DateTime createdAt;

  /// Constructor - like a factory that creates User objects
  /// All required fields must be provided when creating a User
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
  });

  /// Create a User from JSON data (like from an API or database)
  /// This is called "deserialization" - converting JSON to a Dart object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert User to JSON data (for saving to API or database)
  /// This is called "serialization" - converting a Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of this User with some fields changed
  /// This is useful because User objects are immutable (can't be changed)
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

/// Authentication status enum
/// This represents the different states of authentication
enum AuthStatus {
  /// User is not logged in
  unauthenticated,
  
  /// User is logged in
  authenticated,
  
  /// Checking if user is logged in (like on app startup)
  loading,
}