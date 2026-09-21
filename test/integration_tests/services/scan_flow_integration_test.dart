import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/insignia.dart' as domain;
import 'package:boscdex/domain/models/nivell_seguretat.dart';
import 'package:boscdex/domain/services/badge_service.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/domain/services/safety_gate_service.dart';

void main() {
  group('Scan Flow Integration', () {
    late AppDatabase db;
    late ClassifierService classifier;
    late BadgeService badgeService;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      classifier = MockClassifierService();
      badgeService = BadgeService();
    });

    tearDown(() async {
      await db.close();
    });

    test('full scan to registration flow works seamlessly with database',
        () async {
      // 1. Classifier generates candidates
      final candidates = await classifier.classify(Uint8List(0));
      expect(candidates, isNotEmpty);
      final topCandidate = candidates.first;

      // 2. SafetyGateService inspects lookalikes from DB
      final lookalikes =
          await db.boletDao.getToxicLookalikes(topCandidate.boletId);
      final safetyService = SafetyGateService(
        toxicLookalikesData: {
          topCandidate.boletId: lookalikes.map((l) => l.id).toList(),
        },
      );

      final safety = safetyService.evaluateSafety(candidates);
      if (lookalikes.isNotEmpty && topCandidate.confidence >= 0.70) {
        expect(safety, equals(NivellSeguretat.confusioPossible));
      }

      // 3. User registers sighting
      final avistamentId = const Uuid().v4();
      final now = DateTime.now();

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          boletId: drift.Value(topCandidate.boletId),
          timestamp: drift.Value(now),
          confidenceScore: drift.Value(topCandidate.confidence),
          notes: const drift.Value('Trobada de prova al bosc'),
        ),
      );

      // Verify sighting is persisted
      final sightings =
          await db.avistamentDao.getAvistamentsByBolet(topCandidate.boletId);
      expect(sightings.length, equals(1));
      expect(sightings.first.id, equals(avistamentId));

      // 4. Mark specimen as discovered
      await db.descobrimentDao
          .markDiscovered(topCandidate.boletId, now, avistamentId);
      final isDiscovered =
          await db.descobrimentDao.isDiscovered(topCandidate.boletId);
      expect(isDiscovered, isTrue);

      // 5. Evaluate and persist badge updates
      final allDiscoveries = await db.descobrimentDao.getAllDiscoveries();
      final allInsignies = await db.insigniaDao.getAllInsignies();

      final currentDomainBadges = allInsignies.map((b) {
        return domain.Insignia(
          id: b.id,
          nom: b.id,
          descripcio: '',
          iconPath: '',
          progressCount: b.progressCount,
          targetCount: 1,
          awardedAt: b.awardedAt,
        );
      }).toList();

      final updatedBadges = await badgeService.evaluateBadges(
        discoveryCount: allDiscoveries.length,
        hasRovello:
            allDiscoveries.any((d) => d.boletId == 'lactarius_deliciosus'),
        hasPinetell:
            allDiscoveries.any((d) => d.boletId == 'lactarius_sanguifluus'),
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: currentDomainBadges,
      );

      // Primer pas al bosc should be awarded
      final primerPas =
          updatedBadges.firstWhere((b) => b.id == 'primer_pas_al_bosc');
      expect(primerPas.isAwarded, isTrue);

      // Persist to DB
      await db.insigniaDao.awardInsignia(primerPas.id, primerPas.awardedAt!);
      final updatedInDb =
          await db.insigniaDao.getInsignia('primer_pas_al_bosc');
      expect(updatedInDb?.awardedAt, isNotNull);
    });
  });
}
