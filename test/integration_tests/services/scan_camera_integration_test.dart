import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/nivell_seguretat.dart';
import 'package:boscdex/domain/services/badge_progression_service.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/domain/services/safety_gate_service.dart';

void main() {
  group('Scan Camera Hardware & Classification Integration Tests', () {
    late AppDatabase db;
    late ClassifierService classifier;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      classifier = MockClassifierService();
    });

    tearDown(() async {
      await db.close();
    });

    test(
        'Captured camera photo bytes flow through classification, safety gate, sighting journal, and album unlock',
        () async {
      // 1. Simulate non-empty captured photo bytes from native camera
      final simulatedCameraBytes = Uint8List.fromList([
        0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49,
        0x46, // JPEG header
        0x00, 0x01, 0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00,
        0xFF, 0xDB, 0x00, 0x43, 0x00, 0x08, 0x06, 0x06, 0x07, 0x06,
        0xFF, 0xD9, // JPEG trailer
      ]);
      expect(simulatedCameraBytes, isNotEmpty);

      // 2. Classifier processes image bytes into top candidate
      final candidates = await classifier.classify(simulatedCameraBytes);
      expect(candidates, isNotEmpty);
      final top = candidates.first;
      expect(top.boletId, equals('lactarius_deliciosus'));
      expect(top.displayName, contains('Rovelló'));

      // 3. SafetyGate inspects database for lookalikes
      final lookalikes = await db.boletDao.getToxicLookalikes(top.boletId);
      final safetyService = SafetyGateService(
        toxicLookalikesData: {
          top.boletId: lookalikes.map((l) => l.id).toList(),
        },
      );
      final safety = safetyService.evaluateSafety(candidates);
      expect(safety, isNotNull);
      if (lookalikes.isNotEmpty) {
        expect(safety, equals(NivellSeguretat.confusioPossible));
      }

      // 4. Register Sighting in Drift Database
      final avistamentId = const Uuid().v4();
      final now = DateTime.now();

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          boletId: drift.Value(top.boletId),
          timestamp: drift.Value(now),
          latitude: const drift.Value(41.8765),
          longitude: const drift.Value(2.3456),
          altitude: const drift.Value(980.0),
          confidenceScore: drift.Value(top.confidence),
          notes: const drift.Value('Capturat amb la càmera nativa de Boscdex'),
        ),
      );

      // Verify sighting is recorded
      final sightings =
          await db.avistamentDao.getAvistamentsByBolet(top.boletId);
      expect(sightings, hasLength(1));
      expect(sightings.first.altitude, equals(980.0));
      expect(sightings.first.notes, contains('càmera nativa'));

      // 5. Unlock specimen in Boscdex album
      final wasDiscoveredBefore =
          await db.descobrimentDao.isDiscovered(top.boletId);
      expect(wasDiscoveredBefore, isFalse);

      await db.descobrimentDao.markDiscovered(top.boletId, now, avistamentId);

      final wasDiscoveredAfter =
          await db.descobrimentDao.isDiscovered(top.boletId);
      expect(wasDiscoveredAfter, isTrue);

      // 6. Evaluate Badge Progression
      final badgeProgressService = BadgeProgressionService();
      final newlyAwarded = await badgeProgressService.syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
        visitedTreeIds: {},
      );

      // First mushroom discovery unlocks "primer_pas_al_bosc" badge
      final firstStepBadge =
          await db.insigniaDao.getInsignia('primer_pas_al_bosc');
      expect(firstStepBadge, isNotNull);
      expect(firstStepBadge!.awardedAt, isNotNull);
      expect(newlyAwarded.map((b) => b.id), contains('primer_pas_al_bosc'));
    });

    test(
        'Tree scan mode with captured photo correctly retrieves mycorrhizal fungi from database',
        () async {
      final simulatedTreeBytes = Uint8List.fromList([
        0xFF,
        0xD8,
        0xFF,
        0xE0,
        0x00,
        0x10,
        0x4A,
        0x46,
        0x49,
        0x46,
        0xFF,
        0xD9,
      ]);

      // 1. Classify indicator tree
      final treeCandidates = await classifier.classifyTree(simulatedTreeBytes);
      expect(treeCandidates, isNotEmpty);
      final topTree = treeCandidates.first;

      // 2. Query database for tree and symbiotic fungi
      final arbre = await db.arbreDao.getArbreById(topTree.arbreId);
      expect(arbre, isNotNull);

      final symbioticBolets =
          await db.boletDao.getBoletsByArbreId(topTree.arbreId);
      expect(symbioticBolets, isNotEmpty);

      // If tree is Pinus sylvestris (pi_roig), it should be associated with rovellons
      if (topTree.arbreId == 'pinus_sylvestris') {
        expect(
            symbioticBolets.map((b) => b.id), contains('lactarius_deliciosus'));
      }

      // 3. Track tree as visited and verify badge progression
      final newlyAwarded = await BadgeProgressionService().syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: 0,
        visitedTreeIds: {topTree.arbreId},
      );
      expect(newlyAwarded, isA<List>());
    });
  });
}
