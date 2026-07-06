import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_response.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_container.dart';

// Base URL backend — harus konsisten dengan ApiClient
const String _kBaseUrl = 'http://192.168.56.1:8000';

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

  // ── Dialog Edit Username ───────────────────────────────────────────────────
  void _showEditUsernameDialog(BuildContext ctx, String currentUsername) {
    final controller = TextEditingController(text: currentUsername);

    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: PixelContainer(
            backgroundColor: AppTheme.secondaryNavy,
            borderColor: AppTheme.primaryWood,
            borderThickness: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'EDIT USERNAME',
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                      color: AppTheme.accentGold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Input field dengan style retro
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundCharcoal,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: TextField(
                      controller: controller,
                      style: Theme.of(
                        ctx,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      cursorColor: AppTheme.neonGreen,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                        hintText: 'Masukkan username baru...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Tombol Batal
                      Expanded(
                        child: PixelButton(
                          color: Colors.grey[700]!,
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                'BATAL',
                                style: TextStyle(
                                  fontFamily: 'VT323',
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Tombol Simpan
                      Expanded(
                        child: PixelButton(
                          color: AppTheme.neonGreen,
                          onPressed: () async {
                            Navigator.of(dialogCtx).pop();
                            final success = await ctx
                                .read<ProfileProvider>()
                                .editUsername(controller.text);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? '✅ Username berhasil diperbarui!'
                                        : '❌ Gagal memperbarui username.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  backgroundColor: success
                                      ? AppTheme.neonGreen
                                      : Colors.red[800],
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                'SIMPAN',
                                style: TextStyle(
                                  fontFamily: 'VT323',
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProv, child) {
        // State 1: Loading awal
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

        // State 3: Data kosong
        final UserResponse? data = profileProv.profileData;
        if (data == null) return const SizedBox();

        // ── Formula gamifikasi ──
        final int maxExp = data.level * 100;
        final double expProgress = (maxExp > 0)
            ? (data.exp / maxExp).clamp(0.0, 1.0)
            : 0.0;

        // State 4: Success
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                // ── Kotak Profil Utama ─────────────────────────────────────
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
                      // ── Avatar Dinamis + GestureDetector ────────────────
                      GestureDetector(
                        onTap: () async {
                          final success = await profileProv
                              .pickAndUploadAvatar();
                          if (context.mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '🖼️ Avatar berhasil diperbarui!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: AppTheme.neonGreen,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (context.mounted && !success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  '❌ Gagal mengupload avatar.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red[800],
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Avatar: network jika ada, icon default jika null
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryWood,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: data.avatarUrl != null
                                  ? Image.network(
                                      '$_kBaseUrl${data.avatarUrl}',
                                      filterQuality: FilterQuality.none,
                                      fit: BoxFit.cover,
                                      // Fallback ke icon jika gambar gagal dimuat
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme.accentGold,
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                            ),
                            // Badge kamera — petunjuk bahwa avatar bisa diklik
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppTheme.accentGold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Loading overlay saat upload sedang berjalan
                      if (profileProv.isUploading)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.accentGold,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // ── Username + Tombol Edit ───────────────────────────
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              data.username,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                _showEditUsernameDialog(context, data.username),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryWood,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Hero class statis
                      const Text(
                        'Adventurer',
                        style: TextStyle(
                          color: Color(0xFFFFC080),
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Statistik Status ─────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatBox('LEVEL', '${data.level}'),
                          _buildStatBox('STREAK', '${data.dailyStreak}🔥'),
                          _buildStatBox('COINS', '${data.coins}'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── EXP Bar ──────────────────────────────────────────
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
                              color: const Color(0xFF2ED573),
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

                // ── Tombol Logout ────────────────────────────────────────
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
