import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/quest_response.dart';

/// Service untuk endpoint /api/quests
class QuestService {
  final ApiClient _apiClient = ApiClient();

  /// 1. CREATE: Membuat quest baru
  /// Endpoint: POST /api/quests/
  Future<QuestResponse?> createQuest(String title, String rank) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/quests/',
        data: {'title': title, 'rank': rank},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return QuestResponse.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('[QuestService] createQuest error: ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('[QuestService] createQuest unexpected error: $e');
      return null;
    }
  }

  /// 2. READ: Mengambil seluruh daftar quest milik user yang sedang login
  /// Endpoint: GET /api/quests/
  Future<List<QuestResponse>?> getQuests() async {
    try {
      final response = await _apiClient.dio.get('/api/quests/');

      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data as List<dynamic>;
        return rawList
            .map((item) => QuestResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } on DioException catch (e) {
      debugPrint('[QuestService] getQuests error: ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('[QuestService] getQuests unexpected error: $e');
      return null;
    }
  }

  /// 3. UPDATE: Menyelesaikan sebuah quest berdasarkan ID
  /// Endpoint: PUT /api/quests/{quest_id}/complete
  Future<QuestResponse?> completeQuest(String questId) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/quests/$questId/complete',
      );

      if (response.statusCode == 200) {
        return QuestResponse.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint(
        '[QuestService] completeQuest error: ${e.response?.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('[QuestService] completeQuest unexpected error: $e');
      return null;
    }
  }

  /// 4. DELETE: Menghapus sebuah quest berdasarkan ID
  /// Endpoint: DELETE /api/quests/{quest_id}
  Future<bool> deleteQuest(String questId) async {
    try {
      final response = await _apiClient.dio.delete('/api/quests/$questId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('[QuestService] deleteQuest error: ${e.response?.statusCode}');
      return false;
    } catch (e) {
      debugPrint('[QuestService] deleteQuest unexpected error: $e');
      return false;
    }
  }

  // Edit
  Future<bool> updateQuest(String questId, String title, String rank) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/quests/$questId', // Sesuaikan URL dengan dokumentasi backend/Swagger-mu
        data: {'title': title, 'rank': rank},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('[QuestService] updateQuest error: ${e.response?.statusCode}');
      return false;
    } catch (e) {
      debugPrint('[QuestService] updateQuest unexpected error: $e');
      return false;
    }
  }
}
