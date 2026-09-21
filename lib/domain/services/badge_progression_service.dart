import 'dart:developer' as developer;
import '../../data/database/app_database.dart' as db_pkg;
import '../models/insignia.dart';
import 'badge_service.dart';

/// Central domain service to evaluate and persist badge achievements.
class BadgeProgressionService {
  final BadgeService _badgeService;

  BadgeProgressionService({BadgeService? badgeService})
      : _badgeService = badgeService ?? BadgeService();

  /// Evaluates and records progression for all registered badges in the database.
  Future<List<Insignia>> syncBadgeProgression({
    required db_pkg.AppDatabase db,
    required int toxicComparisonViewCount,
    String? currentTreeId,
    Set<String>? visitedTreeIds,
  }) async {
    try {
      final allDiscoveries = await db.descobrimentDao.getAllDiscoveries();
      final allDbInsignies = await db.insigniaDao.getAllInsignies();

      final hasRovello =
          allDiscoveries.any((d) => d.boletId == 'lactarius_deliciosus');
      final hasPinetell =
          allDiscoveries.any((d) => d.boletId == 'lactarius_sanguifluus');

      // Check tree alliance:
      // Either user inspected an indicator tree whose associated mushrooms are discovered,
      // or user discovered a mushroom whose associated tree has been visited.
      bool hasTreeAlliance = false;
      final discoveredBoletIds = allDiscoveries.map((d) => d.boletId).toSet();

      if (currentTreeId != null) {
        final associatedMushrooms =
            await db.boletDao.getBoletsByArbreId(currentTreeId);
        hasTreeAlliance =
            associatedMushrooms.any((b) => discoveredBoletIds.contains(b.id));
      } else if (visitedTreeIds != null && visitedTreeIds.isNotEmpty) {
        for (final treeId in visitedTreeIds) {
          final associated = await db.boletDao.getBoletsByArbreId(treeId);
          if (associated.any((b) => discoveredBoletIds.contains(b.id))) {
            hasTreeAlliance = true;
            break;
          }
        }
      }

      final registryMap = {for (final b in Insignia.registry) b.id: b};

      final currentDomainBadges = allDbInsignies.map((dbBadge) {
        final reg = registryMap[dbBadge.id];
        return Insignia(
          id: dbBadge.id,
          nom: reg?.nom ?? dbBadge.id,
          descripcio: reg?.descripcio ?? '',
          iconPath: reg?.iconPath ?? '',
          progressCount: dbBadge.progressCount,
          targetCount: reg?.targetCount ?? 1,
          awardedAt: dbBadge.awardedAt,
        );
      }).toList();

      final updatedBadges = await _badgeService.evaluateBadges(
        discoveryCount: allDiscoveries.length,
        hasRovello: hasRovello,
        hasPinetell: hasPinetell,
        toxicComparisonViewCount: toxicComparisonViewCount,
        hasTreeAlliance: hasTreeAlliance,
        currentBadges: currentDomainBadges,
      );

      for (final b in updatedBadges) {
        await db.insigniaDao.updateProgress(b.id, b.progressCount);
        if (b.isAwarded && b.awardedAt != null) {
          await db.insigniaDao.awardInsignia(b.id, b.awardedAt!);
        }
      }

      return updatedBadges;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to sync badge progression: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeProgressionService',
      );
      return [];
    }
  }
}
