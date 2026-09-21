import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';

class ToxicTwinAlert extends StatelessWidget {
  const ToxicTwinAlert({
    super.key,
    required this.lookalikeName,
    required this.comparisonNotes,
  });

  final String lookalikeName;
  final String comparisonNotes;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label:
          'Alerta de confusió perillosa: Es pot confondre amb $lookalikeName. $comparisonNotes',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: RetroDecorations.card(
          backgroundColor: RetroColors.alertDangerLight,
          borderColor: RetroColors.arcadeRed,
          borderWidth: 2.5,
          shadowOffset: 3,
          shadowColor: RetroColors.arcadeRed,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.warning_rounded,
                  color: RetroColors.arcadeRed,
                  size: 22,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ATENCIÓ: Es pot confondre amb',
                    style: TextStyle(
                      color: RetroColors.arcadeRed,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lookalikeName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: RetroColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              comparisonNotes,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: RetroColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
