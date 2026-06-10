import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../pixel_container.dart';

class PlayerCardWidget extends StatelessWidget {
  const PlayerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PixelContainer(
      backgroundColor: AppTheme.secondaryNavy,
      borderColor: AppTheme.primaryWood,
      borderThickness: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Baris Atas: Avatar + Nama + Stats ──────────────────────
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
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Nama player — Expanded agar tidak terdorong keluar
                Expanded(
                  child: Text(
                    'Deva',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
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
                ),
                const SizedBox(width: 5),
                Text(
                  '12',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppTheme.accentGold),
                ),
                const SizedBox(width: 16),
                // Coin + Koin number
                Image.asset(
                  'assets/images/coin.png',
                  width: 24,
                  height: 24,
                  filterQuality: FilterQuality.none,
                ),
                const SizedBox(width: 5),
                Text(
                  '23',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppTheme.neonGreen),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Baris Kedua: Segmented EXP Bar ─────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXP',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white70),
                ),
                Text(
                  '840/1000',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white70),
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
                  final isFilled = index < 8;
                  final isGlowing = index == 8;
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
                                  color: AppTheme.neonGreen.withValues(alpha: 0.6),
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

            // ── Baris Ketiga: NEXT REWARD mini bar ─────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NEXT REWARD',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.orange),
                ),
                Text(
                  '75%',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.orange),
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
                widthFactor: 0.75,
                child: Container(color: Colors.orange),
              ),
            ),
            const SizedBox(height: 20),

            // ── Baris Keempat: Dua Kotak Metrik ────────────────────────
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
                          vertical: 12.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
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
                                '07',
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
                          vertical: 12.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, color: AppTheme.neonGreen, size: 28),
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
                                '24',
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
  }
}
