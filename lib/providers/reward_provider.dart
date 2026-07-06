import 'package:flutter/material.dart';
import '../models/reward_model.dart';
import '../services/reward_service.dart';
import 'home_provider.dart'; // Import HomeProvider

class RewardProvider with ChangeNotifier {
  final RewardService _service = RewardService();
  final HomeProvider _homeProvider; // Referensi ke HomeProvider

  // Constructor menerima HomeProvider
  RewardProvider(this._homeProvider);

  List<RewardModel> _rewards = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RewardModel> get rewards => _rewards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. Fetch Rewards
  Future<void> fetchRewards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.getRewards();
    if (result != null) {
      _rewards = result;
    } else {
      _errorMessage = 'Gagal mengambil daftar reward dari server.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. Redeem Reward (Sinkronisasi terjadi di sini)
  Future<bool> redeemReward(String id) async {
    // Panggil service untuk redeem
    final success = await _service.redeemReward(id);
    if (success) {
      // SETELAH SUKSES, REFRESH HOME AGAR KOIN BERKURANG
      await _homeProvider.loadHomeData();

      notifyListeners();
      return true;
    }
    return false;
  }

  // 3. Add Reward
  Future<bool> addReward(String title, int cost) async {
    final newReward = await _service.createReward(title, cost);
    if (newReward != null) {
      _rewards.add(newReward);
      notifyListeners();
      return true;
    }
    return false;
  }

  // 4. Edit Reward
  Future<bool> editReward(String id, String title, int cost) async {
    final updatedReward = await _service.updateReward(id, title, cost);
    if (updatedReward != null) {
      final index = _rewards.indexWhere((r) => r.id == id);
      if (index != -1) {
        _rewards[index] = updatedReward;
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  // 5. Remove Reward
  Future<bool> removeReward(String id) async {
    final success = await _service.deleteReward(id);
    if (success) {
      _rewards.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}
