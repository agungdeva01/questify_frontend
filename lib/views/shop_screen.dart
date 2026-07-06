import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reward_provider.dart';
import '../widgets/shop/reward_card_widget.dart';
import '../widgets/shop/reward_form_dialog.dart';
import '../models/reward_model.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardProvider>(context, listen: false).fetchRewards();
    });
  }

  // =============================
  // DIALOG CREATE / EDIT
  // =============================
  void _showRewardDialog({RewardModel? reward}) {
    showDialog(
      context: context,
      builder: (context) => RewardFormDialog(
        reward: reward,
        onSubmit: (title, cost) async {
          final provider = Provider.of<RewardProvider>(context, listen: false);

          bool success;

          if (reward == null) {
            success = await provider.addReward(title, cost);
          } else {
            success = await provider.editReward(reward.id, title, cost);
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Berhasil menyimpan reward!'
                      : 'Gagal menyimpan reward',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131519),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            color: const Color(0xFF1E222A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REWARD SHOP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE58F28),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () => _showRewardDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'NEW REWARD',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF333842), height: 1),

          // LIST
          Expanded(
            child: Consumer<RewardProvider>(
              builder: (context, provider, child) {
                // LOADING
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE58F28)),
                  );
                }

                // ERROR (FIXED)
                if (provider.errorMessage != null &&
                    provider.errorMessage!.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${provider.errorMessage}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.fetchRewards(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                // EMPTY
                if (provider.rewards.isEmpty) {
                  return const Center(
                    child: Text(
                      'Toko masih kosong.\nKlik tombol "NEW REWARD"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                // LIST DATA
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = provider.rewards[index];

                    return RewardCardWidget(
                      reward: reward,

                      // =============================
                      // REDEEM (FIXED)
                      // =============================
                      onRedeem: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1E222A),
                            title: const Text(
                              'REDEEM REWARD',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              'Tukar ${reward.cost} Coins untuk "${reward.title}"?',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text(
                                  'TIDAK',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                ),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'YA, TUKAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final success = await provider.redeemReward(
                            reward.id.toString(),
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Berhasil menukar reward!'
                                      : 'Koin tidak cukup!',
                                ),
                                backgroundColor: success
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          }
                        }
                      },

                      // EDIT
                      onEdit: () => _showRewardDialog(reward: reward),

                      // DELETE
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1E222A),
                            title: const Text(
                              'HAPUS REWARD',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            content: Text(
                              'Yakin ingin menghapus "${reward.title}"?',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text(
                                  'BATAL',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'HAPUS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider.removeReward(reward.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
