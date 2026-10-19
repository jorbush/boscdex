import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../domain/models/culinary_recipe.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/forager_level.dart';

/// Active section of the Boscdex catalog (Mushrooms vs. Trees).
enum BoscdexSection {
  bolets,
  arbres,
}

/// Active section provider (defaults to Mushrooms / Bolets).
final boscdexSectionProvider =
    StateProvider<BoscdexSection>((ref) => BoscdexSection.bolets);

/// Represents a single mushroom entry in the Boscdex discovery album.
class BoscdexEntry {
  final Bolet bolet;
  final bool isDiscovered;
  final DateTime? discoveredAt;

  const BoscdexEntry({
    required this.bolet,
    required this.isDiscovered,
    this.discoveredAt,
  });
}

/// Active filter applied to the Bolets grid.
enum BoletFilter {
  all,
  edibles,
  gourmet,
  toxic,
  partnerTrees,
}

/// Active filter applied to the Bolets grid. Defaults to all mushrooms.
final boscdexFilterProvider =
    StateProvider<BoletFilter>((ref) => BoletFilter.all);

/// Asynchronously streams cataloged mushrooms reactively joined with their discovery status.
final boscdexEntriesProvider = StreamProvider<List<BoscdexEntry>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.descobrimentDao.watchAllDiscoveries().asyncMap((discoveries) async {
    final bolets = await db.boletDao.getAllBolets();
    final discoveryMap = {for (var d in discoveries) d.boletId: d};

    return bolets.map((bolet) {
      final discovery = discoveryMap[bolet.id];
      return BoscdexEntry(
        bolet: bolet,
        isDiscovered: discovery != null,
        discoveredAt: discovery?.discoveredAt,
      );
    }).toList();
  });
});

/// Fetches the set of mushroom IDs that have indicator tree associations.
final boletIdsWithTreesProvider = FutureProvider<Set<String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final ids = await db.boletDao.getBoletIdsWithArbres();
  return ids.toSet();
});

/// Returns the filtered list of Boscdex mushroom entries according to the selected filter tab.
final filteredBoscdexEntriesProvider = Provider<List<BoscdexEntry>>((ref) {
  final filter = ref.watch(boscdexFilterProvider);
  final entriesAsync = ref.watch(boscdexEntriesProvider);

  return entriesAsync.maybeWhen(
    data: (entries) {
      switch (filter) {
        case BoletFilter.all:
          return entries;
        case BoletFilter.edibles:
          return entries.where((e) {
            final ed = EdibilitatExtension.fromString(e.bolet.edibility);
            return ed.isEdible;
          }).toList();
        case BoletFilter.gourmet:
          return entries
              .where(
                  (e) => CulinaryRecipe.gourmetSpeciesIds.contains(e.bolet.id))
              .toList();
        case BoletFilter.toxic:
          return entries.where((e) {
            final ed = EdibilitatExtension.fromString(e.bolet.edibility);
            return ed.isToxic;
          }).toList();
        case BoletFilter.partnerTrees:
          final treeBoletIds = ref.watch(boletIdsWithTreesProvider).value ?? {};
          return entries
              .where((e) => treeBoletIds.contains(e.bolet.id))
              .toList();
      }
    },
    orElse: () => [],
  );
});

/// Reactive stream tracking the total count of discovered mushrooms.
final discoveryCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.descobrimentDao.watchDiscoveryCount();
});

/// Reactive count of total cataloged mushroom species in the database.
final totalBoletsCountProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(boscdexEntriesProvider);
  return entriesAsync.value?.length ?? 0;
});

// ==========================================
// ARBRES BOSCDEX PROVIDERS
// ==========================================

/// Represents a single indicator tree entry in the Arbres Boscdex.
class ArbreBoscdexEntry {
  final Arbre arbre;
  final bool isVisited;
  final int associatedBoletsCount;

  const ArbreBoscdexEntry({
    required this.arbre,
    required this.isVisited,
    required this.associatedBoletsCount,
  });
}

/// Active filter applied to the Arbres grid ('tots', 'agulla', 'caduca', 'perenne').
final arbreFilterProvider = StateProvider<String>((ref) => 'tots');

/// Stream of identified indicator tree IDs based on field sightings in the database.
final identifiedArbreIdsProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.avistamentDao.watchIdentifiedArbreIds();
});

/// Asynchronously loads all indicator trees joined with field identification status and associated mushroom counts.
/// Uses getAssociatedBoletCounts to eliminate N+1 queries.
final arbresBoscdexProvider = StreamProvider<List<ArbreBoscdexEntry>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.avistamentDao
      .watchIdentifiedArbreIds()
      .asyncMap((identifiedIds) async {
    final arbres = await db.arbreDao.getAllArbres();
    final countsMap = await db.arbreDao.getAssociatedBoletCounts();

    return arbres.map((arbre) {
      return ArbreBoscdexEntry(
        arbre: arbre,
        isVisited: identifiedIds.contains(arbre.id),
        associatedBoletsCount: countsMap[arbre.id] ?? 0,
      );
    }).toList();
  });
});

/// Returns the filtered list of Arbres Boscdex entries according to leaf type filter.
final filteredArbresBoscdexProvider = Provider<List<ArbreBoscdexEntry>>((ref) {
  final filter = ref.watch(arbreFilterProvider);
  final arbresAsync = ref.watch(arbresBoscdexProvider);

  return arbresAsync.maybeWhen(
    data: (entries) {
      if (filter == 'tots') return entries;
      final query = filter.toLowerCase();
      return entries.where((e) {
        return e.arbre.leafType.toLowerCase().contains(query);
      }).toList();
    },
    orElse: () => [],
  );
});

/// Number of indicator trees identified/visited by the user.
final visitedArbresCountProvider = Provider<int>((ref) {
  final arbresAsync = ref.watch(arbresBoscdexProvider);
  return arbresAsync.maybeWhen(
    data: (entries) => entries.where((e) => e.isVisited).length,
    orElse: () => 0,
  );
});

// ==========================================
// FORAGER PROGRESSION & LEVEL PROVIDERS
// ==========================================

/// Reactive stream tracking the total count of badges awarded to the user.
final awardedBadgesCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.insigniaDao.watchAwardedInsignies().map((list) => list.length);
});

/// Reactive stream tracking the total count of user field sightings in the journal.
final totalSightingsCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.avistamentDao.getAllAvistaments().map((list) => list.length);
});

/// Reactive player forager rank and experience level dynamically computed
/// from discoveries, tree sightings, unlocked badges, and journal entries.
final foragerLevelProvider = Provider<ForagerLevel>((ref) {
  final discoveries = ref.watch(discoveryCountProvider).value ?? 0;
  final trees = ref.watch(visitedArbresCountProvider);
  final badges = ref.watch(awardedBadgesCountProvider).value ?? 0;
  final sightings = ref.watch(totalSightingsCountProvider).value ?? 0;

  return ForagerLevel.calculate(
    discoveredBolets: discoveries,
    identifiedArbres: trees,
    awardedBadges: badges,
    totalSightings: sightings,
  );
});
