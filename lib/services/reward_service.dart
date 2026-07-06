import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/reward_model.dart';

/// Service untuk endpoint /api/rewards
class RewardService {
  final ApiClient _apiClient = ApiClient();

  /// 1. READ: Mengambil seluruh daftar reward
  /// Endpoint: GET /api/rewards/
  Future<List<RewardModel>?> getRewards() async {
    try {
      final response = await _apiClient.dio.get('/api/rewards/');

      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data as List<dynamic>;
        return rawList
            .map((item) => RewardModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } on DioException catch (e) {
      debugPrint('[RewardService] getRewards error: ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('[RewardService] getRewards unexpected error: $e');
      return null;
    }
  }

  /// 2. CREATE: Membuat reward baru
  /// Endpoint: POST /api/rewards/
  Future<RewardModel?> createReward(String title, int cost) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/rewards/',
        data: {'title': title, 'cost': cost},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return RewardModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint(
        '[RewardService] createReward error: ${e.response?.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('[RewardService] createReward unexpected error: $e');
      return null;
    }
  }

  /// 3. UPDATE: Mengupdate reward berdasarkan ID
  /// Endpoint: PUT /api/rewards/{reward_id}
  Future<RewardModel?> updateReward(String id, String title, int cost) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/rewards/$id',
        data: {'title': title, 'cost': cost},
      );

      if (response.statusCode == 200) {
        return RewardModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint(
        '[RewardService] updateReward error: ${e.response?.statusCode}',
      );
      return null;
    } catch (e) {
      debugPrint('[RewardService] updateReward unexpected error: $e');
      return null;
    }
  }

  /// 4. DELETE: Menghapus reward berdasarkan ID
  /// Endpoint: DELETE /api/rewards/{reward_id}
  Future<bool> deleteReward(String id) async {
    try {
      final response = await _apiClient.dio.delete('/api/rewards/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      debugPrint(
        '[RewardService] deleteReward error: ${e.response?.statusCode}',
      );
      return false;
    } catch (e) {
      debugPrint('[RewardService] deleteReward unexpected error: $e');
      return false;
    }
  }

  /// 5. REDEEM: Menukarkan reward (Beli barang pakai koin)
  /// Endpoint: POST /api/rewards/redeem/{reward_id}
  Future<bool> redeemReward(String id) async {
    try {
      final response = await _apiClient.dio.post('/api/rewards/redeem/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint(
        '[RewardService] redeemReward error: ${e.response?.statusCode}',
      );
      return false;
    } catch (e) {
      debugPrint('[RewardService] redeemReward unexpected error: $e');
      return false;
    }
  }
}
