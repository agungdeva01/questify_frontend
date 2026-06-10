import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Konstanta Warna sesuai "Pixel Quest" DESIGN.md ---
  final Color surfaceBg = const Color(0xFF131313); // surface-dim
  final Color surfaceContainer = const Color(0xFF20201F);
  final Color woodDarkFrame = const Color(0xFF5D2E0A); // Dark brown frame
  final Color woodLightHighlight = const Color(0xFF8B4513); // primary-container
  final Color neonGreen = const Color(0xFF4AE176); // tertiary
  final Color goldCoin = const Color(0xFFFFB68C); // primary
  final Color textPrimary = const Color(0xFFE5E2E1); // on-surface
  final Color textSecondary = const Color(0xFFDAC2B6); // on-surface-variant

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: surfaceBg,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HUD / TOP BAR ---
            _buildHUD(authProvider),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // --- 2. HERO & STREAK SECTION ---
                    _buildHeroSection(authProvider),

                    const SizedBox(height: 24),

                    // --- 3. WOODEN BOARD (QUESTS) ---
                    _buildWoodenQuestBoard(),
                  ],
                ),
              ),
            ),

            // --- 4. BOTTOM NAVIGATION ---
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: HUD Atas ---
  Widget _buildHUD(AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: surfaceContainer,
        border: const Border(bottom: BorderSide(color: Colors.black, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info Player
          Expanded(
            child: Row(
              children: [
                // Avatar Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: surfaceBg,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(Icons.person, color: textPrimary, size: 32),
                ),
                const SizedBox(width: 12),
                // Text & EXP
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'LVL. ${auth.level}',
                            style: TextStyle(
                              color: goldCoin,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Space Mono',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              auth.username.toUpperCase(),
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Space Grotesk',
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // EXP Bar (Segmented 10% steps)
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E0E0E), // Charcoal background
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: auth.exp.clamp(0.0, 1.0),
                              child: Container(color: neonGreen),
                            ),
                            // Segmented Lines
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                9, // Membagi jadi 10 blok
                                (index) =>
                                    Container(width: 2, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Koin / Balance
          Column(
            children: [
              Icon(Icons.monetization_on, color: goldCoin, size: 28),
              const SizedBox(height: 4),
              Text(
                '${auth.koin}',
                style: TextStyle(
                  color: goldCoin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrains Mono',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Hero Area ---
  Widget _buildHeroSection(AuthProvider auth) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              // Karakter Hero
              Image.network(
                'https://i.pinimg.com/originals/11/4d/93/114d930f78a2f3a61f38e6822453e04e.gif',
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.directions_run, size: 100, color: textSecondary),
              ),
              // Platform Shadow
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          // Streak Badge (Mengambang di kanan atas)
          Positioned(
            top: -10,
            right: -20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: surfaceBg,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "3 DAYS",
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Space Grotesk',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Papan Kayu Quest (Wooden Boards dari DESIGN.md) ---
  Widget _buildWoodenQuestBoard() {
    return WoodenRetroContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_late, color: goldCoin, size: 24),
              const SizedBox(width: 8),
              Text(
                "URGENT QUESTS",
                style: TextStyle(
                  color: goldCoin,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 16,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const InteractiveQuestTile(
            title: "Deploy Backend FastAPI",
            rank: "S",
            rankColor: Color(0xFFFFB68C),
          ),
          const SizedBox(height: 12),
          const InteractiveQuestTile(
            title: "Beresin Laporan Forensik",
            rank: "A",
            rankColor: Color(0xFFBCC7DE),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: Bottom Nav (Home, Quests, Shop, Profile) ---
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: surfaceContainer,
        border: const Border(top: BorderSide(color: Colors.black, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, "Home", 0),
          _navItem(Icons.school, "Quests", 1), // school icon based on code.html
          _navItem(Icons.inventory_2, "Shop", 2),
          _navItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? surfaceBg : Colors.transparent,
          border: isActive ? Border.all(color: Colors.black, width: 2) : null,
          boxShadow: isActive
              ? const [BoxShadow(color: Colors.black, offset: Offset(0, 2))]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? neonGreen : textSecondary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? neonGreen : textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Space Grotesk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// KOMPONEN CUSTOM RPG HIGHEST FIDELITY
// ============================================================================

/// WIDGET: Wooden Board (Sesuai spesifikasi DESIGN.md)
/// Frame cokelat tua, highlight cokelat muda di bagian dalam, konten navy/gelap.
class WoodenRetroContainer extends StatelessWidget {
  final Widget child;

  const WoodenRetroContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer Black Border & Solid Shadow
      decoration: BoxDecoration(
        color: Colors.black, // Shadow and border color
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(0, 6))],
      ),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 4,
          right: 2,
        ), // Creates the drop shadow effect
        decoration: BoxDecoration(
          color: const Color(0xFF5D2E0A), // Dark Wood Frame
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Container(
          margin: const EdgeInsets.all(4), // Thickness of the dark wood frame
          decoration: BoxDecoration(
            color: const Color(0xFF131313), // Inner Navy/Dark area
            border: Border.all(
              color: const Color(0xFF8B4513),
              width: 2,
            ), // Light Wood Highlight
          ),
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ),
    );
  }
}

/// WIDGET: Quest Tile
class InteractiveQuestTile extends StatefulWidget {
  final String title;
  final String rank;
  final Color rankColor;

  const InteractiveQuestTile({
    super.key,
    required this.title,
    required this.rank,
    required this.rankColor,
  });

  @override
  State<InteractiveQuestTile> createState() => _InteractiveQuestTileState();
}

class _InteractiveQuestTileState extends State<InteractiveQuestTile> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isCompleted = !isCompleted),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF20201F), // surface-container
          border: Border.all(color: Colors.black, width: 2),
          // Subtle inner shadow effect on tiles
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4AE176) : Colors.black,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: isCompleted
                      ? const Color(0xFF8E9192)
                      : const Color(0xFFE5E2E1),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Rank Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.rankColor.withOpacity(0.15),
                border: Border.all(color: widget.rankColor, width: 2),
              ),
              child: Text(
                widget.rank,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: widget.rankColor,
                  fontSize: 14,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
