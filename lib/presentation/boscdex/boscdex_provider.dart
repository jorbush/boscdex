import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../domain/models/edibilitat.dart';

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

/// Active filter applied to the Bolets grid ('tots', 'comestibles', 'tòxics/mortals', 'arbres socis').
final boscdexFilterProvider = StateProvider<String>((ref) => 'tots');

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
      if (filter == 'tots') return entries;
      if (filter == 'comestibles') {
        return entries.where((e) {
          final ed = EdibilitatExtension.fromString(e.bolet.edibility);
          return ed.isEdible;
        }).toList();
      }
      if (filter == 'tòxics/mortals') {
        return entries.where((e) {
          final ed = EdibilitatExtension.fromString(e.bolet.edibility);
          return ed.isToxic;
        }).toList();
      }
      if (filter == 'arbres socis') {
        final treeBoletIds = ref.watch(boletIdsWithTreesProvider).value ?? {};
        return entries.where((e) => treeBoletIds.contains(e.bolet.id)).toList();
      }
      return entries;
    },
    orElse: () => [],
  );
});

/// Reactive stream tracking the total count of discovered mushrooms.
final discoveryCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.descobrimentDao.watchDiscoveryCount();
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

/// Asynchronously loads all indicator trees joined with visited status and associated mushroom counts.
/// Uses getAssociatedBoletCounts to eliminate N+1 queries.
final arbresBoscdexProvider =
    FutureProvider<List<ArbreBoscdexEntry>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final visitedIds = ref.watch(visitedArbresProvider);
  final arbres = await db.arbreDao.getAllArbres();
  final countsMap = await db.arbreDao.getAssociatedBoletCounts();

  return arbres.map((arbre) {
    return ArbreBoscdexEntry(
      arbre: arbre,
      isVisited: visitedIds.contains(arbre.id),
      associatedBoletsCount: countsMap[arbre.id] ?? 0,
    );
  }).toList();
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
