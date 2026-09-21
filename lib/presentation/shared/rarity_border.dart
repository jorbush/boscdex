import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/raritat_tier.dart';

class RarityBorder extends StatelessWidget {
  final RaritatTier tier;
  final Widget child;
  final double borderWidth;
  final BorderRadius? borderRadius;

  static const List<Color> _rainbowColors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.red,
  ];

  const RarityBorder({
    super.key,
    required this.tier,
    required this.child,
    this.borderWidth = 3.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(14);
    final decoration = tier == RaritatTier.llegendari
        ? BoxDecoration(
            borderRadius: br,
            border: Border.all(color: RetroColors.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: RetroColors.ink,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
            gradient: const SweepGradient(colors: _rainbowColors),
          )
        : BoxDecoration(
            borderRadius: br,
            border: Border.all(color: RetroColors.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: RetroColors.ink,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
            color: tier.color,
          );

    final innerTopLeft =
        (br.topLeft.x - borderWidth).clamp(0.0, double.infinity);
    final innerTopRight =
        (br.topRight.x - borderWidth).clamp(0.0, double.infinity);
    final innerBottomLeft =
        (br.bottomLeft.x - borderWidth).clamp(0.0, double.infinity);
    final innerBottomRight =
        (br.bottomRight.x - borderWidth).clamp(0.0, double.infinity);

    final innerRadius = BorderRadius.only(
      topLeft: Radius.circular(innerTopLeft),
      topRight: Radius.circular(innerTopRight),
      bottomLeft: Radius.circular(innerBottomLeft),
      bottomRight: Radius.circular(innerBottomRight),
    );

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: decoration,
      child: ClipRRect(
        borderRadius: innerRadius,
        child: child,
      ),
    );
  }
}
