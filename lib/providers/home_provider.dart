import 'package:flutter/material.dart';
import '../models/user_response.dart';
import '../models/quest_response.dart';
import '../services/user_service.dart';
import '../services/quest_service.dart';

/// Provider yang mengelola seluruh state data dinamis untuk HomeScreen.
/// Menggantikan mock data (level=1, exp=0.4, koin=25, username="Deva")
/// dengan data nyata dari backend FastAPI.
class HomeProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final QuestService _questService = QuestService();

  // ── State ─────────────────────────────────────────────────────────────────
  UserResponse? _user;
  List<QuestResponse> _quests = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // ── Getters ───────────────────────────────────────────────────────────────
  UserResponse? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  /// Hanya quest berstatus 'active' (sesuai panduan integration guide Section 4)
  List<QuestResponse> get activeQuests =>
      _quests.where((q) => q.isActive).toList();

  /// Jumlah quest yang sudah diselesaikan (untuk statistik di PlayerCard)
  int get completedQuestCount =>
      _quests.where((q) => q.status == 'completed').length;

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Memuat data profil + quest secara paralel dari backend.
  /// Dipanggil saat HomeScreen pertama kali di-mount (initState).
  Future<void> loadHomeData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    // Jalankan kedua request secara paralel untuk efisiensi
    final results = await Future.wait([
      _userService.getProfile(),
      _questService.getQuests(),
    ]);

    final UserResponse? fetchedUser = results[0] as UserResponse?;
    final List<QuestResponse>? fetchedQuests =
        results[1] as List<QuestResponse>?;

    if (fetchedUser == null) {
      // Jika profil gagal diambil, tampilkan error
      _hasError = true;
      _errorMessage = 'Gagal memuat data profil. Periksa koneksi.';
    } else {
      _user = fetchedUser;
      _quests = fetchedQuests ?? [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh ulang semua data (dipakai oleh pull-to-refresh atau setelah aksi)
  Future<void> refresh() => loadHomeData();
}
