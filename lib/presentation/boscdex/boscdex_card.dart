import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'boscdex_provider.dart';
import '../shared/rarity_border.dart';
import '../shared/edibility_badge.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';

class BoscdexCard extends StatelessWidget {
  final BoscdexEntry entry;

  const BoscdexCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final dexNum = entry.bolet.dexNumber.toString().padLeft(3, '0');

    if (!entry.isDiscovered) {
      final assetPath = entry.bolet.imageAssetPath ??
          'assets/images/mushrooms/${entry.bolet.id}.png';

      return Semantics(
        button: true,
        label:
            'Bolet número $dexNum no descobert. Toca per veure hàbitat i ubicació',
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/boscdex/${entry.bolet.id}');
          },
          child: Container(
            padding: const EdgeInsets.all(2.2),
            decoration: RetroDecorations.card(
              backgroundColor: RetroColors.screenOverlay,
              shadowOffset: 2.5,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            RetroColors.ink,
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            assetPath,
                            cacheWidth: 200,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildGenericSilhouette(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: const BoxDecoration(
                      color: RetroColors.mintMuted,
                      border: Border(
                        top: BorderSide(color: RetroColors.ink, width: 1.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '#$dexNum ???',
                        style: const TextStyle(
                          color: RetroColors.inkSoft,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final rarity = RaritatTierExtension.fromString(entry.bolet.rarityTier);
    final edibility = EdibilitatExtension.fromString(entry.bolet.edibility);

    return Semantics(
      button: true,
      label:
          '${entry.bolet.catalanName}, número $dexNum, raresa ${rarity.label}, comestibilitat ${edibility.label}',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/boscdex/${entry.bolet.id}');
        },
        child: RarityBorder(
          tier: rarity,
          borderRadius: BorderRadius.circular(14),
          borderWidth: 3,
          child: Container(
            decoration: const BoxDecoration(
              color: RetroColors.surface,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        color: RetroColors.surfaceLight,
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Image.asset(
                            entry.bolet.imageAssetPath ??
                                'assets/images/mushrooms/${entry.bolet.id}.png',
                            cacheWidth: 200,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: RetroColors.surface,
                        border: Border(
                          top: BorderSide(color: RetroColors.ink, width: 1.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#$dexNum',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: RetroColors.inkSoft,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            entry.bolet.catalanName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: RetroColors.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: EdibilityBadge(
                    edibilitat: edibility,
                    iconOnly: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final initial = entry.bolet.catalanName.isNotEmpty
        ? entry.bolet.catalanName[0].toUpperCase()
        : '?';

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: RetroColors.forestGreen.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: RetroColors.forestGreen.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: RetroColors.forestGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildGenericSilhouette() {
    return Image.asset(
      'assets/images/silhouettes/generic_mushroom.png',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.question_mark_rounded,
        size: 36,
        color: RetroColors.ink,
      ),
    );
  }
}
