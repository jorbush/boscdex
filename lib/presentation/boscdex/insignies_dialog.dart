import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/insignia.dart' as domain;
import '../../providers/database_provider.dart';
import '../shared/pixel_icons.dart';
import 'boscdex_provider.dart';
import 'forager_level_dialog.dart';

/// Auto-disposing FutureProvider loading fresh badge data each time the dialog opens.
final insigniesProvider =
    FutureProvider.autoDispose<List<domain.Insignia>>((ref) async {
  final appDb = ref.watch(appDatabaseProvider);
  final dbBadges = await appDb.insigniaDao.getAllInsignies();
  final badgeMap = {for (final b in dbBadges) b.id: b};

  return domain.Insignia.registry.map((def) {
    final dbRow = badgeMap[def.id];
    return domain.Insignia(
      id: def.id,
      nom: def.nom,
      descripcio: def.descripcio,
      iconPath: def.iconPath,
      targetCount: def.targetCount,
      progressCount: dbRow?.progressCount ?? 0,
      awardedAt: dbRow?.awardedAt,
    );
  }).toList();
});

/// Modal bottom sheet showcasing the Boscdex achievement badges in a retro arcade trophy case.
class InsigniesDialog extends ConsumerWidget {
  const InsigniesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InsigniesDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(insigniesProvider);

    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.78;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: sheetHeight,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: RetroColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: RetroColors.ink, width: 2.5),
        ),
        child: badgesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: RetroColors.forestGreen),
            ),
          ),
          error: (err, _) => Center(
            child: Text(
              'Error carregant les insígnies: $err',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: RetroColors.arcadeRed,
              ),
            ),
          ),
          data: (badges) {
            final l10n = AppLocalizations.of(context);
            final awardedCount = badges.where((b) => b.isAwarded).length;
            final foragerLevel = ref.watch(foragerLevelProvider);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: RetroColors.ink,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const PixelTrophyIcon(size: 28),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              l10n.myBadges,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: RetroColors.ink,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: RetroColors.goldCoin,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RetroColors.ink, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: RetroColors.ink,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        '$awardedCount/${badges.length}',
                        style: const TextStyle(
                          color: RetroColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.badgeSubtitle,
                  style: const TextStyle(
                    color: RetroColors.inkSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Forager Level Navigation Pill
                GestureDetector(
                  key: const Key('insignies_lvl_banner'),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                    ForagerLevelDialog.show(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: RetroColors.mintWash,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RetroColors.ink, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: RetroColors.forestGreen,
                            borderRadius: BorderRadius.circular(4),
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${foragerLevel.title(l10n.languageCode)} • ${foragerLevel.totalXp} XP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: RetroColors.ink,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: RetroColors.ink,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Badges Grid
                Expanded(
                  child: ListView.separated(
                    itemCount: badges.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      return _buildBadgeCard(context, badge);
                    },
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      l10n.settingsClose,
                      style: const TextStyle(
                        color: RetroColors.inkSoft,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, domain.Insignia badge) {
    final l10n = AppLocalizations.of(context);
    final isUnlocked = badge.isAwarded;
    final progress = badge.targetCount > 0
        ? (badge.progressCount / badge.targetCount).clamp(0.0, 1.0)
        : 0.0;
    final badgeName = l10n.badgeName(badge.id);
    final badgeDesc = l10n.badgeDescription(badge.id);
    final progressText = isUnlocked
        ? l10n.badgeUnlocked
        : l10n.badgeProgress(badge.progressCount, badge.targetCount);

    return Semantics(
      label: '$badgeName, $progressText. $badgeDesc',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnlocked ? RetroColors.goldLight : RetroColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RetroColors.ink, width: 2.2),
          boxShadow: [
            BoxShadow(
              color: isUnlocked ? RetroColors.goldCoin : RetroColors.ink,
              offset: const Offset(2.5, 2.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Badge Icon / Medal
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? RetroColors.goldCoin : Colors.white,
                border: Border.all(color: RetroColors.ink, width: 2),
              ),
              child: Icon(
                isUnlocked ? _getBadgeIcon(badge.id) : Icons.lock_outline,
                color: isUnlocked ? RetroColors.ink : RetroColors.inkSoft,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          badgeName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: isUnlocked
                                ? RetroColors.ink
                                : RetroColors.inkSoft,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isUnlocked) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: RetroColors.forestGreen,
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: RetroColors.ink, width: 1.5),
                          ),
                          child: Text(
                            l10n.badgeUnlocked.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          '${badge.progressCount}/${badge.targetCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: RetroColors.inkSoft,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badgeDesc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: RetroColors.inkSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(height: 8),
                    RetroProgressBar(
                      progress: progress,
                      height: 8,
                      totalSegments: 8,
                      fillColor: RetroColors.questAmber,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBadgeIcon(String id) {
    switch (id) {
      case 'primer_pas':
      case 'primer_pas_al_bosc':
        return Icons.hiking_rounded;
      case 'cacador_rovellons':
      case 'cacador_de_rovellons':
        return Icons.shopping_basket_rounded;
      case 'micoleg_prudent':
        return Icons.health_and_safety_rounded;
      case 'alianca_silvestre':
        return Icons.park_rounded;
      case 'cistell_tardor':
      case 'cistell_de_tardor':
        return Icons.inventory_2_rounded;
      case 'mestre_boletaire':
        return Icons.military_tech_rounded;
      case 'senyor_dels_ceps':
        return Icons.workspace_premium_rounded;
      case 'gourmet_del_bosc':
        return Icons.restaurant_menu_rounded;
      case 'amic_dels_arbres':
        return Icons.forest_rounded;
      case 'esperit_de_primavera':
        return Icons.wb_sunny_rounded;
      case 'sentinella_toxic':
        return Icons.shield_rounded;
      case 'quadern_de_camp':
        return Icons.menu_book_rounded;
      case 'cartograf_del_bosc':
        return Icons.explore_rounded;
      case 'gran_enciclopedia':
        return Icons.auto_stories_rounded;
      default:
        return Icons.verified;
    }
  }
}
