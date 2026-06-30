import 'package:flutter/material.dart';
import '../models/user_response.dart';
import '../services/user_service.dart'; // ← Menggunakan ApiClient (Dio + auto-token)

/// Provider untuk halaman Profile.
/// Menggunakan UserService yang sudah terintegrasi dengan ApiClient berbasis Dio,
/// sehingga token JWT hasil login otomatis tersemat di setiap request via interceptor.
/// Tidak ada lagi hardcoded token atau penggunaan package:http mentah.
class ProfileProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserResponse? _profileData;
  bool _isLoading = false;
  String _errorMessage = '';

  UserResponse? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProfileData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Token JWT otomatis disertakan oleh Dio interceptor di ApiClient
    final data = await _userService.getProfile();

    if (data != null) {
      _profileData = data;
    } else {
      _errorMessage =
          'Gagal memuat profil. Periksa koneksi atau coba login ulang.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
