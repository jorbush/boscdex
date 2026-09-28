import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/catalonia_zone.dart';
import '../shared/pixel_icons.dart';

/// A 16-bit retro pixel-art geographic map of Catalonia inspired by the
/// classic Pokémon Pokédex "Area" screen.
///
/// Highlights the natural foraging zones and geographic regions where a
/// given mushroom species can be found with pulsating radar tiles.
class CataloniaPixelMap extends StatefulWidget {
  final List<CataloniaZone> activeZones;
  final String? speciesName;
  final bool? animate;

  const CataloniaPixelMap({
    super.key,
    required this.activeZones,
    this.speciesName,
    this.animate,
  });

  @override
  State<CataloniaPixelMap> createState() => _CataloniaPixelMapState();
}

class _CataloniaPixelMapState extends State<CataloniaPixelMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  CataloniaZone? _selectedZone;

  @override
  void initState() {
    super.initState();
    final shouldAnimate = widget.animate ??
        !WidgetsBinding.instance.runtimeType.toString().contains('Test');

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    if (shouldAnimate) {
      _pulseController.repeat(reverse: true);
    }

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    if (widget.activeZones.isNotEmpty) {
      _selectedZone = widget.activeZones.first;
    }
  }

  @override
  void didUpdateWidget(covariant CataloniaPixelMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeZones != oldWidget.activeZones &&
        widget.activeZones.isNotEmpty) {
      if (_selectedZone == null ||
          !widget.activeZones.contains(_selectedZone)) {
        _selectedZone = widget.activeZones.first;
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = widget.activeZones.length;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2.5,
        shadowOffset: 3.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar (Pokédex Area Style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: RetroColors.ink, width: 2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.map_rounded,
                  size: 18,
                  color: RetroColors.forestGreen,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'ÀREA DE DISTRIBUCIÓ (MAPA POKÉDEX)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: RetroColors.ink,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: RetroColors.forestGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: RetroColors.forestGreen, width: 1.2),
                  ),
                  child: Text(
                    '$activeCount / 7 zones',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: RetroColors.forestGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // The Pixel Art Map Viewport
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3B6F), // Mediterranean deep blue
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RetroColors.ink, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Pixel map background
                    Image.asset(
                      'assets/images/map/catalonia_pixel_map.jpg',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackPixelCanvas(),
                    ),

                    // Active and Interactive Zone Overlays
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;

                        return AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Stack(
                              children: [
                                for (final zone in CataloniaZone.values)
                                  _buildZoneOverlay(zone, w, h),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    // Top-Right Compass / Legend Indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.90),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: RetroColors.ink, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            PixelCompassIcon(size: 13),
                            SizedBox(width: 4),
                            Text(
                              'CATALUNYA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                color: RetroColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    PixelZonePinIcon(isActive: true, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Presència habitual',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    PixelZonePinIcon(isActive: false, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Sense presència',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Zone Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: CataloniaZone.values.map((zone) {
                final isPresent = widget.activeZones.contains(zone);
                final isSelected = _selectedZone == zone;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    backgroundColor: Colors.white,
                    selectedColor: isPresent
                        ? RetroColors.arcadeRed.withOpacity(0.20)
                        : RetroColors.mintMuted,
                    side: BorderSide(
                      color: isSelected ? RetroColors.ink : Colors.transparent,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PixelZonePinIcon(
                          isActive: isPresent,
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          zone.shortLabel,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                isSelected ? FontWeight.w900 : FontWeight.w700,
                            color: isPresent
                                ? (isSelected
                                    ? RetroColors.arcadeRed
                                    : RetroColors.ink)
                                : RetroColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedZone = zone;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Selected Zone Details Banner
          if (_selectedZone != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.activeZones.contains(_selectedZone!)
                      ? const Color(0xFFFFF3F0)
                      : RetroColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.activeZones.contains(_selectedZone!)
                        ? RetroColors.arcadeRed.withOpacity(0.6)
                        : RetroColors.inkSoft.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PixelZonePinIcon(
                          isActive: widget.activeZones.contains(_selectedZone!),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _selectedZone!.label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: RetroColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comarques: ${_selectedZone!.comarques}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedZone!.habitatDescription,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: RetroColors.ink,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildZoneOverlay(CataloniaZone zone, double w, double h) {
    final bounds = zone.relativeBounds;
    final isPresent = widget.activeZones.contains(zone);
    final isSelected = _selectedZone == zone;

    if (!isPresent && !isSelected) {
      return const SizedBox.shrink();
    }

    final left = bounds.left * w;
    final top = bounds.top * h;
    final width = bounds.width * w;
    final height = bounds.height * h;

    // Glowing animation value for presence
    final pulse = _pulseAnimation.value;
    final overlayColor = isPresent
        ? RetroColors.arcadeRed.withOpacity(0.35 + 0.30 * pulse)
        : Colors.white.withOpacity(0.20);
    final borderColor = isSelected
        ? RetroColors.ink
        : (isPresent ? RetroColors.arcadeRed : Colors.transparent);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedZone = zone;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: overlayColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.8,
            ),
            boxShadow: isPresent
                ? [
                    BoxShadow(
                      color: RetroColors.arcadeRed.withOpacity(0.4 * pulse),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isPresent
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const PixelBoletIcon(size: 13),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackPixelCanvas() {
    return Container(
      color: const Color(0xFF2B4C7E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.terrain_rounded, size: 42, color: Color(0xFF6E563B)),
            SizedBox(height: 6),
            Text(
              'Mapa de Catalunya',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
