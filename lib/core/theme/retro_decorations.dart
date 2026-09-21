import 'package:flutter/material.dart';

/// Design tokens and decoration utilities for the retro-cartoon-videogame aesthetic.
class RetroColors {
  RetroColors._();

  // Line art & comic border ink (Deep Forest Charcoal - soft and legible)
  static const Color ink = Color(0xFF1E2822);
  static const Color inkSoft = Color(0xFF4F6357);
  static const Color inkFaint = Color(0xFF8A9C91);

  // Canvas & backgrounds (Warm botanical parchment feel)
  static const Color background = Color(0xFFF5F3EB);
  static const Color creamBg = background;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFAF8F2);
  static const Color surfaceLight = Color(0xFFEEF5EA);
  static const Color screenOverlay = Color(0xFFE5EDE1);
  static const Color sectionBg = Color(0xFFE2EBE2);

  // Harmonious Botanical Palette
  static const Color forestGreen = Color(0xFF2D6E44);
  static const Color pineDark = Color(0xFF1B432A);
  static const Color forestLight = Color(0xFFE4EFE7);
  static const Color mintWash = forestLight;
  static const Color mintGlow = Color(0xFF4C9A66);
  static const Color mintMuted = Color(0xFFD4E0CE);

  // Warm Honey Gold (Coins, badges, discoveries)
  static const Color questAmber = Color(0xFFD99026);
  static const Color goldCoin = Color(0xFFE5A93C);
  static const Color goldLight = Color(0xFFFBF3E4);
  static const Color alertWarningLight = Color(0xFFFFF9E6);

  // Earthy Terracotta / Berry Crimson (Warnings, lookalikes, accents)
  static const Color arcadeRed = Color(0xFFCC4E46);
  static const Color redLight = Color(0xFFFAECEB);
  static const Color alertDangerLight = Color(0xFFFFECEC);

  // Nature Slate & Plum accents
  static const Color arcadeCyan = Color(0xFF386B85);
  static const Color arcadePurple = Color(0xFF7A4F88);

  // Progress Bar / UI state
  static const Color progressBarEmpty = Color(0xFFD5DFD1);
}

class RetroDecorations {
  RetroDecorations._();

  /// Standard 2.2px comic border for cards and panels
  static Border border({Color color = RetroColors.ink, double width = 2.2}) {
    return Border.all(color: color, width: width);
  }

  /// Solid unblurred 2D drop-shadow for retro-game tactile physicality
  static List<BoxShadow> hardShadow({
    Color color = RetroColors.ink,
    double dx = 3.0,
    double dy = 3.0,
  }) {
    return [
      BoxShadow(
        color: color,
        offset: Offset(dx, dy),
        blurRadius: 0,
      ),
    ];
  }

  /// Button bottom shadow bevel for 3D arcade pressable feel
  static List<BoxShadow> buttonShadow({
    Color color = RetroColors.ink,
    double height = 4.0,
  }) {
    return [
      BoxShadow(
        color: color,
        offset: Offset(0, height),
        blurRadius: 0,
      ),
    ];
  }

  /// Complete retro trading card decoration
  static BoxDecoration card({
    Color backgroundColor = RetroColors.surface,
    BorderRadius? borderRadius,
    Color borderColor = RetroColors.ink,
    double borderWidth = 2.2,
    double shadowOffset = 3.0,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(14),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? borderColor,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  /// Retro arcade action button decoration
  static BoxDecoration arcadeButton({
    required Color color,
    BorderRadius? borderRadius,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius ?? BorderRadius.circular(14),
      border: Border.all(color: RetroColors.ink, width: 2.2),
      boxShadow: isPressed
          ? const []
          : const [
              BoxShadow(
                color: RetroColors.ink,
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
    );
  }
}

/// 16-bit segmented XP / HP progress bar for retro game HUD
class RetroProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int totalSegments;
  final Color fillColor;
  final Color emptyColor;
  final double height;

  const RetroProgressBar({
    super.key,
    required this.progress,
    this.totalSegments = 12,
    this.fillColor = RetroColors.forestGreen,
    this.emptyColor = RetroColors.progressBarEmpty,
    this.height = 10,
  })  : assert(totalSegments > 0, 'totalSegments must be greater than 0'),
        assert(height > 0, 'height must be positive');

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.isFinite ? progress.clamp(0.0, 1.0) : 0.0;
    final activeSegments = (safeProgress * totalSegments).round();

    return Container(
      height: height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: RetroColors.ink,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: List.generate(totalSegments, (index) {
          final isFilled = index < activeSegments;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isFilled ? fillColor : emptyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
