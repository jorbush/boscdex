import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart' as db;
import '../../domain/models/insignia.dart' as domain;
import '../../providers/database_provider.dart';

/// Modal dialog or bottom sheet showcasing the 6 starter badges,
/// their unlock status, and real-time progress.
class InsigniesDialog extends ConsumerWidget {
  const InsigniesDialog({Key? key}) : super(key: key);

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
    final appDb = ref.watch(appDatabaseProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: FutureBuilder<List<db.Insignia>>(
        future: appDb.insigniaDao.getAllInsignies(),
        builder: (context, snapshot) {
          final dbBadges = snapshot.data ?? [];
          final badgeMap = {for (final b in dbBadges) b.id: b};

          final badges = domain.Insignia.registry.map((def) {
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

          final awardedCount = badges.where((b) => b.isAwarded).length;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Color(0xFFE9C46A), size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Les Meves Insígnies',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9C46A).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE9C46A)),
                    ),
                    child: Text(
                      '$awardedCount/${badges.length}',
                      style: const TextStyle(
                        color: Color(0xFFE9C46A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Fites de col·lecció i reconeixement de camp del boletaire.',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Badges Grid
              Expanded(
                child: ListView.separated(
                  itemCount: badges.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tancar',
                      style: TextStyle(color: Colors.white60)),
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
    final progress = (badge.progressCount / badge.targetCount).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnlocked
            ? const Color(0xFF1B4332).withOpacity(0.5)
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? const Color(0xFFE9C46A) : Colors.white10,
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Badge Icon / Medal
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? const Color(0xFFE9C46A).withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              border: Border.all(
                color: isUnlocked ? const Color(0xFFE9C46A) : Colors.white24,
              ),
            ),
            child: Icon(
              isUnlocked ? Icons.verified : Icons.lock_outline,
              color: isUnlocked ? const Color(0xFFE9C46A) : Colors.white38,
              size: 24,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.white : Colors.white54,
                      ),
                    ),
                    if (isUnlocked) ...[
                      const Text(
                        'DESBLOQUEJAT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE9C46A),
                        ),
                      ),
                    ] else ...[
                      Text(
                        '${badge.progressCount}/${badge.targetCount}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white38),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  badge.descripcio,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? Colors.white70 : Colors.white38,
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
