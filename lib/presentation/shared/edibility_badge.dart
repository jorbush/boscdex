import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/edibilitat.dart';

class EdibilityBadge extends StatelessWidget {
  final Edibilitat edibilitat;
  final bool iconOnly;

  const EdibilityBadge({
    super.key,
    required this.edibilitat,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (iconOnly) {
      return Semantics(
        label: edibilitat.label,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: edibilitat.color.withOpacity(0.25),
            shape: BoxShape.circle,
            border: Border.all(color: RetroColors.ink, width: 1.8),
            boxShadow: const [
              BoxShadow(
                color: RetroColors.ink,
                offset: Offset(1.5, 1.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Icon(edibilitat.icon, size: 12, color: edibilitat.color),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: edibilitat.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: RetroColors.ink, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: RetroColors.ink,
            offset: Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(edibilitat.icon, size: 13, color: edibilitat.color),
          const SizedBox(width: 4),
          Text(
            edibilitat.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: RetroColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
