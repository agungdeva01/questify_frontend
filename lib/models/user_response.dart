/// Model Dart yang merefleksikan struktur JSON /api/users/me dari backend.
/// Sesuai dengan spesifikasi di frontend_integration_guide.md Section 3A.
class UserResponse {
  final String id;
  final String username;
  final String email;
  final int level;
  final int exp;
  final int coins;
  final int dailyStreak;
  final String createdAt;

  const UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.level,
    required this.exp,
    required this.coins,
    required this.dailyStreak,
    required this.createdAt,
  });

  /// Parse dari JSON map yang diterima Dio
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      level: (json['level'] as num).toInt(),
      exp: (json['exp'] as num).toInt(),
      coins: (json['coins'] as num).toInt(),
      dailyStreak: (json['daily_streak'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String,
    );
  }

  /// Hitung fraksi EXP untuk progress bar (0.0 – 1.0)
  /// Formula dari backend: threshold = level × 100
  double get expFraction {
    final int threshold = level * 100;
    if (threshold <= 0) return 0.0;
    return (exp / threshold).clamp(0.0, 1.0);
  }

  /// Nilai threshold EXP untuk naik level berikutnya
  int get expThreshold => level * 100;
}
