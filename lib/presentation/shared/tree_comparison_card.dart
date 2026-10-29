import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/services/reference_photo_service.dart';
import 'photo_zoom_dialog.dart';

/// Card providing a side-by-side or standalone botanical comparison between
/// the user's camera capture and verified botanical reference photos of the indicator tree.
class TreeComparisonCard extends StatelessWidget {
  final Uint8List? userImageBytes;
  final Arbre tree;
  final ReferencePhotoService referencePhotoService;

  const TreeComparisonCard({
    super.key,
    required this.userImageBytes,
    required this.tree,
    required this.referencePhotoService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.languageCode;
    final refAssetPath = referencePhotoService.getReferenceAssetPath(tree.id);
    final attribution = referencePhotoService.getAttribution(tree.id);

    final displayName = SpeciesLocalizer.getTreeName(
      tree.id,
      languageCode: lang,
      fallbackName: tree.catalanName,
    );

    return Container(
      decoration: RetroDecorations.card(
        backgroundColor: RetroColors.surface,
        borderColor: RetroColors.ink,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(
                Icons.compare_rounded,
                size: 18,
                color: RetroColors.forestGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.photoComparison,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: RetroColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Side-by-side or Single reference view
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User photo (if available)
              if (userImageBytes != null) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: RetroColors.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: RetroColors.ink, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera_alt_rounded,
                                size: 12, color: RetroColors.ink),
                            const SizedBox(width: 4),
                            Text(
                              l10n.yourCapture,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: RetroColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => PhotoZoomDialog.show(
                          context: context,
                          imageBytes: userImageBytes,
                          title: l10n.yourCapture,
                          subtitle: displayName,
                        ),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(
                                userImageBytes!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                right: 6,
                                bottom: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.zoom_in,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],

              // 2. Botanical Reference Photo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: RetroColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: RetroColors.ink, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo_library_rounded,
                              size: 12, color: RetroColors.forestGreen),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              l10n.botanicalReference,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: RetroColors.ink,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => PhotoZoomDialog.show(
                        context: context,
                        assetPath: refAssetPath,
                        title: displayName,
                        subtitle: tree.scientificName,
                        attribution: attribution != null
                            ? '${attribution.author} (${attribution.licenseName})'
                            : null,
                      ),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RetroColors.ink, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              refAssetPath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Container(
                                color: RetroColors.forestLight,
                                child: const Center(
                                  child: Icon(
                                    Icons.park_rounded,
                                    size: 40,
                                    color: RetroColors.forestGreen,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              bottom: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.zoom_in,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Attribution banner
          if (attribution != null) ...[
            const SizedBox(height: 8),
            Text(
              'Foto: ${attribution.author} (${attribution.licenseName})',
              style: const TextStyle(
                fontSize: 10,
                color: RetroColors.inkSoft,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
