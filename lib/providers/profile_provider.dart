import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profileData;
  bool _isLoading = false;
  String _errorMessage = '';

  ProfileModel? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProfileData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // 🔥 GANTI URL DI SINI
    try {
      final url = Uri.parse(
        'http://127.0.0.1:8000/api/users/me',
      ); // ganti dengan api user di laptop kamu

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // TAMBAHKAN INI: Kunci/Token yang kamu dapat dari proses Authorize tadi
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZ3VuZ2RldmExMjNAZ21haWwuY29tIiwiZXhwIjoxNzgyODE4MTMzfQ.SOYpfqXBO-xOSOmCWJoPsq1IjkhtSdU57FkqF3dBMGA", // masukin token autorize nya disini biar gak error
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // kalau API kamu langsung return object
        _profileData = ProfileModel.fromJson(data);

        // kalau API kamu bentuknya:
        // { "data": {...} }
        // pakai ini:
        // _profileData = ProfileModel.fromJson(data['data']);
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat profil: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
