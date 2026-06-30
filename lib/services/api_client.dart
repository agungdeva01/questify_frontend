import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_router.dart';
import '../views/login_screen.dart';

class ApiClient {
  final Dio dio = Dio();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ⚠️ ATURAN IP ADDRESS (PENTING!):
  // Jika pakai Emulator Android bawaan laptop, gunakan: 'http://10.0.2.2:8000'
  // Jika pakai HP Fisik asli (colok kabel), gunakan IP laptopmu: 'http://192.168.1.xx:8000'

  // final String baseUrl = 'http://192.168.0.160:8000'; // ip laptop pake wifi
  // final String baseUrl = 'http://10.176.63.88:8000'; // ip laptop pake hotspot
  final String baseUrl = 'http://192.168.18.30:8000'; // ip laptop pake hotspot

  ApiClient() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    // Interceptor Ganda: (1) Auto-attach JWT Header, (2) 401 → Redirect Login
    dio.interceptors.add(
      InterceptorsWrapper(
        // [1] Sebelum Request: Tempelkan token JWT ke setiap header secara otomatis
        onRequest: (options, handler) async {
          final String? token = await storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // [2] Saat Error: Tangkap 401 Unauthorized → hapus token kadaluarsa → paksa logout
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Hapus token kadaluarsa dari secure storage secara aman
            await storage.delete(key: 'jwt_token');

            // Arahkan user ke LoginScreen, hapus seluruh stack navigasi sebelumnya
            // Menggunakan navigatorKey global agar tidak perlu BuildContext di sini
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false, // Hapus semua halaman sebelumnya dari stack
            );
          }
          return handler.next(e);
        },
      ),
    );
  }
}
