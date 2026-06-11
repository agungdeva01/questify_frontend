import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/user_response.dart';

/// Service untuk endpoint /api/users
/// Token JWT dikirim otomatis oleh interceptor di ApiClient (tidak perlu manual).
class UserService {
  final ApiClient _apiClient = ApiClient();

  /// Mengambil data profil user yang sedang login.
  /// Endpoint: GET /api/users/me
  /// Header Authorization: Bearer {token} → ditempel otomatis oleh interceptor
  ///
  /// Returns [UserResponse] jika berhasil, null jika gagal.
  Future<UserResponse?> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/api/users/me');

      if (response.statusCode == 200) {
        // Parse JSON map menjadi model Dart UserResponse
        return UserResponse.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      // 401 sudah ditangani oleh interceptor (redirect ke Login)
      // Log hanya tipe error, bukan isi detail yang mungkin mengandung token
      debugPrint(
        '[UserService] getProfile error: ${e.response?.statusCode} ${e.type}',
      );
      return null;
    } catch (e) {
      debugPrint('[UserService] getProfile unexpected error: ${e.runtimeType}');
      return null;
    }
  }
}
