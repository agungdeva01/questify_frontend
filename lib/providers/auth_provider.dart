import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/login_screen.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fungsi Login untuk UI (Menggunakan Email)
  Future<bool> handleLogin(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Kasih tahu UI kalau lagi loading

    bool success = await _authService.login(email, password);

    _isLoading = false;
    notifyListeners(); // Kasih tahu UI kalau loading selesai
    return success;
  }

  // Fungsi Register untuk UI (Menggunakan Username + Email + Password sesuai API spec)
  Future<bool> handleRegister(
    String username,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners(); // Kasih tahu UI kalau lagi loading

    bool success = await _authService.register(username, email, password);

    _isLoading = false;
    notifyListeners(); // Kasih tahu UI kalau loading selesai
    return success;
  }

  // Di dalam class AuthProvider
  int level = 1;
  double exp = 0.4; // 40%
  int koin = 25;
  String username = "Deva";

  // Fungsi Logout
  Future<void> handleLogout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();

    _isLoading = false;
    notifyListeners();

    // Hapus semua stack navigasi dan kembali ke LoginScreen
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
