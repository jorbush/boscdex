import 'package:flutter/material.dart';
import '../../domain/models/raritat_tier.dart';

class RarityBorder extends StatelessWidget {
  final RaritatTier tier;
  final Widget child;
  final double borderWidth;
  final BorderRadius? borderRadius;

  const RarityBorder({
    Key? key,
    required this.tier,
    required this.child,
    this.borderWidth = 2.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decoration = tier == RaritatTier.llegendari
        ? BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            gradient: const SweepGradient(
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.cyan,
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
            ),
          )
        : BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            color: tier.color,
          );

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: decoration,
      child: ClipRRect(
        borderRadius: borderRadius != null
            ? borderRadius!.subtract(BorderRadius.circular(borderWidth))
            : BorderRadius.circular(8 - borderWidth),
        child: child,
      ),
    );
  }
}
