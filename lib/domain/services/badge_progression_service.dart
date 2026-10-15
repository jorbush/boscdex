import 'dart:developer' as developer;
import 'package:drift/drift.dart' as drift;
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
      final sightingCount = await db.avistamentDao.countAvistaments();
      final gpsSightingCount = await db.avistamentDao.countGpsAvistaments();

      final discoveredBoletIds = allDiscoveries.map((d) => d.boletId).toSet();
      final hasRovello = discoveredBoletIds.contains('lactarius_deliciosus');
      final hasPinetell = discoveredBoletIds.contains('lactarius_sanguifluus');

      // Check tree alliance:
      // Either user inspected an indicator tree whose associated mushrooms are discovered,
      // or user discovered a mushroom whose associated tree has been visited.
      bool hasTreeAlliance = false;

      final effectiveVisitedTreeIds =
          (visitedTreeIds != null && visitedTreeIds.isNotEmpty)
              ? visitedTreeIds
              : (await db.avistamentDao.getIdentifiedArbreIds()).toSet();

      if (currentTreeId != null) {
        final associatedMushrooms =
            await db.boletDao.getBoletsByArbreId(currentTreeId);
        hasTreeAlliance =
            associatedMushrooms.any((b) => discoveredBoletIds.contains(b.id));
      } else if (effectiveVisitedTreeIds.isNotEmpty) {
        for (final treeId in effectiveVisitedTreeIds) {
          final associated = await db.boletDao.getBoletsByArbreId(treeId);
          if (associated.any((b) => discoveredBoletIds.contains(b.id))) {
            hasTreeAlliance = true;
            break;
          }
        }
      }

      final visitedTreeCount = effectiveVisitedTreeIds.length;

      final dbMap = {for (final b in allDbInsignies) b.id: b};

      final currentDomainBadges = Insignia.registry.map((reg) {
        final dbRow = dbMap[reg.id];
        return Insignia(
          id: reg.id,
          nom: reg.nom,
          descripcio: reg.descripcio,
          iconPath: reg.iconPath,
          progressCount: dbRow?.progressCount ?? 0,
          targetCount: reg.targetCount,
          awardedAt: dbRow?.awardedAt,
        );
      }).toList();

      final updatedBadges = await _badgeService.evaluateBadges(
        discoveryCount: allDiscoveries.length,
        hasRovello: hasRovello,
        hasPinetell: hasPinetell,
        toxicComparisonViewCount: toxicComparisonViewCount,
        hasTreeAlliance: hasTreeAlliance,
        currentBadges: currentDomainBadges,
        discoveredBoletIds: discoveredBoletIds,
        visitedTreeCount: visitedTreeCount,
        sightingCount: sightingCount,
        gpsSightingCount: gpsSightingCount,
      );

      for (final b in updatedBadges) {
        final old = dbMap[b.id];
        if (old == null) {
          await db.into(db.insignies).insert(
                db_pkg.InsigniesCompanion(
                  id: drift.Value(b.id),
                  progressCount: drift.Value(b.progressCount),
                  awardedAt: drift.Value(b.awardedAt),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
        } else {
          if (old.progressCount != b.progressCount) {
            await db.insigniaDao.updateProgress(b.id, b.progressCount);
          }
          if (b.isAwarded && b.awardedAt != null && old.awardedAt == null) {
            await db.insigniaDao.awardInsignia(b.id, b.awardedAt!);
          }
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
