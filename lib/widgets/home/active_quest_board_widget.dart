import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../pixel_container.dart';
import '../pixel_button.dart';
import '../../providers/home_provider.dart';
import '../../models/quest_response.dart';

class ActiveQuestBoardWidget extends StatelessWidget {
  const ActiveQuestBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        // Ambil hanya quest aktif dari HomeProvider (sudah difilter di provider)
        // Sesuai panduan integration guide Section 4: filter lokal di Flutter
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
            const SizedBox(height: 20),

            // ── Render quest aktif dari backend ─────────────────────────────
            if (activeQuests.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'TIDAK ADA QUEST AKTIF',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white24),
                  ),
                ),
              )
            else
              ...activeQuests.asMap().entries.map((entry) {
                final i = entry.key;
                final q = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < activeQuests.length - 1 ? 20.0 : 0,
                  ),
                  child: _buildQuestCard(context, quest: q),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildQuestCard(BuildContext context, {required QuestResponse quest}) {
    // Mapping rank ke icon — ikon dekoratif berdasarkan level rank
    final IconData iconData = _rankIcon(quest.rank);
    final Color iconColor = quest.rankColor;
    final String title = quest.title;
    final String exp = quest.expLabel;
    final String koin = quest.koinLabel;
    final String rank = quest.rank;
    final Color rankColor = quest.rankColor;
    final Color rankTextColor = quest.rankTextColor;

    return PixelContainer(
      backgroundColor: AppTheme.parchment,
      borderColor: Colors.black,
      borderThickness: 4.0,
      child: Stack(
        children: [
          // Silver corner pins (decorative pixel nails)
          ..._buildCornerPins(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Icon + Title + Rank Badge ─────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PixelContainer(
                      backgroundColor: iconColor,
                      borderColor: Colors.black,
                      borderThickness: 2.0,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Icon(iconData, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.backgroundCharcoal,
                                  fontSize:
                                      12, // Reduced font size to avoid overflow
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rank $rank Quest', // Label dinamis dari rank backend
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppTheme.secondaryNavy,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ── Rank Badge (Tebal + Block Shadow) ──────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: rankColor,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'RANK',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: rankTextColor,
                                  fontSize: 9,
                                  letterSpacing: 1,
                                ),
                          ),
                          Text(
                            rank,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: rankTextColor, fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Divider ─────────────────────────────────────────────
                Container(height: 2, color: Colors.black12),
                const SizedBox(height: 16),

                // ── Bottom Row: Rewards + COMPLETE button ───────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/star.png',
                          width: 28,
                          height: 28,
                          filterQuality: FilterQuality.none,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          exp,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          'assets/images/coin.png',
                          width: 20,
                          height: 20,
                          filterQuality: FilterQuality.none,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          koin,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                    PixelButton(
                      color: AppTheme.backgroundCharcoal,
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ),
                        child: Text(
                          'COMPLETE',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Decorative silver pixel pins at each corner of the parchment card
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

  /// Mapping rank letter ke IconData untuk dekorasi visual kartu quest
  IconData _rankIcon(String rank) {
    switch (rank) {
      case 'S':
        return Icons.menu_book;
      case 'A':
        return Icons.flash_on;
      case 'B':
        return Icons.vpn_key;
      case 'C':
        return Icons.star_outline;
      case 'D':
        return Icons.assignment;
      default:
        return Icons.help_outline;
    }
  }
}
