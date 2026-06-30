import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../pixel_container.dart';
import '../pixel_button.dart';
import '../../providers/home_provider.dart';
import '../../models/quest_response.dart';

class ActiveQuestBoardWidget extends StatefulWidget {
  /// Callback dipanggil saat user menekan tombol COMPLETE pada salah satu kartu.
  /// Parent (HomeScreen) bertanggung jawab memanggil QuestProvider.completeQuest
  /// dan menampilkan Snackbar feedback.
  final Future<void> Function(String questId)? onComplete;

  const ActiveQuestBoardWidget({super.key, this.onComplete});

  @override
  State<ActiveQuestBoardWidget> createState() => _ActiveQuestBoardWidgetState();
}

class _ActiveQuestBoardWidgetState extends State<ActiveQuestBoardWidget> {
  /// ID quest yang sedang diproses. Digunakan untuk menampilkan loading
  /// state per-kartu dan mencegah double-tap.
  String? _questBeingCompleted;

  /// Dipanggil saat tombol COMPLETE ditekan pada satu kartu quest.
  Future<void> _onCompleteTapped(String questId) async {
    if (_questBeingCompleted != null) {
      return; // Abaikan jika ada yg sedang diproses
    }

    setState(() => _questBeingCompleted = questId);

    try {
      await widget.onComplete?.call(questId);
    } finally {
      // Pastikan state loading selalu direset meski terjadi error
      if (mounted) setState(() => _questBeingCompleted = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        final activeQuests = home.activeQuests;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section Header ──────────────────────────────────────────────
            Row(
              children: [
                const Expanded(
                  child: Divider(color: Colors.white24, thickness: 2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'ACTIVE QUEST BOARD',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white38),
                  ),
                ),
                const Expanded(
                  child: Divider(color: Colors.white24, thickness: 2),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Kondisi Jika Quest Kosong ───────────────────────────────────
            if (activeQuests.isEmpty)
              PixelContainer(
                backgroundColor: AppTheme.secondaryNavy.withValues(alpha: 0.5),
                borderColor: Colors.black,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        color: Colors.white24,
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No Active Quests Found',
                        style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Post a new quest above to start your journey!',
                        style: TextStyle(color: Colors.white12, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              // ── Daftar Card Quest Aktif ──────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeQuests.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final quest = activeQuests[index];
                  return _buildQuestCard(context, quest);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildQuestCard(BuildContext context, QuestResponse quest) {
    final bool isThisCardLoading = _questBeingCompleted == quest.id;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4ECD8),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Stack(
        children: [
          ..._buildCornerPins(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // ── Ikon Rank ───────────────────────────────────────────────
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryNavy,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    _rankIcon(quest.rank),
                    color: const Color(0xFFFFC080),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // ── Info Quest ──────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            color: Colors.black,
                            child: Text(
                              'RANK ${quest.rank}',
                              style: const TextStyle(
                                color: Color(0xFFFFC080),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '#${quest.id.substring(0, 4)}',
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quest.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.backgroundCharcoal,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // ── Tombol COMPLETE (PixelButton) ───────────────────────────
                PixelButton(
                  color: AppTheme.neonGreen,
                  onPressed: isThisCardLoading
                      ? () {} // No-op saat loading — efek press tetap ada tapi aksi dikosongkan
                      : () => _onCompleteTapped(quest.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: isThisCardLoading
                        // Loading indicator mini saat request berjalan
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        // Label COMPLETE dengan font VT323
                        : Text(
                            'COMPLETE',
                            style: TextStyle(
                              fontFamily: 'VT323',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerPins() {
    const pinColor = Color(0xFFBCC7DE);
    const pinSize = 5.0;
    const offset = 5.0;
    return [
      Positioned(
        top: offset,
        left: offset,
        child: Container(width: pinSize, height: pinSize, color: pinColor),
      ),
      Positioned(
        top: offset,
        right: offset + 4,
        child: Container(width: pinSize, height: pinSize, color: pinColor),
      ),
      Positioned(
        bottom: offset + 4,
        left: offset,
        child: Container(width: pinSize, height: pinSize, color: pinColor),
      ),
      Positioned(
        bottom: offset + 4,
        right: offset + 4,
        child: Container(width: pinSize, height: pinSize, color: pinColor),
      ),
    ];
  }

  IconData _rankIcon(String rank) {
    switch (rank) {
      case 'S':
        return Icons.menu_book;
      case 'A':
        return Icons.flash_on;
      case 'B':
        return Icons.vpn_key;
      case 'C':
        return Icons.gavel;
      default:
        return Icons.assignment;
    }
  }
}
