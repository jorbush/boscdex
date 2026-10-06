import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';

class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: l10n.offlineConnectionSemantics,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: RetroColors.screenOverlay,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RetroColors.ink, width: 2),
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
            const Icon(Icons.wifi_off,
                size: 13, color: RetroColors.forestGreen),
            const SizedBox(width: 4),
            Text(
              l10n.offline100,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: RetroColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
