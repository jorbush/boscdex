import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/services/photo_export_service.dart';
import '../shared/pixel_icons.dart';
import 'avistament_detail_sheet.dart';
import 'journal_map_view.dart';
import 'journal_provider.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avistamentsAsync = ref.watch(avistamentsProvider);
    final boletsMap = ref.watch(allBoletsMapProvider).value ?? {};
    final arbresMap = ref.watch(allArbresMapProvider).value ?? {};
    final viewMode = ref.watch(journalViewModeProvider);

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      appBar: AppBar(
        backgroundColor: RetroColors.creamBg,
        elevation: 0,
        title: Text(
          l10n.journalTitle,
          style: const TextStyle(
            color: RetroColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewModeSelector(context, ref, viewMode, l10n),
              Container(
                color: RetroColors.ink,
                height: 2,
              ),
            ],
          ),
        ),
      ),
      body: avistamentsAsync.when(
        data: (avistaments) {
          final listView = avistaments.isEmpty
              ? _buildEmptyState(l10n)
              : _buildListView(avistaments, boletsMap, arbresMap, l10n);

          final mapView = JournalMapView(
            avistaments: avistaments,
            boletsMap: boletsMap,
            arbresMap: arbresMap,
          );

          return IndexedStack(
            index: viewMode == JournalViewMode.llista ? 0 : 1,
            children: [
              listView,
              mapView,
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: RetroColors.forestGreen),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildViewModeSelector(BuildContext context, WidgetRef ref,
      JournalViewMode currentMode, AppLocalizations l10n) {
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
            _buildModeTab(
              key: const Key('journal_tab_list'),
              context: context,
              ref: ref,
              icon: const PixelListIcon(size: 18),
              label: l10n.journalTabList,
              targetMode: JournalViewMode.llista,
              isSelected: currentMode == JournalViewMode.llista,
            ),
            _buildModeTab(
              key: const Key('journal_tab_map'),
              context: context,
              ref: ref,
              icon: const PixelMapIcon(size: 18),
              label: l10n.journalTabMap,
              targetMode: JournalViewMode.mapa,
              isSelected: currentMode == JournalViewMode.mapa,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab({
    required Key key,
    required BuildContext context,
    required WidgetRef ref,
    required Widget icon,
    required String label,
    required JournalViewMode targetMode,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        key: key,
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!isSelected) {
            HapticFeedback.selectionClick();
            ref.read(journalViewModeProvider.notifier).state = targetMode;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: isSelected
                ? Border.all(color: RetroColors.ink, width: 1.8)
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
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: isSelected
                        ? RetroColors.forestGreen
                        : RetroColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: RetroDecorations.card(
            backgroundColor: Colors.white,
            borderColor: RetroColors.ink,
            borderWidth: 2.5,
            shadowOffset: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PixelListIcon(size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.journalAdventureDiary,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.forestGreen,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.journalEmptyPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: RetroColors.ink,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
    List<Avistament> avistaments,
    Map<String, String> boletsMap,
    Map<String, String> arbresMap,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: avistaments.length,
      itemBuilder: (context, index) {
        final avistament = avistaments[index];
        final langCode = AppLocalizations.of(context).languageCode;
        final isTree = avistament.arbreId != null;
        final displayName = isTree
            ? SpeciesLocalizer.getTreeName(
                avistament.arbreId,
                languageCode: langCode,
                fallbackName: arbresMap[avistament.arbreId] ??
                    avistament.arbreId ??
                    'Arbre indicador',
              )
            : SpeciesLocalizer.getMushroomName(
                avistament.boletId,
                languageCode: langCode,
                fallbackName: boletsMap[avistament.boletId] ??
                    avistament.boletId ??
                    'Bolet',
              );

        final hasPhotoPath =
            avistament.photoPath != null && avistament.photoPath!.isNotEmpty;
        final confidencePct = avistament.confidenceScore != null
            ? (avistament.confidenceScore! * 100).toInt()
            : null;
        final isHighConfidence = (avistament.confidenceScore ?? 0.0) >= 0.70;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: RetroDecorations.card(
            backgroundColor: Colors.white,
            borderColor: RetroColors.ink,
            borderWidth: 2,
            shadowOffset: 3,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: hasPhotoPath ? Colors.black : RetroColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RetroColors.ink, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasPhotoPath
                  ? Image.file(
                      PhotoExportService.resolveFile(avistament.photoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Center(
                        child: isTree
                            ? Image.asset(
                                'assets/images/trees/${avistament.arbreId}.png',
                                cacheWidth: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    const PixelArbreIcon(size: 24),
                              )
                            : Image.asset(
                                'assets/images/mushrooms/${avistament.boletId}.png',
                                cacheWidth: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    const PixelBoletIcon(size: 24),
                              ),
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: isTree
                            ? Image.asset(
                                'assets/images/trees/${avistament.arbreId}.png',
                                cacheWidth: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    const PixelArbreIcon(size: 24),
                              )
                            : Image.asset(
                                'assets/images/mushrooms/${avistament.boletId}.png',
                                cacheWidth: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/silhouettes/generic_mushroom.png',
                                  cacheWidth: 150,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const PixelBoletIcon(size: 24),
                                ),
                              ),
                      ),
                    ),
            ),
            title: Row(
              children: [
                if (isTree) ...[
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: RetroColors.forestGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: RetroColors.forestGreen, width: 1.2),
                    ),
                    child: Text(
                      l10n.categoryArbre,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.forestGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: RetroColors.ink,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (confidencePct != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isHighConfidence
                          ? RetroColors.forestGreen.withOpacity(0.12)
                          : RetroColors.goldCoin.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isHighConfidence
                            ? RetroColors.forestGreen
                            : RetroColors.ink,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      '$confidencePct%',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: isHighConfidence
                            ? RetroColors.forestGreen
                            : RetroColors.ink,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: RetroColors.inkSoft),
                    const SizedBox(width: 4),
                    Text(
                      _dateFormat.format(avistament.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ],
                ),
                if (avistament.notes != null &&
                    avistament.notes!.isNotEmpty &&
                    !avistament.notes!.startsWith(
                        'Avistament identificat amb Boscdex AI')) ...[
                  const SizedBox(height: 4),
                  Text(
                    avistament.notes!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                ],
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: RetroColors.sectionBg,
                shape: BoxShape.circle,
                border: Border.all(color: RetroColors.ink, width: 1.5),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: RetroColors.ink,
                size: 18,
              ),
            ),
            onTap: () {
              HapticFeedback.selectionClick();
              AvistamentDetailSheet.show(context, avistament);
            },
          ),
        );
      },
    );
  }
}
