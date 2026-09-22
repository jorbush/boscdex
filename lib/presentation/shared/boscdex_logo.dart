import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';

/// A reusable retro-styled Boscdex logo emblem.
class BoscdexLogo extends StatelessWidget {
  /// The diameter of the circular logo.
  final double size;

  /// Whether to render a comic-book dark border around the logo.
  final bool showBorder;

  /// Width of the border if enabled.
  final double borderWidth;

  /// Whether to render a hard retro 2D drop-shadow.
  final bool showShadow;

  /// Drop shadow offset distance.
  final double shadowOffset;

  /// Whether to display the mascot version (chanterelle) or the canonical emblem (cep + pine).
  final bool useMascot;

  const BoscdexLogo({
    super.key,
    this.size = 48.0,
    this.showBorder = true,
    this.borderWidth = 2.0,
    this.showShadow = false,
    this.shadowOffset = 3.0,
    this.useMascot = false,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = useMascot
        ? 'assets/icons/boscdex_mascot.png'
        : 'assets/icons/boscdex_logo.png';

    final Widget image = ClipOval(
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if asset is missing
          return Container(
            width: size,
            height: size,
            color: RetroColors.forestGreen,
            child: Center(
              child: Text(
                '🍄',
                style: TextStyle(fontSize: size * 0.5),
              ),
            ),
          );
        },
      ),
    );

    if (!showBorder && !showShadow) {
      return SizedBox(
        width: size,
        height: size,
        child: image,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: RetroColors.ink,
                width: borderWidth,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: RetroColors.ink,
                  offset: Offset(shadowOffset, shadowOffset),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: image,
    );
  }
}
