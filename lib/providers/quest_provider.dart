import 'package:flutter/material.dart';
import '../models/quest_response.dart';
import '../services/quest_service.dart';

class QuestProvider with ChangeNotifier {
  final QuestService _questService = QuestService();

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
      await loadQuests(); // Refresh data otomatis setelah create
      return true;
    }
    return false;
  }

  // UPDATE (Complete)
  Future<bool> completeQuest(String id) async {
    final updated = await _questService.completeQuest(id);
    if (updated != null) {
      await loadQuests(); // Refresh data otomatis setelah update
      return true;
    }
    return false;
  }

  // DELETE
  Future<bool> deleteQuest(String id) async {
    final success = await _questService.deleteQuest(id);
    if (success) {
      await loadQuests(); // Refresh data otomatis setelah delete
      return true;
    }
    return false;
  }
}
