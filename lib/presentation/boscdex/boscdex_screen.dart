import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'boscdex_provider.dart';
import 'boscdex_grid.dart';
import 'arbre_grid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/retro_decorations.dart';
import '../../providers/sound_provider.dart';
import '../shared/boscdex_logo.dart';
import '../shared/pixel_icons.dart';
import 'insignies_dialog.dart';

/// Main Boscdex screen supporting Dual-Dex modes: Bolets (Mushrooms) and Arbres (Indicator Trees).
class BoscdexScreen extends ConsumerWidget {
  const BoscdexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(boscdexSectionProvider);

    // Bolets stats
    final discoveryCountAsync = ref.watch(discoveryCountProvider);
    final boletCount = discoveryCountAsync.value ?? 0;
    final boletProgress = boletCount / AppConstants.maxDexEntries;
    final boletFilter = ref.watch(boscdexFilterProvider);

    // Arbres stats
    final arbresAsync = ref.watch(arbresBoscdexProvider);
    final totalArbres = arbresAsync.value?.length ?? 0;
    final visitedCount = ref.watch(visitedArbresCountProvider);
    final arbreProgress = totalArbres > 0 ? (visitedCount / totalArbres) : 0.0;
    final arbreFilter = ref.watch(arbreFilterProvider);

    final isBolets = section == BoscdexSection.bolets;

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
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: RetroColors.forestGreen,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: RetroColors.ink, width: 1.5),
                      ),
                      child: const Text(
                        'LVL 1',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isBolets
                          ? '$boletCount/${AppConstants.maxDexEntries} descoberts'
                          : '$visitedCount/$totalArbres identificats',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 64,
                      child: RetroProgressBar(
                        progress: isBolets ? boletProgress : arbreProgress,
                        height: 8,
                        totalSegments: 6,
                        fillColor: RetroColors.forestGreen,
                      ),
                    ),
                  ],
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
            tooltip: 'Configuració',
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
            tooltip: 'Les Meves Insígnies',
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
              _buildSectionSelector(context, ref, section),

              // Contextual Filter Chips
              if (isBolets)
                _buildBoletFilterBar(context, ref, boletFilter)
              else
                _buildArbreFilterBar(context, ref, arbreFilter),

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

  Widget _buildSectionSelector(
      BuildContext context, WidgetRef ref, BoscdexSection currentSection) {
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
              label: 'Bolets',
              targetSection: BoscdexSection.bolets,
              isSelected: currentSection == BoscdexSection.bolets,
            ),
            _buildSectionTab(
              key: const Key('section_tab_arbres'),
              context: context,
              ref: ref,
              icon: const PixelArbreIcon(size: 18),
              label: 'Arbres',
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

  Widget _buildBoletFilterBar(
      BuildContext context, WidgetRef ref, String currentFilter) {
    const filters = ['tots', 'comestibles', 'tòxics/mortals', 'arbres socis'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f;
          final label = f[0].toUpperCase() + f.substring(1);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildFilterChip(
              key: Key('bolet_filter_$f'),
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

  Widget _buildArbreFilterBar(
      BuildContext context, WidgetRef ref, String currentFilter) {
    const filters = ['tots', 'agulla', 'caduca', 'perenne'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f;
          final label = f[0].toUpperCase() + f.substring(1);
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
