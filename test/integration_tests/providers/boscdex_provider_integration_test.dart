import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/providers/database_provider.dart';

void main() {
  group('Boscdex Provider Integration', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('boscdexEntriesProvider loads all 21 seeded species', () async {
      final entries = await container.read(boscdexEntriesProvider.future);
      expect(entries.length, equals(21));

      // All initial entries should be undiscovered
      final discoveredCount = entries.where((e) => e.isDiscovered).length;
      expect(discoveredCount, equals(0));
    });

    test('filteredBoscdexEntriesProvider correctly filters comestibles',
        () async {
      // Set filter to comestibles
      container.read(boscdexFilterProvider.notifier).state = 'comestibles';

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
      container.read(boscdexFilterProvider.notifier).state = 'tòxics/mortals';

      await container.read(boscdexEntriesProvider.future);

      final filtered = container.read(filteredBoscdexEntriesProvider);
      expect(filtered, isNotEmpty);
      for (final item in filtered) {
        expect(item.bolet.edibility, anyOf('toxic', 'mortal'));
      }
    });

    test('filteredBoscdexEntriesProvider correctly filters arbres socis',
        () async {
      container.read(boscdexFilterProvider.notifier).state = 'arbres socis';

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
      await db.descobrimentDao.markDiscovered(
          'lactarius_deliciosus', DateTime.now(), 'avistament-1');

      // Refresh entries
      container.refresh(boscdexEntriesProvider);
      entries = await container.read(boscdexEntriesProvider.future);

      final rovello =
          entries.firstWhere((e) => e.bolet.id == 'lactarius_deliciosus');
      expect(rovello.isDiscovered, isTrue);
    });
  });
}
