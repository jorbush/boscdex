import 'package:flutter/material.dart';

/// Reusable 16-bit retro pixel art icons for the Boscdex UI.
class PixelIcons {
  PixelIcons._();

  static const String boletPath = 'assets/icons/pixel_bolet.png';
  static const String arbrePath = 'assets/icons/pixel_arbre.png';
  static const String trophyPath = 'assets/icons/pixel_trophy.png';
  static const String pinActivePath = 'assets/icons/pixel_pin_active.png';
  static const String pinInactivePath = 'assets/icons/pixel_pin_inactive.png';
  static const String compassPath = 'assets/icons/pixel_compass.png';
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

/// 16-bit retro pixel art map marker pin for regional distribution zones.
///
/// Shows a glowing red/ruby location pin when [isActive] is true (presence),
/// or a muted slate-grey pin when [isActive] is false (absence).
class PixelZonePinIcon extends StatelessWidget {
  final bool isActive;
  final double size;

  const PixelZonePinIcon({
    super.key,
    required this.isActive,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isActive ? PixelIcons.pinActivePath : PixelIcons.pinInactivePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp 16-bit pixel edges
      errorBuilder: (_, __, ___) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE63946) : const Color(0xFFA8B2A1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 16-bit retro pixel art adventurer compass for map headers.
class PixelCompassIcon extends StatelessWidget {
  final double size;

  const PixelCompassIcon({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      PixelIcons.compassPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp 16-bit pixel edges
      errorBuilder: (_, __, ___) => Icon(
        Icons.explore,
        size: size,
        color: const Color(0xFF1E2822),
      ),
    );
  }
}
