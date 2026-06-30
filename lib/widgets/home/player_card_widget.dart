import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../pixel_container.dart';
import '../../providers/home_provider.dart';

class PlayerCardWidget extends StatelessWidget {
  const PlayerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        // Gunakan data nyata dari backend (UserResponse)
        // Fallback ke nilai default saat data belum dimuat
        final user = home.user;
        final int level = user?.level ?? 1;
        final double expFraction = user?.expFraction ?? 0.0;
        final int expThreshold = user?.expThreshold ?? 100;
        final int expCurrent = user?.exp ?? 0;
        final int koin = user?.coins ?? 0;
        final String playerName = user?.username ?? '...';

        // Segmented EXP bar: 10 kotak, dihitung dari fraksi nyata backend
        final int filledCount = (expFraction * 10).floor();
        final bool hasGlow = filledCount < 10;

        return PixelContainer(
          backgroundColor: AppTheme.secondaryNavy,
          borderColor: AppTheme.primaryWood,
          borderThickness: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Baris Atas: Avatar + Nama + Stats ─────────────────────
                Row(
                  children: [
                    // Avatar pixel sprite
                    PixelContainer(
                      backgroundColor: AppTheme.backgroundCharcoal,
                      borderColor: AppTheme.primaryWoodLight,
                      borderThickness: 2.0,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Nama player — Expanded agar tidak terdorong keluar
                    Expanded(
                      child: Text(
                        playerName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Star + Level number
                    Image.asset(
                      'assets/images/star.png',
                      width: 32,
                      height: 32,
                      filterQuality: FilterQuality.none,
                      // Fallback defensif jika AssetManifest.bin gagal dimuat
                      // (terjadi saat Hot Restart di Windows desktop)
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.star,
                        color: AppTheme.accentGold,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$level',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppTheme.accentGold),
                    ),
                    const SizedBox(width: 16),
                    // Coin + Koin number
                    Image.asset(
                      'assets/images/coin.png',
                      width: 24,
                      height: 24,
                      filterQuality: FilterQuality.none,
                      // Fallback defensif jika AssetManifest.bin gagal dimuat
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.monetization_on,
                        color: AppTheme.accentGold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$koin',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppTheme.neonGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Baris Kedua: Segmented EXP Bar (Dinamis) ─────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXP',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                    ),
                    Text(
                      // Tampilkan: currentExp / threshold
                      '$expCurrent/$expThreshold',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCharcoal,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Row(
                    children: List.generate(10, (index) {
                      final isFilled = index < filledCount;
                      final isGlowing = hasGlow && index == filledCount;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: index < 9 ? 2.0 : 0),
                          decoration: BoxDecoration(
                            color: isFilled
                                ? AppTheme.neonGreen
                                : isGlowing
                                ? AppTheme.neonGreen.withValues(alpha: 0.5)
                                : AppTheme.backgroundCharcoal,
                            boxShadow: isFilled
                                ? [
                                    BoxShadow(
                                      color: AppTheme.neonGreen.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Baris Ketiga: NEXT REWARD mini bar ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NEXT REWARD',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.orange),
                    ),
                    Text(
                      '${(expFraction * 100).toStringAsFixed(0)}%',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCharcoal,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: expFraction,
                    child: Container(color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Baris Keempat: Dua Kotak Metrik ──────────────────────
                Row(
                  children: [
                    // Daily Streak
                    Expanded(
                      child: PixelContainer(
                        backgroundColor: AppTheme.primaryWoodLight,
                        borderColor: Colors.black,
                        borderThickness: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Streak',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                  Text(
                                    user?.dailyStreak.toString().padLeft(
                                          2,
                                          '0',
                                        ) ??
                                        '00',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Quests Done
                    Expanded(
                      child: PixelContainer(
                        backgroundColor: AppTheme.secondaryNavy,
                        borderColor: Colors.black,
                        borderThickness: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                color: AppTheme.neonGreen,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quests Done',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                  Text(
                                    '${home.completedQuestCount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
