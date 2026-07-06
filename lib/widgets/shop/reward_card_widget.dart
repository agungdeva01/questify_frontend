import 'package:flutter/material.dart';
import '../../models/reward_model.dart';
// import '../shop/pixel_container.dart'; // Buka komentar jika menggunakan widget kustom pixel kamu
// import '../shop/pixel_button.dart';    // Buka komentar jika menggunakan widget kustom pixel kamu

class RewardCardWidget extends StatelessWidget {
  final RewardModel reward;
  final VoidCallback onRedeem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RewardCardWidget({
    Key? key,
    required this.reward,
    required this.onRedeem,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222A), // Warna gelap bergaya retro
        border: Border.all(
          color: const Color(0xFFE58F28),
          width: 3.0,
        ), // Border oranye
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(4, 4),
            blurRadius: 0, // Hard shadow bergaya piksel
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Judul dan Harga Koin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'Courier', // Ganti dengan font pixel di project kamu
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFF7D038),
                      size: 20,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      '${reward.cost} COINS',
                      style: const TextStyle(
                        color: Color(0xFFF7D038),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Kanan: Tombol Aksi (Redeem, Edit, Delete)
          Row(
            children: [
              // Tombol Beli / Redeem
              ElevatedButton(
                onPressed: reward.isActive ? onRedeem : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ), // Sudut kotak (pixel)
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'REDEEM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8.0),

              // Tombol Edit
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: onEdit,
                tooltip: 'Edit Reward',
              ),

              // Tombol Delete
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Hapus Reward',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
