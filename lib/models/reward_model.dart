class RewardModel {
  final String id;
  final String title;
  final int cost;
  final bool isActive;

  RewardModel({
    required this.id,
    required this.title,
    required this.cost,
    required this.isActive,
  });

  // Convert dari JSON (Response Swagger)
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      cost: json['cost'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  // Convert ke JSON (Untuk request body Create/Update)
  Map<String, dynamic> toJson() {
    return {'title': title, 'cost': cost};
  }

  // Salinan model dengan nilai baru
  RewardModel copyWith({String? id, String? title, int? cost, bool? isActive}) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      cost: cost ?? this.cost,
      isActive: isActive ?? this.isActive,
    );
  }
}
