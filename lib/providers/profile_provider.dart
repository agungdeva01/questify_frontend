import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_response.dart';
import '../services/user_service.dart';
import 'home_provider.dart'; // ← Dependency injection, sama seperti QuestProvider

/// Provider untuk halaman Profile.
/// Menerima HomeProvider via konstruktor (Dependency Injection) agar setiap
/// mutasi profil (edit username / upload avatar) langsung men-trigger refresh
/// HomeProvider → sinkronisasi real-time ke PlayerCardWidget di Home Screen.
class ProfileProvider with ChangeNotifier {
  final HomeProvider _homeProvider;
  final UserService _userService = UserService();
  final ImagePicker _imagePicker = ImagePicker();

  ProfileProvider(this._homeProvider);

  UserResponse? _profileData;
  bool _isLoading = false;
  bool _isUploading = false;
  String _errorMessage = '';

  UserResponse? get profileData => _profileData;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String get errorMessage => _errorMessage;

  /// Fetch profil dari GET /api/users/me via Dio (token otomatis).
  Future<void> fetchProfileData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

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

  /// Perbarui username via PUT /api/users/profile.
  /// Setelah sukses: refresh ProfileProvider state + trigger HomeProvider
  /// agar PlayerCardWidget di Home Screen langsung menampilkan nama baru.
  Future<bool> editUsername(String newUsername) async {
    if (newUsername.trim().isEmpty) return false;

    _isUploading = true;
    notifyListeners();

    final success = await _userService.updateUsername(newUsername.trim());

    if (success) {
      // [1] Refresh state Profile Screen
      await fetchProfileData();
      // [2] Sinkronisasi ke Home Screen (Solusi B — sama seperti QuestProvider)
      await _homeProvider.loadHomeData();
    }

    _isUploading = false;
    notifyListeners();
    return success;
  }

  /// Buka galeri, pilih gambar, upload ke POST /api/users/profile/avatar.
  /// Setelah sukses: refresh ProfileProvider state + trigger HomeProvider
  /// agar avatar baru langsung muncul di PlayerCardWidget Home Screen.
  Future<bool> pickAndUploadAvatar() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return false;

    _isUploading = true;
    notifyListeners();

    final File imageFile = File(pickedFile.path);
    final success = await _userService.uploadAvatar(imageFile);

    if (success) {
      // [1] Refresh state Profile Screen
      await fetchProfileData();
      // [2] Sinkronisasi ke Home Screen (Solusi B)
      await _homeProvider.loadHomeData();
    }

    _isUploading = false;
    notifyListeners();
    return success;
  }
}
