import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/services/photo_export_service.dart';
import '../../domain/services/sound_effect_service.dart';
import '../../providers/sound_provider.dart';
import 'avistament_detail_sheet.dart';
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
  Avistament? _selectedAvistament;

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
    if (_selectedAvistament != null &&
        !widget.avistaments.any((a) => a.id == _selectedAvistament!.id)) {
      _selectedAvistament = null;
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

  void _selectAvistament(Avistament avistament) {
    HapticFeedback.selectionClick();
    try {
      ref.read(soundEffectServiceProvider).play(RetroSoundEffect.blip);
    } catch (_) {}

    setState(() {
      _selectedAvistament = avistament;
    });
  }

  void _clearSelection() {
    if (_selectedAvistament != null) {
      setState(() {
        _selectedAvistament = null;
      });
    }
  }

  String _resolveName(Avistament a) {
    final isTree = a.arbreId != null;
    if (isTree) {
      return widget.arbresMap[a.arbreId] ?? a.arbreId ?? 'Arbre indicador';
    }
    return widget.boletsMap[a.boletId] ?? a.boletId ?? 'Bolet';
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

                            return Stack(
                              children: [
                                for (final avistament in visibleSightings)
                                  _buildMarker(
                                    avistament: avistament,
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
                        label: 'Tots (${allGpsSightings.length})',
                        filterId: 'tots',
                        color: RetroColors.forestGreen,
                      ),
                      const SizedBox(width: 6),
                      _buildFilterChip(
                        key: const Key('map_filter_bolets'),
                        label: 'Bolets ($boletsCount)',
                        icon: const PixelBoletIcon(size: 16),
                        filterId: 'bolets',
                        color: RetroColors.arcadeRed,
                      ),
                      const SizedBox(width: 6),
                      _buildFilterChip(
                        key: const Key('map_filter_arbres'),
                        label: 'Arbres ($arbresCount)',
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
                  tooltip: 'Centrar mapa',
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
                    '$noGpsCount sense GPS',
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
                    const Text(
                      'SENSE COORDENADES GPS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.forestGreen,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.avistaments.isEmpty
                          ? 'Encara no tens cap avistament registrat al teu diari.'
                          : 'Tens ${widget.avistaments.length} avistaments, però cap amb dades GPS.\nEn registrar fotos al bosc amb GPS, els pins apareixeran aquí!',
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
        if (_selectedAvistament != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _buildInspectionHUD(_selectedAvistament!),
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
    required Avistament avistament,
    required double mapWidth,
    required double mapHeight,
    required double markerScale,
  }) {
    final norm = JournalMapProjection.toNormalized(
      avistament.latitude,
      avistament.longitude,
    );
    if (norm == null) return const SizedBox.shrink();

    final isSelected = _selectedAvistament?.id == avistament.id;
    final isTree = avistament.arbreId != null;
    final displayName = _resolveName(avistament);

    // Anchor pin bottom tip precisely at (norm.dx * mapWidth, norm.dy * mapHeight)
    // The pin dimensions are 44w x 52h with pointer tip at bottom center (x: 22, y: 50)
    return Positioned(
      left: norm.dx * mapWidth - 22,
      top: norm.dy * mapHeight - 50,
      child: Transform.scale(
        scale: markerScale,
        alignment: const Alignment(0.0, 0.92), // Pin tip anchor point
        child: JournalMapMarker(
          key: Key('map_marker_${avistament.id}'),
          avistament: avistament,
          displayName: displayName,
          isTree: isTree,
          isSelected: isSelected,
          pulseValue: _pulseAnimation.value,
          onTap: () => _selectAvistament(avistament),
        ),
      ),
    );
  }

  Widget _buildInspectionHUD(Avistament avistament) {
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
                            isTree ? 'ARBRE' : 'BOLET',
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
                          : 'Sense GPS',
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
              children: const [
                Icon(Icons.visibility_rounded, size: 16),
                SizedBox(width: 6),
                Text(
                  'Veure Detall',
                  style: TextStyle(
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

  Widget _buildDefaultThumbnail(Avistament avistament, bool isTree) {
    final spriteAssetPath = isTree
        ? (avistament.arbreId != null
            ? 'assets/images/trees/${avistament.arbreId}.png'
            : null)
        : (avistament.boletId != null
            ? 'assets/images/mushrooms/${avistament.boletId}.png'
            : null);

    if (spriteAssetPath != null) {
      return Image.asset(
        spriteAssetPath,
        width: 36,
        height: 36,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        errorBuilder: (ctx, err, st) => isTree
            ? const PixelArbreIcon(size: 26)
            : const PixelBoletIcon(size: 26),
      );
    }

    return isTree
        ? const PixelArbreIcon(size: 26)
        : const PixelBoletIcon(size: 26);
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
