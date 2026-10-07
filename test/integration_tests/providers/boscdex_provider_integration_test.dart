import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Boscdex Provider Integration', () {
    late AppDatabase db;
    late ProviderContainer container;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'visitedArbres': <String>[]});
      prefs = await SharedPreferences.getInstance();
      db = AppDatabase.forTesting(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('boscdexEntriesProvider loads all 22 seeded species', () async {
      final entries = await container.read(boscdexEntriesProvider.future);
      expect(entries.length, equals(22));

      // All initial entries should be undiscovered
      final discoveredCount = entries.where((e) => e.isDiscovered).length;
      expect(discoveredCount, equals(0));
    });

    test('filteredBoscdexEntriesProvider correctly filters comestibles',
        () async {
      // Set filter to comestibles
      container.read(boscdexFilterProvider.notifier).state =
          BoletFilter.edibles;

      // Read entries first to populate
      await container.read(boscdexEntriesProvider.future);

      final filtered = container.read(filteredBoscdexEntriesProvider);
      expect(filtered, isNotEmpty);
      for (final item in filtered) {
        expect(item.bolet.edibility, anyOf('excellent', 'comestible'));
      }
    });

    test('filteredBoscdexEntriesProvider correctly filters tòxics/mortals',
        () async {
      container.read(boscdexFilterProvider.notifier).state = BoletFilter.toxic;

      await container.read(boscdexEntriesProvider.future);

      final filtered = container.read(filteredBoscdexEntriesProvider);
      expect(filtered, isNotEmpty);
      for (final item in filtered) {
        expect(item.bolet.edibility, anyOf('toxic', 'mortal'));
      }
    });

    test('filteredBoscdexEntriesProvider correctly filters arbres socis',
        () async {
      container.read(boscdexFilterProvider.notifier).state =
          BoletFilter.partnerTrees;

      await container.read(boscdexEntriesProvider.future);
      await container.read(boletIdsWithTreesProvider.future);

      final filtered = container.read(filteredBoscdexEntriesProvider);
      expect(filtered, isNotEmpty);

      // Verify each filtered mushroom has an indicator tree association
      for (final item in filtered) {
        final arbres = await db.boletDao.getAssociatedArbres(item.bolet.id);
        expect(arbres, isNotEmpty);
      }
    });

    test('marking discovery updates discoveryCount and boscdexEntries',
        () async {
      var entries = await container.read(boscdexEntriesProvider.future);
      expect(
          entries
              .firstWhere((e) => e.bolet.id == 'lactarius_deliciosus')
              .isDiscovered,
          isFalse);

      // Mark discovery in DB
      final now = DateTime.now();
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'avistament-1',
          boletId: const Value('lactarius_deliciosus'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', now, 'avistament-1');

      // Refresh entries
      container.refresh(boscdexEntriesProvider);
      entries = await container.read(boscdexEntriesProvider.future);

      final rovello =
          entries.firstWhere((e) => e.bolet.id == 'lactarius_deliciosus');
      expect(rovello.isDiscovered, isTrue);
    });

    test(
        'arbresBoscdexProvider loads all 5 seeded indicator trees with bolets count',
        () async {
      final trees = await container.read(arbresBoscdexProvider.future);
      expect(trees.length, equals(5));

      final piRoig = trees.firstWhere((t) => t.arbre.id == 'pinus_sylvestris');
      expect(piRoig.arbre.catalanName, equals('Pi roig'));
      expect(piRoig.arbre.leafType, equals('Agulla'));
      expect(piRoig.associatedBoletsCount, greaterThan(0));
      expect(piRoig.isVisited, isFalse);
    });

    test('filteredArbresBoscdexProvider correctly filters by leaf type',
        () async {
      await container.read(arbresBoscdexProvider.future);

      // Filter: agulla
      container.read(arbreFilterProvider.notifier).state = 'agulla';
      var filtered = container.read(filteredArbresBoscdexProvider);
      expect(filtered, isNotEmpty);
      expect(filtered.every((t) => t.arbre.leafType == 'Agulla'), isTrue);

      // Filter: caduca
      container.read(arbreFilterProvider.notifier).state = 'caduca';
      filtered = container.read(filteredArbresBoscdexProvider);
      expect(filtered, isNotEmpty);
      expect(filtered.every((t) => t.arbre.leafType == 'Caduca'), isTrue);
    });

    test(
        'visitedArbresCountProvider increments when tree sighting is recorded in database',
        () async {
      await container.read(arbresBoscdexProvider.future);
      expect(container.read(visitedArbresCountProvider), equals(0));

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: const Value('test-tree-sighting-1'),
          arbreId: const Value('pinus_sylvestris'),
          timestamp: Value(DateTime.now()),
        ),
      );

      // Settle stream event
      await Future.delayed(const Duration(milliseconds: 100));
      await container.read(arbresBoscdexProvider.future);

      expect(container.read(visitedArbresCountProvider), equals(1));
    });
  });
}
