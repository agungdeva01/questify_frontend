import 'dart:io';
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
  Future<UserResponse?> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/api/users/me');
      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint(
        '[UserService] getProfile error: ${e.response?.statusCode} ${e.type}',
      );
      return null;
    } catch (e) {
      debugPrint('[UserService] getProfile unexpected error: ${e.runtimeType}');
      return null;
    }
  }

  /// Memperbarui username user yang sedang login.
  /// Endpoint: PUT /api/users/profile
  /// Body: {"username": newUsername}
  /// Returns true jika sukses, false jika gagal.
  Future<bool> updateUsername(String newUsername) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/users/profile',
        data: {'username': newUsername},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint(
        '[UserService] updateUsername error: ${e.response?.statusCode} ${e.type}',
      );
      return false;
    } catch (e) {
      debugPrint(
        '[UserService] updateUsername unexpected error: ${e.runtimeType}',
      );
      return false;
    }
  }

  /// Upload gambar avatar user ke server.
  /// Endpoint: POST /api/users/profile/avatar
  /// Menggunakan FormData + MultipartFile agar bisa mengirim binary file.
  /// Returns true jika sukses, false jika gagal.
  Future<bool> uploadAvatar(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiClient.dio.post(
        '/api/users/profile/avatar',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint(
        '[UserService] uploadAvatar error: ${e.response?.statusCode} ${e.type}',
      );
      return false;
    } catch (e) {
      debugPrint(
        '[UserService] uploadAvatar unexpected error: ${e.runtimeType}',
      );
      return false;
    }
  }
}
