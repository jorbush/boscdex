import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/services/reference_photo_service.dart';
import 'edibility_badge.dart';
import 'photo_zoom_dialog.dart';

/// Card providing a side-by-side visual comparison between the user's camera capture
/// and verified botanical reference photos of the identified species and its dangerous lookalikes.
class MushroomComparisonCard extends StatefulWidget {
  final Uint8List? userImageBytes;
  final Bolet topCandidate;
  final List<Bolet> lookalikes;
  final ReferencePhotoService referencePhotoService;

  const MushroomComparisonCard({
    super.key,
    required this.userImageBytes,
    required this.topCandidate,
    this.lookalikes = const [],
    required this.referencePhotoService,
  });

  @override
  State<MushroomComparisonCard> createState() => _MushroomComparisonCardState();
}

class _MushroomComparisonCardState extends State<MushroomComparisonCard> {
  late Bolet _selectedBolet;

  @override
  void initState() {
    super.initState();
    _selectedBolet = widget.topCandidate;
  }

  @override
  void didUpdateWidget(covariant MushroomComparisonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topCandidate.id != widget.topCandidate.id) {
      _selectedBolet = widget.topCandidate;
    }
  }

  bool get _isComparingLookalike => _selectedBolet.id != widget.topCandidate.id;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context).languageCode;
    final selectedEdibility =
        EdibilitatExtension.fromString(_selectedBolet.edibility);
    final refAssetPath =
        widget.referencePhotoService.getReferenceAssetPath(_selectedBolet.id);
    final attribution =
        widget.referencePhotoService.getAttribution(_selectedBolet.id);

    final selectedDisplayName = SpeciesLocalizer.getMushroomName(
      _selectedBolet.id,
      languageCode: lang,
      fallbackName: _selectedBolet.catalanName,
    );

    return Container(
      decoration: RetroDecorations.card(
        backgroundColor: _isComparingLookalike
            ? RetroColors.alertDangerLight
            : RetroColors.surface,
        borderColor:
            _isComparingLookalike ? RetroColors.arcadeRed : RetroColors.ink,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Icon(
                _isComparingLookalike
                    ? Icons.warning_amber_rounded
                    : Icons.compare_rounded,
                size: 18,
                color: _isComparingLookalike
                    ? RetroColors.arcadeRed
                    : RetroColors.forestGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isComparingLookalike
                      ? 'Comparant amb doble tòxic'
                      : 'Comparativa fotogràfica',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _isComparingLookalike
                        ? RetroColors.arcadeRed
                        : RetroColors.ink,
                  ),
                ),
              ),
              if (_isComparingLookalike)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: RetroColors.arcadeRed,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PERILL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          // Lookalike switcher chips (if toxic lookalikes exist)
          if (widget.lookalikes.isNotEmpty) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Top candidate button
                  _buildSpeciesChip(
                    bolet: widget.topCandidate,
                    isSelected: !_isComparingLookalike,
                    isLookalike: false,
                    lang: lang,
                  ),
                  const SizedBox(width: 6),
                  // Lookalike buttons
                  ...widget.lookalikes.map(
                    (lk) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _buildSpeciesChip(
                        bolet: lk,
                        isSelected: _selectedBolet.id == lk.id,
                        isLookalike: true,
                        lang: lang,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Side-by-side or Single reference view
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User photo (if available)
              if (widget.userImageBytes != null) ...[
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
                          children: const [
                            Icon(Icons.camera_alt_rounded,
                                size: 12, color: RetroColors.ink),
                            SizedBox(width: 4),
                            Text(
                              'La teva captura',
                              style: TextStyle(
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
                          imageBytes: widget.userImageBytes,
                          title: 'La teva captura',
                          subtitle: 'Foto presa des del dispositiu',
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
                                widget.userImageBytes!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => const Center(
                                  child: Icon(Icons.broken_image_rounded,
                                      color: RetroColors.inkSoft),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.zoom_in_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
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
                        color: _isComparingLookalike
                            ? RetroColors.alertDangerLight
                            : RetroColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _isComparingLookalike
                              ? RetroColors.arcadeRed
                              : RetroColors.ink,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isComparingLookalike
                                ? Icons.warning_rounded
                                : Icons.verified_rounded,
                            size: 12,
                            color: _isComparingLookalike
                                ? RetroColors.arcadeRed
                                : RetroColors.forestGreen,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _isComparingLookalike
                                  ? 'Doble tòxic'
                                  : 'Referència botànica',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _isComparingLookalike
                                    ? RetroColors.arcadeRed
                                    : RetroColors.ink,
                              ),
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
                        title: selectedDisplayName,
                        subtitle: _selectedBolet.scientificName,
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
                          border: Border.all(
                            color: _isComparingLookalike
                                ? RetroColors.arcadeRed
                                : RetroColors.ink,
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              refAssetPath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Center(
                                child: Image.asset(
                                  _selectedBolet.imageAssetPath ??
                                      'assets/images/mushrooms/${_selectedBolet.id}.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, st) =>
                                      const Icon(Icons.forest_rounded),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: EdibilityBadge(
                                edibilitat: selectedEdibility,
                                iconOnly: true,
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.zoom_in_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
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

          // Attribution and educational footer
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  attribution != null
                      ? '📷 ${attribution.author} • ${attribution.licenseName}'
                      : '📷 Fotografia botànica de referència',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: RetroColors.inkFaint,
                  ),
                ),
              ),
              const Text(
                'Toca per ampliar 🔍',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: RetroColors.inkSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesChip({
    required Bolet bolet,
    required bool isSelected,
    required bool isLookalike,
    required String lang,
  }) {
    final name = SpeciesLocalizer.getMushroomName(
      bolet.id,
      languageCode: lang,
      fallbackName: bolet.catalanName,
    );

    return InkWell(
      onTap: () => setState(() => _selectedBolet = bolet),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLookalike ? RetroColors.arcadeRed : RetroColors.forestGreen)
              : RetroColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (isLookalike
                    ? RetroColors.arcadeRed
                    : RetroColors.forestGreen)
                : RetroColors.ink,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLookalike) ...[
              Icon(
                Icons.warning_rounded,
                size: 12,
                color: isSelected ? Colors.white : RetroColors.arcadeRed,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : RetroColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
