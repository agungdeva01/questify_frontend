import 'package:flutter/material.dart';
import '../models/quest_response.dart';
import '../services/quest_service.dart';
import 'home_provider.dart'; // ← Dependency injection untuk sinkronisasi

class QuestProvider with ChangeNotifier {
  final QuestService _questService = QuestService();
  final HomeProvider _homeProvider; // ← Referensi ke HomeProvider

  // Constructor menerima HomeProvider dari luar (ProxyProvider di main.dart)
  QuestProvider(this._homeProvider);

  List<QuestResponse> _quests = [];
  bool _isLoading = false;

  List<QuestResponse> get quests => _quests;
  bool get isLoading => _isLoading;

  // Filter Lokal untuk dipisahkan di UI
  List<QuestResponse> get activeQuests =>
      _quests.where((q) => q.status.toLowerCase() != 'completed').toList();
  List<QuestResponse> get completedQuests =>
      _quests.where((q) => q.status.toLowerCase() == 'completed').toList();

  // READ
  Future<void> loadQuests() async {
    _isLoading = true;
    notifyListeners();

    final data = await _questService.getQuests();
    if (data != null) {
      _quests = data;
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<bool> addNewQuest(String title, String rank) async {
    if (title.trim().isEmpty) return false;
    final newQuest = await _questService.createQuest(title, rank);
    if (newQuest != null) {
      await loadQuests(); // Refresh list quest
      await _homeProvider
          .loadHomeData(); // Sinkronisasi: update angka statistik di PlayerCard
      return true;
    }
    return false;
  }

  // UPDATE (Complete)
  Future<bool> completeQuest(String id) async {
    final updated = await _questService.completeQuest(id);
    if (updated != null) {
      await loadQuests(); // Refresh list quest di QuestScreen
      await _homeProvider
          .loadHomeData(); // Sinkronisasi: refresh profil + EXP + Koin di HomeScreen
      return true;
    }
    return false;
  }

  // DELETE
  Future<bool> deleteQuest(String id) async {
    final success = await _questService.deleteQuest(id);
    if (success) {
      await loadQuests(); // Refresh list quest
      await _homeProvider
          .loadHomeData(); // Sinkronisasi: update statistik di PlayerCard
      return true;
    }
    return false;
  }

  // EDIT

  Future<bool> updateQuest(String id, String title, String rank) async {
    // Panggil method baru yang kita buat di service tadi
    final success = await _questService.updateQuest(id, title, rank);

    if (success) {
      await loadQuests(); // Refresh data setelah berhasil update
      return true;
    }
    return false;
  }
}
