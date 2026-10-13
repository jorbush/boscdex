import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/forager_level.dart';
import '../shared/pixel_icons.dart';
import 'boscdex_provider.dart';

/// Modal bottom sheet showcasing the adventurer's forager level, XP breakdown,
/// and complete milestone rank progression.
class ForagerLevelDialog extends ConsumerWidget {
  const ForagerLevelDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ForagerLevelDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foragerLevel = ref.watch(foragerLevelProvider);
    final l10n = AppLocalizations.of(context);
    final lang = l10n.languageCode;
    final mediaQuery = MediaQuery.of(context);
    // Sheet opens comfortably below top status bar, matching journal and badge sheets
    final sheetHeight = mediaQuery.size.height * 0.75;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: sheetHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: RetroColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: RetroColors.ink, width: 2.5),
        ),
        child: Column(
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
            const SizedBox(height: 14),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const PixelBoletIcon(size: 26),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l10n.foragerLevelHeader,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RetroColors.forestGreen,
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
                    'LVL ${foragerLevel.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: RetroFonts.pixel,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scrollable Body
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 1. Current Level Hero Card
                  _buildCurrentRankCard(foragerLevel, l10n, lang),
                  const SizedBox(height: 16),

                  // 2. XP Breakdown Grid
                  _buildXpBreakdownCard(foragerLevel, l10n),
                  const SizedBox(height: 16),

                  // 3. Ranks Roadmap
                  _buildRanksRoadmap(foragerLevel, l10n, lang),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRankCard(
      ForagerLevel foragerLevel, AppLocalizations l10n, String lang) {
    final title = foragerLevel.title(lang);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LVL ${foragerLevel.level}',
                      style: const TextStyle(
                        fontFamily: RetroFonts.pixel,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: RetroColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: RetroColors.goldLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: RetroColors.ink, width: 1.5),
                ),
                child: Text(
                  '${foragerLevel.totalXp} XP',
                  style: const TextStyle(
                    fontFamily: RetroFonts.pixel,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar towards next level
          RetroProgressBar(
            progress: foragerLevel.progress,
            height: 12,
            totalSegments: 10,
            fillColor: RetroColors.forestGreen,
            emptyColor: RetroColors.progressBarEmpty,
          ),
          const SizedBox(height: 8),

          // Subtitle with remaining XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  foragerLevel.isMaxLevel
                      ? l10n.maxLevelAchieved
                      : l10n.xpNeededForNext(
                          foragerLevel.nextLevelThresholdXp! -
                              foragerLevel.totalXp,
                          foragerLevel.level + 1,
                        ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.inkSoft,
                  ),
                ),
              ),
              if (!foragerLevel.isMaxLevel)
                Text(
                  '${(foragerLevel.progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: RetroColors.forestGreen,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXpBreakdownCard(
      ForagerLevel foragerLevel, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 18,
                color: RetroColors.ink,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.xpBreakdownTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildXpStatTile(
                  icon: const PixelBoletIcon(size: 18),
                  label: l10n.xpBreakdownMushrooms,
                  count: foragerLevel.discoveredBolets,
                  xp: foragerLevel.xpFromBolets,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildXpStatTile(
                  icon: const PixelArbreIcon(size: 18),
                  label: l10n.xpBreakdownTrees,
                  count: foragerLevel.identifiedArbres,
                  xp: foragerLevel.xpFromArbres,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildXpStatTile(
                  icon: const PixelTrophyIcon(size: 18),
                  label: l10n.xpBreakdownBadges,
                  count: foragerLevel.awardedBadges,
                  xp: foragerLevel.xpFromBadges,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildXpStatTile(
                  icon: const PixelJournalIcon(size: 18),
                  label: l10n.xpBreakdownSightings,
                  count: foragerLevel.totalSightings,
                  xp: foragerLevel.xpFromSightings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXpStatTile({
    required Widget icon,
    required String label,
    required int count,
    required int xp,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: RetroColors.creamBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: RetroColors.ink, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.inkSoft,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: RetroColors.ink,
                ),
              ),
              Text(
                '+$xp XP',
                style: const TextStyle(
                  fontFamily: RetroFonts.pixel,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: RetroColors.forestGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRanksRoadmap(
      ForagerLevel foragerLevel, AppLocalizations l10n, String lang) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.military_tech_outlined,
                size: 20,
                color: RetroColors.ink,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.ranksRoadmapTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final def in ForagerLevel.allLevels) ...[
            _buildRankRow(def, foragerLevel, l10n, lang),
            if (def.level != ForagerLevel.allLevels.last.level)
              const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildRankRow(
    ForagerLevelDefinition def,
    ForagerLevel userLevel,
    AppLocalizations l10n,
    String lang,
  ) {
    final isCurrent = def.level == userLevel.level;
    final isUnlocked = def.level <= userLevel.level;

    final backgroundColor = isCurrent
        ? RetroColors.mintWash
        : (isUnlocked ? const Color(0xFFF7FDF9) : const Color(0xFFF5F5F5));

    final borderColor = isCurrent
        ? RetroColors.forestGreen
        : (isUnlocked ? RetroColors.ink : const Color(0xFFCCCCCC));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isCurrent ? 2.0 : 1.2,
        ),
      ),
      child: Row(
        children: [
          // Badge indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? RetroColors.forestGreen
                  : RetroColors.progressBarEmpty,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'L${def.level}',
              style: TextStyle(
                fontFamily: RetroFonts.pixel,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? Colors.white : RetroColors.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.title(lang),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: isUnlocked ? RetroColors.ink : RetroColors.inkSoft,
                  ),
                ),
                Text(
                  '${def.xpThreshold} XP',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? RetroColors.forestGreen
                        : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: RetroColors.goldCoin,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: RetroColors.ink, width: 1),
              ),
              child: Text(
                l10n.currentRankTag,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            )
          else if (isUnlocked)
            const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: RetroColors.forestGreen,
            )
          else
            const Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: Color(0xFFAAAAAA),
            ),
        ],
      ),
    );
  }
}
