import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../shared/pixel_icons.dart';

/// Retro-styled arcade map marker pin for field sightings in the Boscdex Diari.
///
/// Features authentic 16-bit pixel art specimen sprites (e.g. Rovelló, Cep, Pi roig),
/// confidence level indicators, and an animated pulsing aura when selected.
class JournalMapMarker extends StatelessWidget {
  final Avistament avistament;
  final String displayName;
  final bool isTree;
  final bool isSelected;
  final double pulseValue;
  final VoidCallback onTap;

  const JournalMapMarker({
    Key? key,
    required this.avistament,
    required this.displayName,
    required this.isTree,
    required this.isSelected,
    this.pulseValue = 0.0,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confidencePct = avistament.confidenceScore != null
        ? (avistament.confidenceScore! * 100).toInt()
        : null;

    final primaryColor =
        isTree ? RetroColors.forestGreen : RetroColors.arcadeRed;
    final borderColor = isSelected ? RetroColors.goldCoin : RetroColors.ink;

    final spriteAssetPath = isTree
        ? (avistament.arbreId != null
            ? 'assets/images/trees/${avistament.arbreId}.png'
            : null)
        : (avistament.boletId != null
            ? 'assets/images/mushrooms/${avistament.boletId}.png'
            : null);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Semantics(
        button: true,
        label:
            '${isTree ? "Arbre" : "Bolet"}: $displayName, ${confidencePct != null ? "$confidencePct%" : ""}',
        child: AnimatedScale(
          scale: isSelected ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 44,
            height: 52,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Pulsing Selection Halo
                if (isSelected)
                  Positioned(
                    top: 2,
                    child: Container(
                      width: 38 + (6 * pulseValue),
                      height: 38 + (6 * pulseValue),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RetroColors.goldCoin
                            .withOpacity(0.35 * (1.0 - pulseValue * 0.4)),
                        border: Border.all(
                          color: RetroColors.goldCoin
                              .withOpacity(0.6 * (1.0 - pulseValue * 0.5)),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                // Triangular Pointer at Bottom
                Positioned(
                  bottom: 2,
                  child: CustomPaint(
                    size: const Size(12, 10),
                    painter: _PinTrianglePainter(
                      color: primaryColor,
                      borderColor: borderColor,
                    ),
                  ),
                ),

                // Main Circular Coin Badge with Specific Specimen Sprite
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? RetroColors.goldCoin : primaryColor,
                      width: isSelected ? 2.5 : 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: RetroColors.ink.withOpacity(0.35),
                        offset: const Offset(0, 2.5),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: spriteAssetPath != null
                          ? Image.asset(
                              spriteAssetPath,
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.none,
                              errorBuilder: (context, error, stackTrace) =>
                                  isTree
                                      ? const PixelArbreIcon(size: 20)
                                      : const PixelBoletIcon(size: 20),
                            )
                          : (isTree
                              ? const PixelArbreIcon(size: 20)
                              : const PixelBoletIcon(size: 20)),
                    ),
                  ),
                ),

                // Tiny Confidence Pill at bottom right of badge
                if (confidencePct != null)
                  Positioned(
                    top: 24,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3.5,
                        vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: RetroColors.ink,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        '$confidencePct%',
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinTrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  const _PinTrianglePainter({
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _PinTrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}
