class AuthModel {
  final String email;
  final String password;

  AuthModel({required this.email, required this.password});

  // Simple validation - in real app, this would be server-side
  bool isValid() {
    return email.isNotEmpty && password.length >= 6;
  }

  // Mock authentication - replace with real API call
  static Future<bool> authenticate(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple mock: accept any email with password "password123"
    return password == "password123";
  }
}