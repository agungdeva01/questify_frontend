import 'package:flutter/material.dart';

/// Model Dart yang merefleksikan struktur JSON QuestResponse dari backend.
/// Sesuai dengan spesifikasi di frontend_integration_guide.md Section 4 & 6.
class QuestResponse {
  final String id;
  final String userId;
  final String title;
  final String rank; // 'S' | 'A' | 'B' | 'C' | 'D'
  final String status; // 'active' | 'completed'

  const QuestResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.rank,
    required this.status,
  });

  /// Parse dari JSON map yang diterima Dio
  factory QuestResponse.fromJson(Map<String, dynamic> json) {
    return QuestResponse(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      rank: json['rank'] as String,
      status: json['status'] as String,
    );
  }

  /// Apakah quest ini masih aktif?
  bool get isActive => status == 'active';

  /// EXP reward per rank sesuai standar RPG Questify
  String get expLabel {
    const expMap = {
      'S': '+250 EXP',
      'A': '+100 EXP',
      'B': '+50 EXP',
      'C': '+25 EXP',
      'D': '+10 EXP',
    };
    return expMap[rank] ?? '+10 EXP';
  }

  /// Koin reward per rank sesuai standar RPG Questify
  String get koinLabel {
    const koinMap = {
      'S': '+150 KOIN',
      'A': '+60 KOIN',
      'B': '+30 KOIN',
      'C': '+15 KOIN',
      'D': '+5 KOIN',
    };
    return koinMap[rank] ?? '+5 KOIN';
  }

  /// Warna badge rank untuk UI pixel art
  Color get rankColor {
    switch (rank) {
      case 'S':
        return const Color(0xFFFFD700); // Emas Legendaris
      case 'A':
        return const Color(0xFF9C27B0); // Ungu
      case 'B':
        return const Color(0xFF2196F3); // Biru
      case 'C':
        return const Color(0xFF4CAF50); // Hijau
      case 'D':
        return const Color(0xFF9E9E9E); // Abu-abu
      default:
        return Colors.grey;
    }
  }

  /// Warna teks di atas badge rank
  Color get rankTextColor {
    switch (rank) {
      case 'S':
        return Colors.black; // Teks hitam di atas emas
      case 'A':
        return Colors.white; // Teks putih di atas ungu
      case 'B':
        return Colors.white; // Teks putih di atas biru
      case 'C':
        return Colors.white; // Teks putih di atas hijau
      case 'D':
        return Colors.black; // Teks hitam di atas abu-abu
      default:
        return Colors.white;
    }
  }
}
