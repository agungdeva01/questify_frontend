import 'package:dio/dio.dart'; // Kita pakai Dio lagi karena FormData butuh library ini langsung
import 'package:flutter/foundation.dart'; // Menyediakan debugPrint (hanya aktif di debug mode)
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Fungsi Login (Sudah disesuaikan ke FormData agar sinkron dengan FastAPI OAuth2)
  Future<bool> login(String email, String password) async {
    try {
      // Dibungkus ke FormData karena FastAPI membaca skema login bawaan sebagai form input
      final formData = FormData.fromMap({
        'username':
            email, // OAuth2 di FastAPI mendeteksi field email sebagai 'username'
        'password': password,
      });

      final response = await _apiClient.dio.post(
        '/api/auth/login',
        data: formData, // Mengirimkan objek formData
      );

      if (response.statusCode == 200) {
        // Ambil access_token dari JSON response FastAPI
        String token = response.data['access_token'];
        // Simpan token ke local storage HP secara aman
        await _apiClient.storage.write(key: 'jwt_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      // [SECURITY] Gunakan debugPrint, bukan print — tidak akan muncul di build release
      // Hindari mencatat detail error yang mengandung token atau kredensial
      debugPrint('[AuthService] Login error: ${e.runtimeType}');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/register',
        data: {
          "username": username, // Harus persis sama dengan Swagger
          "email": email, // Harus persis sama dengan Swagger
          "password": password, // Harus persis sama dengan Swagger
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[AuthService] Register error: ${e.toString()}');
      return false;
    }
  }

  // Fungsi Logout untuk menghapus token
  Future<void> logout() async {
    await _apiClient.storage.delete(key: 'jwt_token');
  }
}
