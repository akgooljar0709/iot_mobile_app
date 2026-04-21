class AuthModel {
  final String email;
  final String password;

  AuthModel({required this.email, required this.password});

  // Simple validation - in real app, this would be server-side
  bool isValid() {
    return email.isNotEmpty && password.length >= 6;
  }

  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password validation
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}