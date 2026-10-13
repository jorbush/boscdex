import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../shared/offline_indicator.dart';

/// Modal bottom sheet presented when an image selected from the iOS gallery
/// cannot be loaded because it is stored in iCloud and not downloaded locally.
class ICloudPhotoUnavailableSheet extends StatelessWidget {
  const ICloudPhotoUnavailableSheet({Key? key}) : super(key: key);

  /// Shows the iCloud photo unavailable explanation modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ICloudPhotoUnavailableSheet(),
    );
  }

  /// Inspects whether an exception indicates an iOS iCloud / NSItemProvider synchronization error.
  static bool isICloudOrCloudSyncError(dynamic error) {
    if (error is PlatformException) {
      if (error.code == 'invalid_image') return true;
      final msg = error.message?.toLowerCase() ?? '';
      final details = error.details?.toString().toLowerCase() ?? '';
      if (details.contains('nsitemprovidererrordomain') ||
          details.contains('itemprovider') ||
          msg.contains('representation') ||
          msg.contains('public.jpeg') ||
          msg.contains('public.heic') ||
          msg.contains('icloud')) {
        return true;
      }
    }
    final str = error.toString().toLowerCase();
    return str.contains('nsitemprovidererrordomain') ||
        str.contains('cannot load representation') ||
        str.contains('public.jpeg') ||
        str.contains('icloud');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.78;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: sheetHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: RetroColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: RetroColors.ink, width: 2.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: RetroColors.ink,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header with iCloud icon and Title
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RetroColors.ink, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: RetroColors.ink,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.cloud_off_rounded,
                      color: RetroColors.arcadeRed,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.iCloudPhotoUnavailableTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const OfflineIndicator(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Scrollable explanation content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subtitle & explanation banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: RetroColors.ink, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: RetroColors.ink,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.iCloudPhotoUnavailableSubtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: RetroColors.ink,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.iCloudPhotoUnavailableOfflineNotice,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: RetroColors.inkSoft,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // How to fix guide container
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF5EF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: RetroColors.ink, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: RetroColors.ink,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.build_circle_rounded,
                                size: 16,
                                color: RetroColors.forestGreen,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.iCloudPhotoUnavailableHowToFix,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: RetroColors.forestGreen,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildStepRow(
                            stepNum: '1',
                            text: l10n.iCloudPhotoUnavailableStep1,
                          ),
                          const SizedBox(height: 8),
                          _buildStepRow(
                            stepNum: '2',
                            text: l10n.iCloudPhotoUnavailableStep2,
                          ),
                          const SizedBox(height: 8),
                          _buildStepRow(
                            stepNum: '3',
                            text: l10n.iCloudPhotoUnavailableStep3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pro-tip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: RetroColors.goldCoin, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_rounded,
                            size: 16,
                            color: Color(0xFFB47800),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.iCloudPhotoUnavailableTip,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: RetroColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dismiss Button
            Semantics(
              button: true,
              label: l10n.understood,
              child: GestureDetector(
                key: const Key('icloud_unavailable_dismiss_button'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: RetroColors.forestGreen,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RetroColors.ink, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: RetroColors.ink,
                        offset: Offset(2, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l10n.understood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String stepNum,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: RetroColors.forestGreen,
            shape: BoxShape.circle,
            border: Border.all(color: RetroColors.ink, width: 1.5),
          ),
          child: Center(
            child: Text(
              stepNum,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: RetroColors.ink,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
