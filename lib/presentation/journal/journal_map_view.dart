import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/services/photo_export_service.dart';
import '../../domain/services/sound_effect_service.dart';
import '../../providers/sound_provider.dart';
import 'avistament_detail_sheet.dart';
import 'journal_map_cluster.dart';
import 'journal_map_marker.dart';
import 'journal_map_projection.dart';
import '../shared/pixel_icons.dart';

/// Interactive offline field map for the Boscdex Diari.
///
/// Visualizes the user's field sightings with GPS coordinates across Catalonia
/// using the authentic 4:3 16-bit retro map with pinch-to-zoom (1.0x to 4.5x),
/// marker selection, filtering, and a preview inspection HUD.
class JournalMapView extends ConsumerStatefulWidget {
  final List<Avistament> avistaments;
  final Map<String, String> boletsMap;
  final Map<String, String> arbresMap;
  final bool? animate;

  const JournalMapView({
    Key? key,
    required this.avistaments,
    required this.boletsMap,
    required this.arbresMap,
    this.animate,
  }) : super(key: key);

  @override
  ConsumerState<JournalMapView> createState() => _JournalMapViewState();
}

class _JournalMapViewState extends ConsumerState<JournalMapView>
    with TickerProviderStateMixin {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  late final TransformationController _transformationController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  late final AnimationController _resetAnimationController;
  Animation<Matrix4>? _resetAnimation;

  String _filter = 'tots'; // 'tots', 'bolets', 'arbres'
  SightingCluster? _selectedCluster;
  int _selectedClusterIndex = 0;

  Avistament? get _selectedAvistament {
    if (_selectedCluster == null || _selectedCluster!.sightings.isEmpty) {
      return null;
    }
    final index =
        _selectedClusterIndex.clamp(0, _selectedCluster!.sightings.length - 1);
    return _selectedCluster!.sightings[index];
  }

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);

    final shouldAnimate = widget.animate ??
        !WidgetsBinding.instance.runtimeType.toString().contains('Test');

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (shouldAnimate) {
      _pulseController.repeat(reverse: true);
    }
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    _resetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onTransformationChanged() {
    // Rebuild so markers can counter-scale to maintain crisp readable size
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant JournalMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedCluster != null) {
      final stillExists = widget.avistaments
          .any((a) => _selectedCluster!.sightings.any((s) => s.id == a.id));
      if (!stillExists) {
        _selectedCluster = null;
        _selectedClusterIndex = 0;
      }
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _pulseController.dispose();
    _resetAnimationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    HapticFeedback.selectionClick();
    _resetAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _resetAnimationController,
      curve: Curves.easeOutCubic,
    ));

    void listener() {
      if (_resetAnimation != null) {
        _transformationController.value = _resetAnimation!.value;
      }
    }

    _resetAnimationController.addListener(listener);
    _resetAnimationController.forward(from: 0.0).then((_) {
      _resetAnimationController.removeListener(listener);
    });
  }

  void _selectCluster(SightingCluster cluster) {
    HapticFeedback.selectionClick();
    try {
      ref.read(soundEffectServiceProvider).play(RetroSoundEffect.blip);
    } catch (_) {}

    setState(() {
      if (_selectedCluster?.id == cluster.id) {
        // Tapping an already selected cluster cycles to the next item
        _selectedClusterIndex =
            (_selectedClusterIndex + 1) % cluster.sightings.length;
      } else {
        _selectedCluster = cluster;
        _selectedClusterIndex = 0;
      }
    });
  }

  void _cycleCluster(int offset) {
    if (_selectedCluster == null || _selectedCluster!.sightings.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      final count = _selectedCluster!.sightings.length;
      _selectedClusterIndex = (_selectedClusterIndex + offset) % count;
      if (_selectedClusterIndex < 0) {
        _selectedClusterIndex += count;
      }
    });
  }

  void _selectClusterIndex(int index) {
    if (_selectedCluster == null ||
        index < 0 ||
        index >= _selectedCluster!.sightings.length) return;
    if (_selectedClusterIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedClusterIndex = index;
    });
  }

  void _clearSelection() {
    if (_selectedCluster != null) {
      setState(() {
        _selectedCluster = null;
        _selectedClusterIndex = 0;
      });
    }
  }

  String _resolveName(Avistament a) {
    final langCode = AppLocalizations.of(context).languageCode;
    final isTree = a.arbreId != null;
    if (isTree) {
      final fallback =
          widget.arbresMap[a.arbreId] ?? a.arbreId ?? 'Arbre indicador';
      return SpeciesLocalizer.getTreeName(
        a.arbreId,
        languageCode: langCode,
        fallbackName: fallback,
      );
    }
    final fallback = widget.boletsMap[a.boletId] ?? a.boletId ?? 'Bolet';
    return SpeciesLocalizer.getMushroomName(
      a.boletId,
      languageCode: langCode,
      fallbackName: fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Collect sightings with valid GPS coordinates
    final allGpsSightings = widget.avistaments
        .where((a) => a.latitude != null && a.longitude != null)
        .toList();

    // Filtered GPS sightings
    final visibleSightings = allGpsSightings.where((a) {
      if (_filter == 'bolets') return a.arbreId == null;
      if (_filter == 'arbres') return a.arbreId != null;
      return true;
    }).toList();

    final boletsCount = allGpsSightings.where((a) => a.arbreId == null).length;
    final arbresCount = allGpsSightings.where((a) => a.arbreId != null).length;
    final noGpsCount = widget.avistaments.length - allGpsSightings.length;

    // Calculate current zoom scale for counter-scaling markers
    final currentScale =
        _transformationController.value.getMaxScaleOnAxis().clamp(1.0, 4.5);
    final markerScale = 1.0 / currentScale;

    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        // Map Canvas inside InteractiveViewer
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _clearSelection,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 4.5,
              boundaryMargin: const EdgeInsets.all(120),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3B6F), // Mediterranean deep blue
                      border: Border.all(color: RetroColors.ink, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Catalonia Pixel Art Map Background
                        Image.asset(
                          'assets/images/map/catalonia_pixel_map.jpg',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackPixelCanvas(),
                        ),

                        // Markers Layer
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final mapWidth = constraints.maxWidth;
                            final mapHeight = constraints.maxHeight;

                            final clusters =
                                JournalMapClustering.cluster(visibleSightings);

                            return Stack(
                              children: [
                                for (final cluster in clusters)
                                  _buildMarker(
                                    cluster: cluster,
                                    mapWidth: mapWidth,
                                    mapHeight: mapHeight,
                                    markerScale: markerScale,
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Floating Top Bar: Category Filters & Reset Zoom Button
        Positioned(
          top: 10,
          left: 12,
          right: 12,
          child: Row(
            children: [
              // Filter chips container
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFilterChip(
                        key: const Key('map_filter_tots'),
                        label: '${l10n.filterAll} (${allGpsSightings.length})',
                        filterId: 'tots',
                        color: RetroColors.forestGreen,
                      ),
                      const SizedBox(width: 6),
                      _buildFilterChip(
                        key: const Key('map_filter_bolets'),
                        label: '${l10n.filterBolets} ($boletsCount)',
                        icon: const PixelBoletIcon(size: 16),
                        filterId: 'bolets',
                        color: RetroColors.arcadeRed,
                      ),
                      const SizedBox(width: 6),
                      _buildFilterChip(
                        key: const Key('map_filter_arbres'),
                        label: '${l10n.filterArbres} ($arbresCount)',
                        icon: const PixelArbreIcon(size: 16),
                        filterId: 'arbres',
                        color: RetroColors.forestGreen,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Reset Zoom Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: RetroColors.ink, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: RetroColors.ink,
                      offset: Offset(1.5, 1.5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: IconButton(
                  key: const Key('map_reset_zoom_button'),
                  icon: const Icon(
                    Icons.center_focus_strong_rounded,
                    size: 20,
                    color: RetroColors.ink,
                  ),
                  tooltip: l10n.mapResetZoom,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  onPressed: _resetZoom,
                ),
              ),
            ],
          ),
        ),

        // Bottom-Left Non-GPS Sightings Info Pill (if any)
        if (noGpsCount > 0 && _selectedAvistament == null)
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RetroColors.ink, width: 1.5),
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
                  const Icon(
                    Icons.location_off_rounded,
                    size: 14,
                    color: RetroColors.inkSoft,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$noGpsCount ${l10n.journalNoGpsBadge}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Empty GPS Sightings State Overlay
        if (allGpsSightings.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: RetroDecorations.card(
                  backgroundColor: Colors.white,
                  borderColor: RetroColors.ink,
                  borderWidth: 2.5,
                  shadowOffset: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🗺️', style: TextStyle(fontSize: 44)),
                    const SizedBox(height: 12),
                    Text(
                      l10n.mapNoGpsTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.forestGreen,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.avistaments.isEmpty
                          ? l10n.mapEmptyPrompt
                          : l10n.mapNoGpsMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.ink,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Sighting Inspection HUD Card (Floating Preview)
        if (_selectedCluster != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _buildInspectionHUD(_selectedCluster!, l10n),
          ),
      ],
    );
  }

  Widget _buildFilterChip({
    required Key key,
    required String label,
    required String filterId,
    required Color color,
    Widget? icon,
  }) {
    final isSelected = _filter == filterId;

    return GestureDetector(
      key: key,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _filter = filterId;
          _selectedCluster = null;
          _selectedClusterIndex = 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: RetroColors.ink,
            width: isSelected ? 2.0 : 1.5,
          ),
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
            if (icon != null) ...[
              icon,
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : RetroColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarker({
    required SightingCluster cluster,
    required double mapWidth,
    required double mapHeight,
    required double markerScale,
  }) {
    final norm = cluster.normalizedPosition;
    final isSelected = _selectedCluster?.id == cluster.id;
    final activeIndex = isSelected ? _selectedClusterIndex : 0;
    final activeSighting = cluster.sightings[activeIndex];
    final isTree = activeSighting.arbreId != null;
    final displayName = _resolveName(activeSighting);

    // Anchor pin bottom tip precisely at (norm.dx * mapWidth, norm.dy * mapHeight)
    // The pin dimensions are 44w x 52h with pointer tip at bottom center (x: 22, y: 50)
    return Positioned(
      left: norm.dx * mapWidth - 22,
      top: norm.dy * mapHeight - 50,
      child: Transform.scale(
        scale: markerScale,
        alignment: const Alignment(0.0, 0.92), // Pin tip anchor point
        child: JournalMapMarker(
          key: Key('map_marker_${activeSighting.id}'),
          avistament: activeSighting,
          displayName: displayName,
          isTree: isTree,
          isSelected: isSelected,
          itemCount: cluster.count,
          pulseValue: _pulseAnimation.value,
          onTap: () => _selectCluster(cluster),
        ),
      ),
    );
  }

  Widget _buildInspectionHUD(SightingCluster cluster, AppLocalizations l10n) {
    final activeIndex =
        _selectedClusterIndex.clamp(0, cluster.sightings.length - 1);
    final avistament = cluster.sightings[activeIndex];
    final isTree = avistament.arbreId != null;
    final displayName = _resolveName(avistament);
    final hasPhoto =
        avistament.photoPath != null && avistament.photoPath!.isNotEmpty;
    final confidencePct = avistament.confidenceScore != null
        ? (avistament.confidenceScore! * 100).toInt()
        : null;
    final isHighConfidence = (avistament.confidenceScore ?? 0.0) >= 0.70;

    return Container(
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2.5,
        shadowOffset: 4,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cluster navigation bar and mini specimen chip strip
          if (cluster.isCluster) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: RetroColors.mintWash,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: RetroColors.ink, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    key: const Key('hud_prev_sighting_button'),
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                    color: RetroColors.ink,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: () => _cycleCluster(-1),
                    tooltip: 'Troballa anterior',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.layers_rounded,
                        size: 13,
                        color: RetroColors.forestGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.findingItemOfTotal(activeIndex + 1, cluster.count),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    key: const Key('hud_next_sighting_button'),
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    color: RetroColors.ink,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: () => _cycleCluster(1),
                    tooltip: 'Següent troballa',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cluster.sightings.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, i) {
                  final item = cluster.sightings[i];
                  final isItemTree = item.arbreId != null;
                  final isCurrent = i == activeIndex;
                  return GestureDetector(
                    key: Key('hud_cluster_specimen_chip_$i'),
                    onTap: () => _selectClusterIndex(i),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? RetroColors.goldCoin.withOpacity(0.3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCurrent
                              ? RetroColors.forestGreen
                              : RetroColors.ink,
                          width: isCurrent ? 2.0 : 1.2,
                        ),
                        boxShadow: isCurrent
                            ? const [
                                BoxShadow(
                                  color: RetroColors.ink,
                                  offset: Offset(1, 1),
                                  blurRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _buildMiniThumbnail(item, isItemTree),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Top Row: Category tag, Species Name, Close Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasPhoto ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: RetroColors.ink, width: 1.8),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasPhoto
                    ? Image.file(
                        PhotoExportService.resolveFile(avistament.photoPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Center(
                          child: _buildDefaultThumbnail(avistament, isTree),
                        ),
                      )
                    : Center(
                        child: _buildDefaultThumbnail(avistament, isTree),
                      ),
              ),
              const SizedBox(width: 10),

              // Title, Category & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: (isTree
                                    ? RetroColors.forestGreen
                                    : RetroColors.arcadeRed)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isTree
                                  ? RetroColors.forestGreen
                                  : RetroColors.arcadeRed,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            isTree ? l10n.categoryArbre : l10n.categoryBolet,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: isTree
                                  ? RetroColors.forestGreen
                                  : RetroColors.arcadeRed,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (confidencePct != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: isHighConfidence
                                  ? RetroColors.forestGreen.withOpacity(0.12)
                                  : RetroColors.goldCoin.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isHighConfidence
                                    ? RetroColors.forestGreen
                                    : RetroColors.ink,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              '$confidencePct%',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: isHighConfidence
                                    ? RetroColors.forestGreen
                                    : RetroColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _dateFormat.format(avistament.timestamp),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),

              // Dismiss X button
              IconButton(
                key: const Key('hud_dismiss_button'),
                icon: const Icon(Icons.close_rounded, size: 20),
                color: RetroColors.inkSoft,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _clearSelection,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Coords & Altitude info row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: RetroColors.creamBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: RetroColors.ink, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 13,
                      color: RetroColors.forestGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      avistament.latitude != null &&
                              avistament.longitude != null
                          ? JournalMapProjection.format(
                              avistament.latitude!,
                              avistament.longitude!,
                            )
                          : l10n.journalNoGpsBadge,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                if (avistament.altitude != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.terrain_rounded,
                        size: 13,
                        color: RetroColors.questAmber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${avistament.altitude!.round()} m',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: RetroColors.ink,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // "Veure Detall" button
          ElevatedButton(
            key: const Key('hud_view_detail_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: RetroColors.forestGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: RetroColors.ink, width: 1.8),
              ),
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              AvistamentDetailSheet.show(context, avistament);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.visibility_rounded, size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n.viewDetail,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniThumbnail(Avistament avistament, bool isTree) {
    if (avistament.photoPath != null && avistament.photoPath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          PhotoExportService.resolveFile(avistament.photoPath!),
          width: 26,
          height: 26,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _buildDefaultThumbnail(avistament, isTree, size: 24),
        ),
      );
    }
    return _buildDefaultThumbnail(avistament, isTree, size: 24);
  }

  Widget _buildDefaultThumbnail(
    Avistament avistament,
    bool isTree, {
    double size = 36,
  }) {
    final spriteAssetPath = isTree
        ? (avistament.arbreId != null
            ? 'assets/images/trees/${avistament.arbreId}.png'
            : null)
        : (avistament.boletId != null
            ? 'assets/images/mushrooms/${avistament.boletId}.png'
            : null);

    final iconSize = size * 0.72;

    if (spriteAssetPath != null) {
      return Image.asset(
        spriteAssetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        errorBuilder: (ctx, err, st) => isTree
            ? PixelArbreIcon(size: iconSize)
            : PixelBoletIcon(size: iconSize),
      );
    }

    return isTree
        ? PixelArbreIcon(size: iconSize)
        : PixelBoletIcon(size: iconSize);
  }

  Widget _buildFallbackPixelCanvas() {
    return Container(
      color: const Color(0xFF1B3B6F),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.map_rounded, size: 36, color: Colors.white54),
            SizedBox(height: 6),
            Text(
              'Mapa de Catalunya',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
