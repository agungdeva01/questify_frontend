import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_response.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/pixel_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProv, child) {
        // State 1: Loading
        if (profileProv.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.accentGold),
          );
        }

        // State 2: Error
        if (profileProv.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
                const SizedBox(height: 16),
                Text(
                  profileProv.errorMessage,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => profileProv.fetchProfileData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryWood,
                  ),
                  child: const Text('COBA LAGI'),
                ),
              ],
            ),
          );
        }

        // State 3: Data kosong (belum dimuat)
        final UserResponse? data = profileProv.profileData;
        if (data == null) return const SizedBox();

        // ── Formula gamifikasi (sesuai integration guide Section 8) ──
        final int maxExp = data.level * 100;
        final double expProgress = (maxExp > 0)
            ? (data.exp / maxExp).clamp(0.0, 1.0)
            : 0.0;

        // State 4: Success
        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // ── Kotak Profil Utama ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppTheme.secondaryNavy,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Avatar Placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryWood,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Username dari backend
                  Text(
                    data.username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Hero class — statis karena field ini tidak ada di backend spec
                  const Text(
                    'Adventurer',
                    style: TextStyle(
                      color: Color(0xFFFFC080),
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Statistik Status ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox('LEVEL', '${data.level}'),
                      _buildStatBox('STREAK', '${data.dailyStreak}🔥'),
                      // data.coins menggantikan gold (field tidak ada di backend)
                      _buildStatBox('COINS', '${data.coins}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── EXP Bar ──────────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'EXPERIENCE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          // data.exp menggantikan currentExp, maxExp = level * 100
                          Text(
                            '${data.exp} / $maxExp',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: LinearProgressIndicator(
                          value: expProgress,
                          backgroundColor: AppTheme.backgroundCharcoal,
                          color: const Color(0xFF2ED573), // Hijau RPG
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Next Level: ${(expProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ── Tombol Logout ──────────────────────────────────────────────
            PixelButton(
              color: Colors.red[800]!,
              onPressed: () =>
                  context.read<AuthProvider>().handleLogout(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
