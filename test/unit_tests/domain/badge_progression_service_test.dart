import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/badge_progression_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('BadgeProgressionService', () {
    late AppDatabase db;
    late BadgeProgressionService service;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      service = BadgeProgressionService();
    });

    test(
        'syncBadgeProgression updates primer_pas_al_bosc when discovery exists',
        () async {
      // 1. Mark a discovery
      final now = DateTime.now();
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-1',
          boletId: const Value('boletus_edulis'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('boletus_edulis', now, 'sighting-1');

      // 2. Sync progression
      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
      );

      final primerPas = updated.firstWhere((b) => b.id == 'primer_pas_al_bosc');
      expect(primerPas.isAwarded, isTrue);

      // Verify persisted in DB
      final dbBadge = await db.insigniaDao.getInsignia('primer_pas_al_bosc');
      expect(dbBadge?.awardedAt, isNotNull);
      expect(dbBadge?.progressCount, equals(1));
    });

    test(
        'syncBadgeProgression updates cacador_de_rovellons when both rovellons are discovered',
        () async {
      final now = DateTime.now();
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-rovello',
          boletId: const Value('lactarius_deliciosus'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', now, 'sighting-rovello');

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-pinetell',
          boletId: const Value('lactarius_sanguifluus'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('lactarius_sanguifluus', now, 'sighting-pinetell');

      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
      );

      final cacador = updated.firstWhere((b) => b.id == 'cacador_de_rovellons');
      expect(cacador.isAwarded, isTrue);

      final dbBadge = await db.insigniaDao.getInsignia('cacador_de_rovellons');
      expect(dbBadge?.awardedAt, isNotNull);
      expect(dbBadge?.progressCount, equals(2));
    });

    test(
        'syncBadgeProgression updates alianca_silvestre when visiting tree with discovered mushroom',
        () async {
      final now = DateTime.now();
      // lactarius_deliciosus is associated with pinus_sylvestris (Pi roig)
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-rovello',
          boletId: const Value('lactarius_deliciosus'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', now, 'sighting-rovello');

      // User visits Pi roig
      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
        currentTreeId: 'pinus_sylvestris',
      );

      final alianca = updated.firstWhere((b) => b.id == 'alianca_silvestre');
      expect(alianca.isAwarded, isTrue);

      final dbBadge = await db.insigniaDao.getInsignia('alianca_silvestre');
      expect(dbBadge?.awardedAt, isNotNull);
    });

    test(
        'syncBadgeProgression updates senyor_dels_ceps when both ceps are discovered',
        () async {
      final now = DateTime.now();
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-cep-1',
          boletId: const Value('boletus_edulis'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('boletus_edulis', now, 'sighting-cep-1');

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion.insert(
          id: 'sighting-cep-2',
          boletId: const Value('boletus_aereus'),
          timestamp: now,
        ),
      );
      await db.descobrimentDao
          .markDiscovered('boletus_aereus', now, 'sighting-cep-2');

      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
      );

      final cepsBadge = updated.firstWhere((b) => b.id == 'senyor_dels_ceps');
      expect(cepsBadge.isAwarded, isTrue);
      expect(cepsBadge.progressCount, equals(2));

      final inDb = await db.insigniaDao.getInsignia('senyor_dels_ceps');
      expect(inDb?.awardedAt, isNotNull);
      expect(inDb?.progressCount, equals(2));
    });

    test(
        'syncBadgeProgression updates quadern_de_camp and cartograf_del_bosc from sightings',
        () async {
      final now = DateTime.now();
      for (int i = 0; i < 10; i++) {
        await db.avistamentDao.insertAvistament(
          AvistamentsCompanion.insert(
            id: 'sighting-$i',
            boletId: const Value('boletus_edulis'),
            timestamp: now,
            latitude: i < 5 ? const Value(41.75) : const Value(null),
            longitude: i < 5 ? const Value(2.15) : const Value(null),
          ),
        );
      }

      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
      );

      final quadern = updated.firstWhere((b) => b.id == 'quadern_de_camp');
      expect(quadern.isAwarded, isTrue);
      expect(quadern.progressCount, equals(10));

      final cartograf = updated.firstWhere((b) => b.id == 'cartograf_del_bosc');
      expect(cartograf.isAwarded, isTrue);
      expect(cartograf.progressCount, equals(5));
    });

    test('syncBadgeProgression updates amic_dels_arbres when trees are visited',
        () async {
      final now = DateTime.now();
      final treeIds = [
        'pinus_sylvestris',
        'pinus_halepensis',
        'quercus_ilex',
        'fagus_sylvatica',
        'castanea_sativa',
      ];

      for (int i = 0; i < treeIds.length; i++) {
        await db.avistamentDao.insertAvistament(
          AvistamentsCompanion.insert(
            id: 'tree-sighting-$i',
            arbreId: Value(treeIds[i]),
            timestamp: now,
          ),
        );
      }

      final updated = await service.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
      );

      final amic = updated.firstWhere((b) => b.id == 'amic_dels_arbres');
      expect(amic.isAwarded, isTrue);
      expect(amic.progressCount, equals(5));
    });
  });
}
