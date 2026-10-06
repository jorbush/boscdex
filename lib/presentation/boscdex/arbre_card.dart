import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import 'boscdex_provider.dart';

/// Retro videogame card representing an indicator tree in the Arbres Boscdex.
class ArbreCard extends StatelessWidget {
  final ArbreBoscdexEntry entry;

  const ArbreCard({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final arbre = entry.arbre;
    final l10n = AppLocalizations.of(context);
    final langCode = l10n.languageCode;
    final displayName = SpeciesLocalizer.getTreeName(
      arbre.id,
      languageCode: langCode,
      fallbackName: arbre.catalanName,
    );

    return Semantics(
      button: true,
      label: l10n.treeCardSemantics(
        displayName,
        arbre.scientificName,
        arbre.leafType,
        entry.isVisited,
        entry.associatedBoletsCount,
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/arbre/${arbre.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: RetroDecorations.card(
            backgroundColor: Colors.white,
            shadowOffset: 2.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top badges row: Leaf Type + Visited Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leaf type chip
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: RetroColors.forestLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: RetroColors.ink, width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.energy_savings_leaf_rounded,
                            size: 10,
                            color: RetroColors.forestGreen,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              arbre.leafType,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: RetroColors.forestGreen,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Visited / Discovered status
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: entry.isVisited
                          ? RetroColors.forestGreen
                          : RetroColors.sectionBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: Icon(
                      entry.isVisited ? Icons.check : Icons.camera_alt_outlined,
                      size: 10,
                      color:
                          entry.isVisited ? Colors.white : RetroColors.inkSoft,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Tree Pixel Art / Icon Centerpiece
              Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: RetroColors.forestLight,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      arbre.imageAssetPath ??
                          'assets/images/trees/${arbre.id}.png',
                      cacheWidth: 200,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Localized Vernacular Name
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Scientific Name
              Text(
                arbre.scientificName,
                style: const TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: RetroColors.inkSoft,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Ecological Relationship: Associated Mushrooms Count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: RetroColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: RetroColors.ink, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🍄', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Text(
                      l10n.associatedBoletsCount(entry.associatedBoletsCount),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.park_rounded,
        size: 28,
        color: RetroColors.forestGreen,
      ),
    );
  }
}
