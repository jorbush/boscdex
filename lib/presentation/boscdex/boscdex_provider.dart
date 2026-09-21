import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../domain/models/edibilitat.dart';

/// Represents a single mushroom entry in the Boscdex discovery album.
class BoscdexEntry {
  final Bolet bolet;
  final bool isDiscovered;
  final DateTime? discoveredAt;

  BoscdexEntry({
    required this.bolet,
    required this.isDiscovered,
    this.discoveredAt,
  });
}

/// Active filter applied to the Boscdex grid ('tots', 'comestibles', 'tòxics/mortals', 'arbres socis').
final boscdexFilterProvider = StateProvider<String>((ref) => 'tots');

/// Asynchronously loads all cataloged mushrooms joined with their discovery status.
final boscdexEntriesProvider = FutureProvider<List<BoscdexEntry>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final bolets = await db.boletDao.getAllBolets();
  final discoveries = await db.descobrimentDao.getAllDiscoveries();

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

/// Fetches the set of mushroom IDs that have indicator tree associations.
final boletIdsWithTreesProvider = FutureProvider<Set<String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final ids = await db.boletDao.getBoletIdsWithArbres();
  return ids.toSet();
});

/// Returns the filtered list of Boscdex entries according to the selected filter tab.
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
          return ed == Edibilitat.toxic || ed == Edibilitat.mortal;
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
