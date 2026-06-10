import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ⚠️ ATURAN IP ADDRESS (PENTING!):
  // Jika pakai Emulator Android bawaan laptop, gunakan: 'http://10.0.2.2:8000'
  // Jika pakai HP Fisik asli (colok kabel), gunakan IP laptopmu: 'http://192.168.1.xx:8000'
  
  final String baseUrl = 'http://192.168.0.160:8000'; // ip laptop pake wifi 
  // final String baseUrl = 'http://10.104.21.88:8000'; // ip laptop pake hotspot   

  ApiClient() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    // Interceptor: Otomatis menempelkan Token JWT di Header untuk endpoint yang terkunci
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}
