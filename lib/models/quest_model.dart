class QuestResponse {
  final String id;
  final String userId;
  final String title;
  final String rank;
  final String status;

  QuestResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.rank,
    required this.status,
  });

  // Mengubah data JSON dari backend menjadi objek Dart
  factory QuestResponse.fromJson(Map<String, dynamic> json) {
    return QuestResponse(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      rank: json['rank'] ?? '',
      status: json['status'] ?? 'active', // Default ke active jika kosong
    );
  }

  // Mengubah objek Dart kembali menjadi JSON jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'rank': rank,
      'status': status,
    };
  }
}
