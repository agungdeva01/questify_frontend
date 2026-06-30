import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../pixel_container.dart';
import '../pixel_button.dart';
import '../pixel_sprites.dart';

class GreetingBannerWidget extends StatelessWidget {
  // 1. Tambahkan parameter ini untuk menerima aksi klik
  final VoidCallback? onPostNewQuestTap;

  // 2. Tambahkan ke dalam constructor
  const GreetingBannerWidget({super.key, this.onPostNewQuestTap});

  @override
  Widget build(BuildContext context) {
    return PixelContainer(
      backgroundColor: AppTheme.primaryWood,
      borderColor: Colors.black,
      borderThickness: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              "Ready for today's quests?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            PixelButton(
              color: AppTheme.primaryWoodLight,
              // 3. Masukkan fungsi kliknya di sini menggantikan yang kosong
              onPressed: onPostNewQuestTap ?? () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PixelSprites.plus(pixelSize: 4.0),
                    const SizedBox(width: 14),
                    Text(
                      'Post New Quest',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
