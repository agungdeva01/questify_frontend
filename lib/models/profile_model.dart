class ProfileModel {
  final String id;
  final String username;
  final String heroClass;
  final int level;
  final int currentExp;
  final int maxExp;
  final String rank;
  final int gold;

  ProfileModel({
    required this.id,
    required this.username,
    required this.heroClass,
    required this.level,
    required this.currentExp,
    required this.maxExp,
    required this.rank,
    required this.gold,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '000',
      username: json['username'] ?? 'Unknown Hero',
      heroClass: json['heroClass'] ?? 'Novice',
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      maxExp: json['maxExp'] ?? 100,
      rank: json['rank'] ?? 'E',
      gold: json['gold'] ?? 0,
    );
  }
}
