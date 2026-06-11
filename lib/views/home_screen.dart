import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/home_provider.dart';
import '../widgets/home/player_card_widget.dart';
import '../widgets/home/greeting_banner_widget.dart';
import '../widgets/home/active_quest_board_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Muat data profil + quest dari backend saat halaman pertama dibuka
    // Menggunakan addPostFrameCallback agar context sudah tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCharcoal,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _PixelBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.secondaryNavy,
      elevation: 0,
      toolbarHeight: 56,
      title: Text(
        'QUESTIFY',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: const Color(0xFFE5E2E1),
          letterSpacing: 2.0,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(color: Colors.black, height: 4.0),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _homeBody();
      default:
        return _comingSoonBody();
    }
  }

  Widget _homeBody() {
    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        // ── Loading State ────────────────────────────────────────────────
        if (home.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.accentGold),
          );
        }

        // ── Error State (dengan tombol retry) ───────────────────────────
        if (home.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
                const SizedBox(height: 16),
                Text(
                  home.errorMessage,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white38),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => home.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryWood,
                  ),
                  child: const Text('COBA LAGI'),
                ),
              ],
            ),
          );
        }

        // ── Success State: Render widget dengan data nyata ───────────────
        return RefreshIndicator(
          color: AppTheme.accentGold,
          onRefresh: home.refresh,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            children: const [
              PlayerCardWidget(),
              SizedBox(height: 28),
              GreetingBannerWidget(),
              SizedBox(height: 28),
              ActiveQuestBoardWidget(),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _comingSoonBody() {
    return Center(
      child: Text(
        'COMING SOON',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: Colors.white38),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Bottom Navigation Bar — pixel themed
// --------------------------------------------------------------------------

class _NavItem {
  final String label;
  final IconData iconData;
  const _NavItem(this.label, this.iconData);
}

class _PixelBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _PixelBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = const <_NavItem>[
      _NavItem('Home', Icons.home),
      _NavItem('Quest', Icons.assignment),
      _NavItem('Shop', Icons.store),
      _NavItem('Profile', Icons.person),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E),
        border: Border(top: BorderSide(color: Colors.black, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, -2), blurRadius: 0),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == selectedIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    border: isActive
                        ? Border.all(color: AppTheme.primaryWoodLight, width: 2)
                        : Border.all(color: Colors.transparent, width: 2),
                    color: isActive
                        ? AppTheme.primaryWood.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.iconData,
                        size: 28,
                        color: isActive
                            ? const Color(0xFFFFC080)
                            : const Color(
                                0xFF9E9E9E,
                              ), // Abu-abu medium untuk inaktif
                      ),
                      const SizedBox(height: 6), // Increased spacing
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isActive
                              ? const Color(
                                  0xFFFFC080,
                                ) // Brighter active color matching sprite
                              : const Color(
                                  0xFF9E9E9E,
                                ), // Abu-abu medium untuk inaktif
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
