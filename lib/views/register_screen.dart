import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryWood,
          content: Text(
            'USERNAME, EMAIL, dan PASSWORD wajib diisi!',
            style: GoogleFonts.vt323(color: Colors.white, fontSize: 16),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Kirim username + email + password ke backend sesuai API spec
    bool success = await authProvider.handleRegister(username, email, password);
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.neonGreen.withValues(alpha: 0.8),
            content: Text(
              'Pendaftaran Berhasil! Silakan Login.',
              style: GoogleFonts.vt323(color: Colors.black, fontSize: 16),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Text(
              'Register Gagal! Akun mungkin sudah terdaftar.',
              style: GoogleFonts.vt323(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  // ── Helper builder untuk kolom input bergaya retro ────────────────────────
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryNavy,
        border: Border.all(color: AppTheme.primaryWood, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
        cursorColor: AppTheme.accentGold,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.vt323(
            color: AppTheme.accentGold,
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: AppTheme.accentGold, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCharcoal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentGold),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Icon Pixel ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryNavy,
                  border: Border.all(color: AppTheme.accentGold, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 50,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 20),

              // ── Judul ──────────────────────────────────────────────────
              Text(
                'BUAT AKUN',
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Daftar dan mulai petualanganmu!',
                style: GoogleFonts.vt323(color: Colors.white54, fontSize: 18),
              ),
              const SizedBox(height: 36),

              // ── Field Username (BARU — di atas Email) ─────────────────
              _buildInputField(
                controller: _usernameController,
                label: 'USERNAME PETUALANG',
                icon: Icons.person,
              ),
              const SizedBox(height: 12),

              // ── Field Email ───────────────────────────────────────────
              _buildInputField(
                controller: _emailController,
                label: 'EMAIL',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // ── Field Password ────────────────────────────────────────
              _buildInputField(
                controller: _passwordController,
                label: 'PASSWORD',
                icon: Icons.lock,
                obscure: true,
              ),
              const SizedBox(height: 36),

              // ── Tombol Daftar ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Sudut kotak retro
                        ),
                        side: const BorderSide(color: Colors.black, width: 3),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ).copyWith(
                        // Block shadow khas pixel art
                        elevation: WidgetStateProperty.all(0),
                      ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'DAFTAR SEKARANG',
                          style: GoogleFonts.pressStart2p(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Link ke Login ─────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'SUDAH PUNYA AKUN? LOGIN',
                  style: GoogleFonts.vt323(
                    color: AppTheme.primaryWoodLight,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.primaryWoodLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
