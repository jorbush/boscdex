import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'boscdex_provider.dart';
import 'boscdex_grid.dart';
import 'arbre_grid.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../providers/sound_provider.dart';
import '../shared/boscdex_logo.dart';
import '../shared/pixel_icons.dart';
import 'insignies_dialog.dart';
import 'forager_level_dialog.dart';

/// Main Boscdex screen supporting Dual-Dex modes: Bolets (Mushrooms) and Arbres (Indicator Trees).
class BoscdexScreen extends ConsumerWidget {
  const BoscdexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(boscdexSectionProvider);

    // Bolets stats
    final discoveryCountAsync = ref.watch(discoveryCountProvider);
    final boletCount = discoveryCountAsync.value ?? 0;
    final totalBolets = ref.watch(totalBoletsCountProvider);
    final boletProgress = totalBolets > 0 ? (boletCount / totalBolets) : 0.0;
    final boletFilter = ref.watch(boscdexFilterProvider);

    // Arbres stats
    final arbresAsync = ref.watch(arbresBoscdexProvider);
    final totalArbres = arbresAsync.value?.length ?? 0;
    final visitedCount = ref.watch(visitedArbresCountProvider);
    final arbreProgress = totalArbres > 0 ? (visitedCount / totalArbres) : 0.0;
    final arbreFilter = ref.watch(arbreFilterProvider);

    final isBolets = section == BoscdexSection.bolets;
    final foragerLevel = ref.watch(foragerLevelProvider);

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BoscdexLogo(
              size: 38,
              showBorder: true,
              borderWidth: 1.8,
              showShadow: true,
              shadowOffset: 2.0,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Boscdex',
                      style: TextStyle(
                        fontFamily: RetroFonts.pixel,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      button: true,
                      label: l10n.levelWithTitle(foragerLevel.level,
                          foragerLevel.title(l10n.languageCode)),
                      child: GestureDetector(
                        key: const Key('boscdex_lvl_badge'),
                        onTap: () {
                          ref.read(soundEffectServiceProvider).playBlip();
                          HapticFeedback.selectionClick();
                          ForagerLevelDialog.show(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: RetroColors.forestGreen,
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: RetroColors.ink, width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(1, 1),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            'LVL ${foragerLevel.level}',
                            style: const TextStyle(
                              fontFamily: RetroFonts.pixel,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Semantics(
                  button: true,
                  label: isBolets
                      ? '${l10n.discoveredRatio(boletCount, totalBolets)}, ${l10n.levelWithTitle(foragerLevel.level, foragerLevel.title(l10n.languageCode))}'
                      : '${l10n.identifiedTreesRatio(visitedCount, totalArbres)}, ${l10n.levelWithTitle(foragerLevel.level, foragerLevel.title(l10n.languageCode))}',
                  child: GestureDetector(
                    key: const Key('boscdex_progress_row'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      ref.read(soundEffectServiceProvider).playBlip();
                      HapticFeedback.selectionClick();
                      ForagerLevelDialog.show(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isBolets
                                ? l10n.discoveredRatio(boletCount, totalBolets)
                                : l10n.identifiedTreesRatio(
                                    visitedCount, totalArbres),
                            key: const Key('boscdex_discovered_text'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: RetroColors.inkSoft,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            key: const Key('boscdex_progress_bar'),
                            width: 64,
                            child: RetroProgressBar(
                              progress:
                                  isBolets ? boletProgress : arbreProgress,
                              height: 8,
                              totalSegments: 6,
                              fillColor: RetroColors.forestGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: RetroColors.mintWash,
                shape: BoxShape.circle,
                border: Border.all(color: RetroColors.ink, width: 1.8),
                boxShadow: const [
                  BoxShadow(
                    color: RetroColors.ink,
                    offset: Offset(1.5, 1.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_rounded,
                size: 20,
                color: RetroColors.ink,
              ),
            ),
            tooltip: l10n.settingsTitle,
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/settings');
            },
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: RetroColors.goldCoin,
                shape: BoxShape.circle,
                border: Border.all(color: RetroColors.ink, width: 1.8),
                boxShadow: const [
                  BoxShadow(
                    color: RetroColors.ink,
                    offset: Offset(1.5, 1.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const PixelTrophyIcon(
                size: 20,
              ),
            ),
            tooltip: l10n.myBadges,
            onPressed: () {
              HapticFeedback.lightImpact();
              InsigniesDialog.show(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dual-Dex Mode Selector (Bolets vs Arbres)
              _buildSectionSelector(context, ref, section, l10n),

              // Contextual Filter Chips
              if (isBolets)
                _buildBoletFilterBar(context, ref, boletFilter, l10n)
              else
                _buildArbreFilterBar(context, ref, arbreFilter, l10n),

              Container(
                height: 2,
                color: RetroColors.ink,
              ),
            ],
          ),
        ),
      ),
      body: isBolets ? const BoscdexGrid() : const ArbreGrid(),
    );
  }

  Widget _buildSectionSelector(BuildContext context, WidgetRef ref,
      BoscdexSection currentSection, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: RetroColors.sectionBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RetroColors.ink, width: 2),
        ),
        child: Row(
          children: [
            _buildSectionTab(
              key: const Key('section_tab_bolets'),
              context: context,
              ref: ref,
              icon: const PixelBoletIcon(size: 18),
              label: l10n.sectionBolets,
              targetSection: BoscdexSection.bolets,
              isSelected: currentSection == BoscdexSection.bolets,
            ),
            _buildSectionTab(
              key: const Key('section_tab_arbres'),
              context: context,
              ref: ref,
              icon: const PixelArbreIcon(size: 18),
              label: l10n.sectionArbres,
              targetSection: BoscdexSection.arbres,
              isSelected: currentSection == BoscdexSection.arbres,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTab({
    Key? key,
    required BuildContext context,
    required WidgetRef ref,
    required Widget icon,
    required String label,
    required BoscdexSection targetSection,
    required bool isSelected,
  }) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: GestureDetector(
          key: key,
          onTap: () {
            if (ref.read(boscdexSectionProvider) != targetSection) {
              ref.read(soundEffectServiceProvider).playBlip();
            }
            HapticFeedback.selectionClick();
            ref.read(boscdexSectionProvider.notifier).state = targetSection;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? RetroColors.forestGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: isSelected
                  ? Border.all(color: RetroColors.ink, width: 1.5)
                  : null,
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: RetroColors.ink,
                        offset: Offset(1, 1),
                        blurRadius: 0,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : RetroColors.inkSoft,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoletFilterBar(BuildContext context, WidgetRef ref,
      BoletFilter currentFilter, AppLocalizations l10n) {
    const filters = BoletFilter.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f;
          final String label;
          switch (f) {
            case BoletFilter.all:
              label = l10n.filterAll;
              break;
            case BoletFilter.edibles:
              label = l10n.filterEdibles;
              break;
            case BoletFilter.gourmet:
              label = l10n.filterGourmet;
              break;
            case BoletFilter.toxic:
              label = l10n.filterToxics;
              break;
            case BoletFilter.partnerTrees:
              label = l10n.filterTreePartners;
              break;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildFilterChip(
              key: Key('bolet_filter_${f.name}'),
              label: label,
              isSelected: isSelected,
              onTap: () {
                if (!isSelected) {
                  ref.read(soundEffectServiceProvider).playBlip();
                }
                HapticFeedback.selectionClick();
                ref.read(boscdexFilterProvider.notifier).state = f;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArbreFilterBar(BuildContext context, WidgetRef ref,
      String currentFilter, AppLocalizations l10n) {
    const filters = ['tots', 'agulla', 'caduca', 'perenne'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f;
          final String label;
          switch (f) {
            case 'tots':
              label = l10n.filterAll;
              break;
            case 'agulla':
              label = l10n.filterNeedle;
              break;
            case 'caduca':
              label = l10n.filterDeciduous;
              break;
            case 'perenne':
              label = l10n.filterEvergreen;
              break;
            default:
              label = f[0].toUpperCase() + f.substring(1);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildFilterChip(
              key: Key('arbre_filter_$f'),
              label: label,
              isSelected: isSelected,
              onTap: () {
                if (!isSelected) {
                  ref.read(soundEffectServiceProvider).playBlip();
                }
                HapticFeedback.selectionClick();
                ref.read(arbreFilterProvider.notifier).state = f;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip({
    Key? key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        key: key,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? RetroColors.forestGreen : RetroColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RetroColors.ink, width: 1.8),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: RetroColors.ink,
                      offset: Offset(1.5, 1.5),
                      blurRadius: 0,
                    ),
                  ]
                : const [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : RetroColors.ink,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
