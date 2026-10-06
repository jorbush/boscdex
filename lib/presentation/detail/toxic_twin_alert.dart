import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';

class ToxicTwinAlert extends StatelessWidget {
  const ToxicTwinAlert({
    super.key,
    required this.lookalikeName,
    required this.comparisonNotes,
    this.onTap,
  });

  final String lookalikeName;
  final String comparisonNotes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = Container(
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
            children: [
              const Icon(
                Icons.warning_rounded,
                color: RetroColors.arcadeRed,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.attentionLookalikePrefix,
                  style: const TextStyle(
                    color: RetroColors.arcadeRed,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: RetroColors.arcadeRed,
                  size: 14,
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
          if (onTap != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: RetroColors.arcadeRed, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.viewFullBoletCard,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.arcadeRed,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: RetroColors.arcadeRed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    return Semantics(
      liveRegion: true,
      button: onTap != null,
      label:
          '${l10n.dangerousLookalikeAlert}: ${l10n.attentionLookalikePrefix} $lookalikeName. $comparisonNotes',
      child: onTap != null
          ? GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: card,
            )
          : card,
    );
  }
}
