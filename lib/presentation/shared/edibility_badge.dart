import 'package:flutter/material.dart';
import '../../domain/models/edibilitat.dart';

class EdibilityBadge extends StatelessWidget {
  final Edibilitat edibilitat;
  final bool iconOnly;

  const EdibilityBadge({
    Key? key,
    required this.edibilitat,
    this.iconOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconOnly) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: edibilitat.color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: edibilitat.color, width: 1.2),
        ),
        child: Icon(edibilitat.icon, size: 12, color: edibilitat.color),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: edibilitat.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: edibilitat.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(edibilitat.icon, size: 12, color: edibilitat.color),
          const SizedBox(width: 4),
          Text(
            edibilitat.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: edibilitat.color,
            ),
          ),
        ],
      ),
    );
  }
}
