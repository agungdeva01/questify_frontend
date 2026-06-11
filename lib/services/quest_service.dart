import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/quest_response.dart';

/// Service untuk endpoint /api/quests
/// Token JWT dikirim otomatis oleh interceptor di ApiClient (tidak perlu manual).
class QuestService {
  final ApiClient _apiClient = ApiClient();

  /// Mengambil seluruh daftar quest milik user yang sedang login.
  /// Endpoint: GET /api/quests/
  /// Header Authorization: Bearer {token} → ditempel otomatis oleh interceptor
  ///
  /// Backend mengembalikan semua quest (active + completed).
  /// Filter lokal dilakukan di provider/widget sesuai panduan integration guide.
  ///
  /// Returns List of QuestResponse (bisa kosong), null jika request gagal.
  Future<List<QuestResponse>?> getQuests() async {
    try {
      final response = await _apiClient.dio.get('/api/quests/');

      if (response.statusCode == 200) {
        // Response adalah JSON array → cast ke List lalu parse tiap item
        final List<dynamic> rawList = response.data as List<dynamic>;
        return rawList
            .map((item) => QuestResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } on DioException catch (e) {
      // 401 sudah ditangani oleh interceptor (redirect ke Login)
      debugPrint(
        '[QuestService] getQuests error: ${e.response?.statusCode} ${e.type}',
      );
      return null;
    } catch (e) {
      debugPrint('[QuestService] getQuests unexpected error: ${e.runtimeType}');
      return null;
    }
  }
}
