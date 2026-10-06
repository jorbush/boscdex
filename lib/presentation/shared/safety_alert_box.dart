import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';

class SafetyAlertBox extends StatelessWidget {
  final String confusionSpecies;
  final VoidCallback onTap;

  const SafetyAlertBox({
    super.key,
    required this.confusionSpecies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label:
          '${l10n.dangerousLookalikeAlert}: ${l10n.canBeConfusedWith(confusionSpecies)}. ${l10n.tapToCompare}.',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: RetroColors.alertDangerLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RetroColors.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: RetroColors.arcadeRed,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RetroColors.arcadeRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: RetroColors.ink, width: 2),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dangerousLookalikeAlert,
                      style: const TextStyle(
                        color: RetroColors.arcadeRed,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.canBeConfusedWith(confusionSpecies),
                      style: const TextStyle(
                        color: RetroColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.tapToCompare,
                      style: const TextStyle(
                        color: RetroColors.inkSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: RetroColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}
