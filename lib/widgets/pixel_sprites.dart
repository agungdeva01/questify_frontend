import 'package:flutter/material.dart';

// --------------------------------------------------------------------------
// Core pixel rendering engine
// --------------------------------------------------------------------------

typedef PixelGrid = List<List<int>>;

class _PixelPainter extends CustomPainter {
  final PixelGrid pixels;
  final Map<int, Color> palette;
  final double pixelSize;

  const _PixelPainter({
    required this.pixels,
    required this.palette,
    required this.pixelSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    for (int row = 0; row < pixels.length; row++) {
      final rowData = pixels[row];
      for (int col = 0; col < rowData.length; col++) {
        final code = rowData[col];
        if (code == 0) continue;
        final color = palette[code];
        if (color == null) continue;
        paint.color = color;
        canvas.drawRect(
          Rect.fromLTWH(col * pixelSize, row * pixelSize, pixelSize, pixelSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelPainter old) =>
      old.pixelSize != pixelSize || old.palette != palette;
}

/// Base widget for rendering any pixel art sprite via integer grid + color palette.
class PixelIcon extends StatelessWidget {
  final PixelGrid pixels;
  final Map<int, Color> palette;
  final double pixelSize;

  const PixelIcon({
    super.key,
    required this.pixels,
    required this.palette,
    this.pixelSize = 2.0, // Default 2px for higher density (16-bit style)
  });

  @override
  Widget build(BuildContext context) {
    if (pixels.isEmpty) return const SizedBox.shrink();
    final w = pixels[0].length * pixelSize;
    final h = pixels.length * pixelSize;
    return SizedBox(
      width: w,
      height: h,
      child: CustomPaint(
        painter: _PixelPainter(
          pixels: pixels,
          palette: palette,
          pixelSize: pixelSize,
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Sprite factory — High Fidelity 16-bit icons
// --------------------------------------------------------------------------

class PixelSprites {
  PixelSprites._();

  // Shared palette constants
  static const Color _gold       = Color(0xFFFFA500);
  static const Color _goldBright = Color(0xFFFFD700);
  static const Color _goldDark   = Color(0xFFCC8800);
  static const Color _neonGreen  = Color(0xFF4AE176);
  static const Color _fireRed    = Color(0xFFFF4500);
  static const Color _fireOrange = Color(0xFFFF7700);
  static const Color _fireYellow = Color(0xFFFFDD00);
  static const Color _silver     = Color(0xFFCCCCCC);
  static const Color _silverDark = Color(0xFF888888);
  static const Color _brown      = Color(0xFF8B4513);
  static const Color _darkBrown  = Color(0xFF5D2E0A);
  static const Color _parchment  = Color(0xFFD2B48C);
  
  static const Color _dimNav     = Color(0xFF6B5047);
  static const Color _activeNav  = Color(0xFFFFC080); // Lebih menyala

  // ── STAR (level indicator) ─────────────────────────────────────────────
  static Widget star({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _goldDark, 2: _gold, 3: _goldBright},
    pixels: const [
      [0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,1,3,3,1,0,0,0,0,0,0],
      [0,0,0,0,0,1,3,2,2,3,1,0,0,0,0,0],
      [0,0,0,0,1,3,2,2,2,2,3,1,0,0,0,0],
      [1,1,1,1,3,2,2,2,2,2,2,3,1,1,1,1],
      [0,1,3,3,2,2,2,2,2,2,2,2,3,3,1,0],
      [0,0,1,3,2,2,2,2,2,2,2,2,3,1,0,0],
      [0,0,0,1,3,2,2,2,2,2,2,3,1,0,0,0],
      [0,0,0,0,1,3,2,2,2,2,3,1,0,0,0,0],
      [0,0,0,0,1,3,2,2,2,2,3,1,0,0,0,0],
      [0,0,0,1,3,2,2,1,1,2,2,3,1,0,0,0],
      [0,0,1,3,2,2,1,0,0,1,2,2,3,1,0,0],
      [0,1,3,2,2,1,0,0,0,0,1,2,2,3,1,0],
      [1,3,2,1,1,0,0,0,0,0,0,1,1,2,3,1],
      [1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1],
    ],
  );

  // ── COIN (koin indicator) ──────────────────────────────────────────────
  static Widget coin({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _goldDark, 2: _gold, 3: _goldBright},
    pixels: const [
      [0,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
      [0,0,1,1,2,2,3,3,3,2,2,1,1,0,0],
      [0,1,2,2,3,3,3,3,3,3,2,2,1,0,0],
      [0,1,2,3,3,3,2,2,3,3,3,2,1,0,0],
      [1,2,3,3,3,2,2,2,2,3,3,3,2,1,0],
      [1,2,3,3,2,2,2,2,2,2,3,3,2,1,0],
      [1,3,3,2,2,2,2,2,2,2,2,3,3,1,0],
      [1,3,3,2,2,2,1,1,1,2,2,3,3,1,0],
      [1,3,3,2,2,1,3,3,3,1,2,3,3,1,0],
      [1,2,3,3,2,2,1,1,1,2,2,3,2,1,0],
      [1,2,3,3,3,2,2,2,2,3,3,3,2,1,0],
      [0,1,2,3,3,3,2,2,3,3,3,2,1,0,0],
      [0,1,2,2,3,3,3,3,3,3,2,2,1,0,0],
      [0,0,1,1,2,2,3,3,3,2,2,1,1,0,0],
      [0,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
    ],
  );

  // ── FIRE (daily streak) ───────────────────────────────────────────────
  static Widget fire({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _fireRed, 2: _fireOrange, 3: _fireYellow},
    pixels: const [
      [0,0,0,0,0,0,1,1,0,0,0,0,0,0],
      [0,0,0,0,0,1,2,2,1,0,0,0,0,0],
      [0,0,0,0,1,2,3,3,2,1,0,0,0,0],
      [0,0,0,1,2,3,3,3,3,2,1,0,0,0],
      [0,0,1,2,3,3,3,3,3,2,1,0,0,0],
      [0,1,2,3,3,2,1,1,2,3,2,1,0,0],
      [1,2,3,3,2,1,0,0,1,2,3,2,1,0],
      [1,2,3,3,2,1,0,0,0,1,2,3,2,1],
      [1,2,3,3,2,1,0,0,1,2,3,3,2,1],
      [0,1,2,3,3,2,1,1,2,3,3,2,1,0],
      [0,0,1,2,3,3,3,3,3,3,2,1,0,0],
      [0,0,0,1,1,2,3,3,2,1,1,0,0,0],
      [0,0,0,0,0,1,1,1,1,0,0,0,0,0],
    ],
  );

  // ── CHECKMARK (quests done) ───────────────────────────────────────────
  static Widget check({double pixelSize = 2.5}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _neonGreen, 2: Color(0xFF2A8F4A)},
    pixels: const [
      [0,0,0,0,0,0,0,0,0,0,1,1,0],
      [0,0,0,0,0,0,0,0,0,1,3,1,0],
      [0,0,0,0,0,0,0,0,1,3,1,0,0],
      [0,0,0,0,0,0,0,1,3,1,0,0,0],
      [0,0,0,0,0,0,1,3,1,0,0,0,0],
      [1,1,0,0,0,1,3,1,0,0,0,0,0],
      [1,3,1,0,1,3,1,0,0,0,0,0,0],
      [0,1,3,1,3,1,0,0,0,0,0,0,0],
      [0,0,1,3,1,0,0,0,0,0,0,0,0],
      [0,0,0,1,0,0,0,0,0,0,0,0,0],
    ],
  );

  // ── BOOK (Main Quest icon) ────────────────────────────────────────────
  static Widget book({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _darkBrown, 2: _brown, 3: _parchment},
    pixels: const [
      [0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
      [0,0,1,2,2,2,2,2,1,2,2,2,2,2,2,2,1,0,0],
      [0,1,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,1,0],
      [1,3,3,1,1,1,3,3,1,3,3,1,1,1,3,3,3,3,1],
      [1,3,3,1,1,1,3,3,1,3,3,1,1,1,3,3,3,3,1],
      [1,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,1],
      [1,3,3,1,1,1,3,3,1,3,3,1,1,1,3,3,3,3,1],
      [1,3,3,1,1,1,3,3,1,3,3,1,1,1,3,3,3,3,1],
      [1,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,1],
      [1,3,3,1,1,3,3,3,1,3,3,1,1,3,3,3,3,3,1],
      [1,3,3,3,3,3,3,3,1,3,3,3,3,3,3,3,3,3,1],
      [1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,1],
      [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
    ],
  );

  // ── SWORD (Sub Quest icon) ────────────────────────────────────────────
  static Widget sword({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _silver, 2: _silverDark, 3: _gold, 4: _darkBrown, 5: Colors.black},
    pixels: const [
      [0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,1,2,1,5],
      [0,0,0,0,0,0,0,0,0,0,0,1,2,1,5,0],
      [0,0,0,0,0,0,0,0,0,0,1,2,1,5,0,0],
      [0,0,0,0,0,0,0,0,0,1,2,1,5,0,0,0],
      [0,0,0,0,0,0,0,0,1,2,1,5,0,0,0,0],
      [0,0,0,0,0,0,0,1,2,1,5,0,0,0,0,0],
      [0,0,0,0,0,0,1,2,1,5,0,0,0,0,0,0],
      [0,0,0,3,3,1,2,1,5,3,3,0,0,0,0,0],
      [0,0,0,0,3,3,1,5,3,3,0,0,0,0,0,0],
      [0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0],
      [0,0,0,0,0,4,4,3,0,0,0,0,0,0,0,0],
      [0,0,0,0,4,4,5,0,0,0,0,0,0,0,0,0],
      [0,0,0,4,4,5,0,0,0,0,0,0,0,0,0,0],
      [0,0,3,3,5,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,3,5,0,0,0,0,0,0,0,0,0,0,0,0],
    ],
  );

  // ── KEY (Skill Quest icon) ────────────────────────────────────────────
  static Widget key({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _gold, 2: _goldBright, 3: _goldDark, 4: Colors.black},
    pixels: const [
      [0,0,0,0,0,4,4,4,4,4,0,0,0,0,0,0],
      [0,0,0,0,4,2,2,2,2,2,4,0,0,0,0,0],
      [0,0,0,4,2,2,1,1,1,2,2,4,0,0,0,0],
      [0,0,4,2,1,1,4,4,4,1,1,2,4,0,0,0],
      [0,0,4,2,1,4,0,0,0,4,1,2,4,0,0,0],
      [0,0,4,2,1,4,0,0,0,4,1,2,4,0,0,0],
      [0,0,4,2,1,1,4,4,4,1,1,2,4,0,0,0],
      [0,0,0,4,2,2,1,1,1,2,2,4,0,0,0,0],
      [0,0,0,0,4,2,2,2,2,2,4,0,0,0,0,0],
      [0,0,0,0,0,4,4,1,2,4,0,0,0,0,0,0],
      [0,0,0,0,0,0,4,1,2,4,4,4,0,0,0,0],
      [0,0,0,0,0,0,4,1,2,1,1,4,0,0,0,0],
      [0,0,0,0,0,0,4,1,2,4,4,4,0,0,0,0],
      [0,0,0,0,0,0,4,1,2,1,1,4,0,0,0,0],
      [0,0,0,0,0,0,4,1,2,4,4,4,0,0,0,0],
      [0,0,0,0,0,0,0,4,4,4,0,0,0,0,0,0],
    ],
  );

  // ── TRENDING UP (EXP reward arrow) ────────────────────────────────────
  static Widget trendingUp({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _neonGreen, 2: Color(0xFF2A8F4A)},
    pixels: const [
      [0,0,0,0,0,0,0,1,1,1,1,1],
      [0,0,0,0,0,0,0,1,2,2,1,1],
      [0,0,0,0,0,0,1,1,1,2,1,1],
      [0,0,0,0,0,1,1,0,0,1,1,1],
      [0,0,0,0,1,1,0,0,0,0,1,1],
      [0,0,0,1,1,0,0,0,0,0,0,0],
      [1,1,1,1,0,0,0,0,0,0,0,0],
      [1,2,1,1,0,0,0,0,0,0,0,0],
    ],
  );

  // ── PLUS (Post New Quest button icon) ─────────────────────────────────
  static Widget plus({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: Color(0xFFFFFFFF), 2: Color(0xFFCCCCCC)},
    pixels: const [
      [0,0,0,0,1,1,1,1,0,0,0,0],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [1,1,1,1,1,2,2,1,1,1,1,1],
      [1,2,2,2,2,2,2,2,2,2,2,1],
      [1,2,2,2,2,2,2,2,2,2,2,1],
      [1,1,1,1,1,2,2,1,1,1,1,1],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [0,0,0,0,1,2,2,1,0,0,0,0],
      [0,0,0,0,1,1,1,1,0,0,0,0],
    ],
  );

  // ── AVATAR PLACEHOLDER (player silhouette) ────────────────────────────
  static Widget avatar({double pixelSize = 2.0}) => PixelIcon(
    pixelSize: pixelSize,
    palette: const {1: _darkBrown, 2: _brown, 3: _parchment, 4: Colors.black, 5: _goldBright},
    pixels: const [
      [0,0,0,0,1,1,1,1,1,1,0,0,0,0],
      [0,0,0,1,2,2,2,2,2,2,1,0,0,0],
      [0,0,1,2,2,2,2,2,2,2,2,1,0,0],
      [0,1,2,2,3,3,3,3,3,3,2,2,1,0],
      [0,1,2,3,3,3,3,3,3,3,3,2,1,0],
      [0,1,2,3,4,4,3,3,4,4,3,2,1,0],
      [0,1,2,3,4,5,3,3,5,4,3,2,1,0],
      [0,1,2,3,3,3,3,3,3,3,3,2,1,0],
      [0,0,1,2,3,3,4,4,3,3,2,1,0,0],
      [0,0,0,1,2,3,3,3,3,2,1,0,0,0],
      [0,0,1,1,1,2,2,2,2,1,1,1,0,0],
      [0,1,2,2,2,1,1,1,1,2,2,2,1,0],
      [1,2,2,2,2,2,1,1,2,2,2,2,2,1],
      [1,2,2,1,2,2,1,1,2,2,1,2,2,1],
      [1,2,1,0,1,2,1,1,2,1,0,1,2,1],
      [1,1,0,0,0,1,1,1,1,0,0,0,1,1],
    ],
  );

  // ── NAV: TAVERN (kedai kayu) ──────────────────────────────────────────
  static Widget tavern({double pixelSize = 2.0, bool isActive = false}) {
    final c1 = isActive ? _activeNav : _dimNav;
    final c2 = isActive ? _activeNav.withValues(alpha: 0.7) : _dimNav.withValues(alpha: 0.7);
    final c3 = isActive ? _activeNav.withValues(alpha: 0.4) : _dimNav.withValues(alpha: 0.4);
    return PixelIcon(
      pixelSize: pixelSize,
      palette: {1: c1, 2: c2, 3: c3},
      pixels: const [
        [0,0,0,0,0,0,1,1,0,0,0,0,0,0],
        [0,0,0,0,0,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,1,2,2,2,2,1,0,0,0,0],
        [0,0,0,1,2,2,2,2,2,2,1,0,0,0],
        [0,0,1,2,2,2,2,2,2,2,2,1,0,0],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,0],
        [0,1,2,2,2,2,2,2,2,2,2,2,1,0],
        [0,1,2,1,1,2,2,2,2,1,1,2,1,0],
        [0,1,2,1,3,1,2,2,1,3,1,2,1,0],
        [0,1,2,1,1,1,2,2,1,1,1,2,1,0],
        [0,1,2,2,2,2,2,2,2,2,2,2,1,0],
        [0,1,2,2,2,1,1,1,1,2,2,2,1,0],
        [0,1,2,2,2,1,3,3,1,2,2,2,1,0],
        [0,1,1,1,1,1,3,3,1,1,1,1,1,0],
      ],
    );
  }

  // ── NAV: SCROLLS (gulungan kertas) ────────────────────────────────────
  static Widget scroll({double pixelSize = 2.0, bool isActive = false}) {
    final c1 = isActive ? _activeNav : _dimNav;
    final c2 = isActive ? _activeNav.withValues(alpha: 0.7) : _dimNav.withValues(alpha: 0.7);
    final c3 = isActive ? _activeNav.withValues(alpha: 0.4) : _dimNav.withValues(alpha: 0.4);
    return PixelIcon(
      pixelSize: pixelSize,
      palette: {1: c1, 2: c2, 3: c3},
      pixels: const [
        [0,0,0,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,1,2,2,2,2,2,2,2,1,0,0,0],
        [0,1,2,1,1,1,1,1,1,2,2,1,0,0],
        [0,1,2,1,3,3,3,3,1,2,2,1,0,0],
        [0,1,2,1,1,1,1,1,1,2,2,1,0,0],
        [0,0,1,2,2,2,2,2,2,2,1,0,0,0],
        [0,0,0,1,1,1,1,1,1,1,0,0,0,0],
        [0,0,0,1,3,3,3,3,3,1,0,0,0,0],
        [0,0,0,1,3,1,1,1,3,1,0,0,0,0],
        [0,0,0,1,3,3,3,3,3,1,0,0,0,0],
        [0,0,0,1,3,1,1,3,3,1,0,0,0,0],
        [0,0,0,1,3,3,3,3,3,1,0,0,0,0],
        [0,0,0,0,1,1,1,1,1,0,0,0,0,0],
      ],
    );
  }

  // ── NAV: CHEST (peti harta karun) ─────────────────────────────────────
  static Widget chest({double pixelSize = 2.0, bool isActive = false}) {
    final c1 = isActive ? _activeNav : _dimNav;
    final c2 = isActive ? _activeNav.withValues(alpha: 0.7) : _dimNav.withValues(alpha: 0.7);
    final c3 = isActive ? _activeNav.withValues(alpha: 0.4) : _dimNav.withValues(alpha: 0.4);
    return PixelIcon(
      pixelSize: pixelSize,
      palette: {1: c1, 2: c2, 3: c3},
      pixels: const [
        [0,0,1,1,1,1,1,1,1,1,1,1,0,0],
        [0,1,2,2,2,2,2,2,2,2,2,2,1,0],
        [1,2,2,2,2,2,2,2,2,2,2,2,2,1],
        [1,2,2,2,2,2,2,2,2,2,2,2,2,1],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        [1,3,3,3,3,3,1,1,3,3,3,3,3,1],
        [1,3,3,3,3,3,1,1,3,3,3,3,3,1],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        [1,2,2,2,2,2,2,2,2,2,2,2,2,1],
        [1,2,2,2,2,2,2,2,2,2,2,2,2,1],
        [1,2,2,2,2,2,2,2,2,2,2,2,2,1],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,0],
      ],
    );
  }

  // ── NAV: PROFILE (avatar detail) ──────────────────────────────────────
  static Widget profile({double pixelSize = 2.0, bool isActive = false}) {
    final c1 = isActive ? _activeNav : _dimNav;
    final c2 = isActive ? _activeNav.withValues(alpha: 0.7) : _dimNav.withValues(alpha: 0.7);
    final c3 = isActive ? _activeNav.withValues(alpha: 0.4) : _dimNav.withValues(alpha: 0.4);
    return PixelIcon(
      pixelSize: pixelSize,
      palette: {1: c1, 2: c2, 3: c3},
      pixels: const [
        [0,0,0,0,0,1,1,1,1,0,0,0,0,0],
        [0,0,0,0,1,2,2,2,2,1,0,0,0,0],
        [0,0,0,1,2,2,2,2,2,2,1,0,0,0],
        [0,0,0,1,2,3,3,3,3,2,1,0,0,0],
        [0,0,0,1,2,3,1,1,3,2,1,0,0,0],
        [0,0,0,1,2,3,3,3,3,2,1,0,0,0],
        [0,0,0,0,1,2,2,2,2,1,0,0,0,0],
        [0,0,0,0,0,1,1,1,1,0,0,0,0,0],
        [0,0,0,1,1,2,2,2,2,1,1,0,0,0],
        [0,0,1,2,2,2,2,2,2,2,2,1,0,0],
        [0,1,2,2,2,1,1,1,1,2,2,2,1,0],
        [1,2,2,2,1,3,3,3,3,1,2,2,2,1],
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      ],
    );
  }
}
