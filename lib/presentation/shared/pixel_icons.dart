import 'package:flutter/material.dart';

/// Reusable 16-bit retro pixel art icons for the Boscdex UI.
class PixelIcons {
  PixelIcons._();

  static const String boletPath = 'assets/icons/pixel_bolet.png';
  static const String arbrePath = 'assets/icons/pixel_arbre.png';
  static const String trophyPath = 'assets/icons/pixel_trophy.png';
}

/// 16-bit retro pixel art icon representing a wild mushroom (Rovelló / Pinetell).
class PixelBoletIcon extends StatelessWidget {
  final double size;

  const PixelBoletIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      PixelIcons.boletPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp pixel-art edges
      errorBuilder: (_, __, ___) => Text(
        '🍄',
        style: TextStyle(fontSize: size * 0.8),
      ),
    );
  }
}

/// 16-bit retro pixel art icon representing an indicator pine tree (Pi / Pinus sylvestris).
class PixelArbreIcon extends StatelessWidget {
  final double size;

  const PixelArbreIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      PixelIcons.arbrePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp pixel-art edges
      errorBuilder: (_, __, ___) => Text(
        '🌲',
        style: TextStyle(fontSize: size * 0.8),
      ),
    );
  }
}

/// 16-bit retro pixel art icon representing the golden trophy cup for badges.
class PixelTrophyIcon extends StatelessWidget {
  final double size;

  const PixelTrophyIcon({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      PixelIcons.trophyPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp pixel-art edges
      errorBuilder: (_, __, ___) => Icon(
        Icons.emoji_events,
        size: size,
      ),
    );
  }
}
