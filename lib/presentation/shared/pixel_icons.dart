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
  static const String dexPath = 'assets/icons/pixel_dex.png';
  static const String cameraPath = 'assets/icons/pixel_camera.png';
  static const String journalPath = 'assets/icons/pixel_journal.png';
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

/// Internal widget for bottom navigation pixel art icons with active/inactive states.
class _RetroPixelNavIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final bool isActive;
  final String fallbackEmoji;

  const _RetroPixelNavIcon({
    Key? key,
    required this.assetPath,
    required this.size,
    required this.isActive,
    required this.fallbackEmoji,
  }) : super(key: key);

  static const ColorFilter _grayscaleMuted = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    0.45,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none, // Preserve crisp 16-bit pixel edges
      errorBuilder: (_, __, ___) => Text(
        fallbackEmoji,
        style: TextStyle(
          fontSize: size * 0.8,
          color: isActive ? null : Colors.grey,
        ),
      ),
    );

    if (isActive) {
      return image;
    }

    return ColorFiltered(
      colorFilter: _grayscaleMuted,
      child: image,
    );
  }
}

/// 16-bit retro pixel art icon representing the Pokédex electronic encyclopedia device.
class PixelDexIcon extends StatelessWidget {
  final double size;
  final bool isActive;

  const PixelDexIcon({
    Key? key,
    this.size = 24,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RetroPixelNavIcon(
      assetPath: PixelIcons.dexPath,
      size: size,
      isActive: isActive,
      fallbackEmoji: '📱',
    );
  }
}

/// 16-bit retro pixel art icon representing the retro handheld camera.
class PixelCameraIcon extends StatelessWidget {
  final double size;
  final bool isActive;

  const PixelCameraIcon({
    Key? key,
    this.size = 24,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RetroPixelNavIcon(
      assetPath: PixelIcons.cameraPath,
      size: size,
      isActive: isActive,
      fallbackEmoji: '📷',
    );
  }
}

/// 16-bit retro pixel art icon representing the field journal notebook.
class PixelJournalIcon extends StatelessWidget {
  final double size;
  final bool isActive;

  const PixelJournalIcon({
    Key? key,
    this.size = 24,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RetroPixelNavIcon(
      assetPath: PixelIcons.journalPath,
      size: size,
      isActive: isActive,
      fallbackEmoji: '📖',
    );
  }
}
