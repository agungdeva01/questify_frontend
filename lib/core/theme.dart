import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme Colors
  static const Color backgroundCharcoal = Color(0xFF131313);
  static const Color primaryWood = Color(0xFF5D2E0A);
  static const Color primaryWoodLight = Color(0xFF8B4513);
  static const Color secondaryNavy = Color(0xFF3E495D);
  static const Color parchment = Color(0xFFE6DCC8);
  static const Color parchmentLight = Color(0xFFF4ECD8);
  static const Color neonGreen = Color(0xFF4AE176);
  static const Color accentGold = Color(0xFFFFA500);

  static ThemeData get dungeonTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundCharcoal,
      colorScheme: const ColorScheme.dark(
        primary: primaryWood,
        secondary: secondaryNavy,
        surface: backgroundCharcoal,
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        // Headlines using Press Start 2P
        displayLarge: GoogleFonts.pressStart2p(color: Colors.white),
        displayMedium: GoogleFonts.pressStart2p(color: Colors.white),
        displaySmall: GoogleFonts.pressStart2p(color: Colors.white),
        headlineLarge: GoogleFonts.pressStart2p(color: Colors.white),
        headlineMedium: GoogleFonts.pressStart2p(color: Colors.white),
        headlineSmall: GoogleFonts.pressStart2p(
          color: Colors.white,
          fontSize: 16,
        ),
        titleLarge: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 14),
        titleMedium: GoogleFonts.pressStart2p(
          color: Colors.white,
          fontSize: 12,
        ),
        titleSmall: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 10),

        // Body and Labels using VT323
        bodyLarge: GoogleFonts.vt323(color: Colors.white, fontSize: 20),
        bodyMedium: GoogleFonts.vt323(color: Colors.white, fontSize: 16),
        bodySmall: GoogleFonts.vt323(color: Colors.white, fontSize: 14),
        labelLarge: GoogleFonts.vt323(color: Colors.white, fontSize: 16),
        labelMedium: GoogleFonts.vt323(color: Colors.white, fontSize: 14),
        labelSmall: GoogleFonts.vt323(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
