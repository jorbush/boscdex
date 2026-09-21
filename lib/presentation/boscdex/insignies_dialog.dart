import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/retro_decorations.dart';
import '../../domain/models/insignia.dart' as domain;
import '../../providers/database_provider.dart';

/// Provider for loading badges asynchronously.
final insigniesProvider = FutureProvider<List<domain.Insignia>>((ref) async {
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

/// Modal bottom sheet showcasing the 6 starter badges in a retro arcade trophy case.
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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
          final awardedCount = badges.where((b) => b.isAwarded).length;

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
                  Row(
                    children: const [
                      Icon(Icons.emoji_events,
                          color: RetroColors.goldCoin, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Les Meves Insígnies',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: RetroColors.ink,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              const Text(
                'Fites de col·lecció i reconeixement de camp del boletaire.',
                style: TextStyle(
                  color: RetroColors.inkSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

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
                  child: const Text(
                    'Tancar',
                    style: TextStyle(
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
    );
  }

  Widget _buildBadgeCard(BuildContext context, domain.Insignia badge) {
    final isUnlocked = badge.isAwarded;
    final progress = badge.targetCount > 0
        ? (badge.progressCount / badge.targetCount).clamp(0.0, 1.0)
        : 0.0;

    return Semantics(
      label:
          '${badge.nom}, ${badge.isAwarded ? "Desbloquejada" : "Progrés: ${badge.progressCount} de ${badge.targetCount}"}. ${badge.descripcio}',
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
                isUnlocked ? Icons.verified : Icons.lock_outline,
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
                      Text(
                        badge.nom,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color:
                              isUnlocked ? RetroColors.ink : RetroColors.inkSoft,
                        ),
                      ),
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
                          child: const Text(
                            'DESBLOQUEJAT',
                            style: TextStyle(
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
                    badge.descripcio,
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
}
