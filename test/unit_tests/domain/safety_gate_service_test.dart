import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/data/database/seed/seed_data.dart';
import 'package:boscdex/domain/models/classificacio_result.dart';
import 'package:boscdex/domain/models/edibilitat.dart';
import 'package:boscdex/domain/models/nivell_seguretat.dart';
import 'package:boscdex/domain/services/safety_gate_service.dart';

void main() {
  group('SafetyGateService', () {
    late SafetyGateService service;

    setUp(() {
      service = SafetyGateService(
        toxicLookalikesData: {
          'lactarius_deliciosus': ['amanita_muscaria'],
          'cantharellus_cibarius': ['omphalotus_olearius'],
        },
        confidenceThreshold: 0.70,
      );
    });

    test('returns incert when candidate list is empty', () {
      final level = service.evaluateSafety([]);
      expect(level, equals(NivellSeguretat.incert));
    });

    test('returns incert when confidence is below 0.70', () {
      final level = service.evaluateSafety([
        const ClassificacioResult(
          boletId: 'boletus_edulis',
          displayName: 'Cep',
          confidence: 0.65,
        ),
      ]);
      expect(level, equals(NivellSeguretat.incert));
    });

    test('returns segur at exact confidence threshold boundary 0.70', () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'boletus_edulis',
            displayName: 'Cep',
            confidence: 0.70,
          ),
        ],
        edibility: Edibilitat.excellent,
      );
      expect(level, equals(NivellSeguretat.segur));
    });

    test('returns perill when identified mushroom is toxic', () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'omphalotus_olearius',
            displayName: 'Gírgola d\'olivera',
            confidence: 0.91,
          ),
        ],
        edibility: Edibilitat.toxic,
      );
      expect(level, equals(NivellSeguretat.perill));
    });

    test('returns perill when identified mushroom is mortal', () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'amanita_phalloides',
            displayName: 'Farinera borda',
            confidence: 0.96,
          ),
        ],
        edibility: Edibilitat.mortal,
      );
      expect(level, equals(NivellSeguretat.perill));
    });

    test(
        'returns perill when identified mushroom is mortal even at low confidence',
        () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'amanita_phalloides',
            displayName: 'Farinera borda',
            confidence: 0.45,
          ),
        ],
        edibility: Edibilitat.mortal,
      );
      expect(level, equals(NivellSeguretat.perill));
    });

    test(
        'returns perill when identified mushroom is toxic even at low confidence',
        () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'omphalotus_olearius',
            displayName: 'Gírgola d\'olivera',
            confidence: 0.55,
          ),
        ],
        edibility: Edibilitat.toxic,
      );
      expect(level, equals(NivellSeguretat.perill));
    });

    test(
        'returns incert when confidence is high but edibility is null (fail-closed)',
        () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'boletus_edulis',
            displayName: 'Cep',
            confidence: 0.95,
          ),
        ],
        edibility: null,
      );
      expect(level, equals(NivellSeguretat.incert));
    });

    test(
        'returns confusioPossible when high confidence but species has toxic lookalike',
        () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'lactarius_deliciosus',
            displayName: 'Rovelló',
            confidence: 0.92,
          ),
        ],
        edibility: Edibilitat.excellent,
      );
      expect(level, equals(NivellSeguretat.confusioPossible));
    });

    test('returns segur when high confidence and no toxic lookalikes', () {
      final level = service.evaluateSafety(
        [
          const ClassificacioResult(
            boletId: 'boletus_edulis',
            displayName: 'Cep',
            confidence: 0.95,
          ),
        ],
        edibility: Edibilitat.excellent,
      );
      expect(level, equals(NivellSeguretat.segur));
    });

    group('Zero-Tolerance Lethal Gate', () {
      test(
          'escalates to perill when any top-3 candidate is a lethal taxon with confidence >= 0.10',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'boletus_edulis',
              displayName: 'Cep',
              confidence: 0.76,
            ),
            const ClassificacioResult(
              boletId: 'amanita_phalloides',
              displayName: 'Farinera borda',
              confidence: 0.12,
            ),
          ],
          edibility: Edibilitat.excellent,
          candidatesEdibility: {
            'boletus_edulis': Edibilitat.excellent,
            'amanita_phalloides': Edibilitat.mortal,
          },
        );
        expect(level, equals(NivellSeguretat.perill));
      });

      test(
          'escalates to perill even if top candidate confidence is overwhelming (>= 0.88)',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'boletus_edulis',
              displayName: 'Cep',
              confidence: 0.89,
            ),
            const ClassificacioResult(
              boletId: 'amanita_virosa',
              displayName: 'Farinera pudent',
              confidence: 0.11,
            ),
          ],
          edibility: Edibilitat.excellent,
          candidatesEdibility: {
            'boletus_edulis': Edibilitat.excellent,
            'amanita_virosa': Edibilitat.mortal,
          },
        );
        // Lethal risk cannot be bypassed by overwhelming edible confidence
        expect(level, equals(NivellSeguretat.perill));
      });

      test(
          'does NOT trigger lethal gate if lethal candidate confidence is below 0.10 (noise threshold)',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'boletus_edulis',
              displayName: 'Cep',
              confidence: 0.85,
            ),
            const ClassificacioResult(
              boletId: 'amanita_phalloides',
              displayName: 'Farinera borda',
              confidence: 0.08,
            ),
          ],
          edibility: Edibilitat.excellent,
          candidatesEdibility: {
            'boletus_edulis': Edibilitat.excellent,
            'amanita_phalloides': Edibilitat.mortal,
          },
        );
        expect(level, equals(NivellSeguretat.segur));
      });

      test('findLethalCandidate correctly identifies lethal taxa', () {
        final candidates = [
          const ClassificacioResult(
            boletId: 'marasmius_oreades',
            displayName: 'Carrereta',
            confidence: 0.82,
          ),
          const ClassificacioResult(
            boletId: 'galerina_marginata',
            displayName: 'Galerina mortal',
            confidence: 0.14,
          ),
        ];

        final match = service.findLethalCandidate(candidates);
        expect(match, isNotNull);
        expect(match!.boletId, equals('galerina_marginata'));
      });

      test('findLethalCandidate returns null when below threshold', () {
        final candidates = [
          const ClassificacioResult(
            boletId: 'marasmius_oreades',
            displayName: 'Carrereta',
            confidence: 0.93,
          ),
          const ClassificacioResult(
            boletId: 'galerina_marginata',
            displayName: 'Galerina mortal',
            confidence: 0.06,
          ),
        ];

        final match = service.findLethalCandidate(candidates);
        expect(match, isNull);
      });
    });

    group('Top-N Multi-Candidate Toxicity Gate (Non-Lethal Toxic)', () {
      test(
          'escalates to confusioPossible when candidate 2 is toxic with confidence >= 0.15',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'calocybe_gambosa',
              displayName: 'Moixernó',
              confidence: 0.74,
            ),
            const ClassificacioResult(
              boletId: 'entoloma_sinuatum',
              displayName: 'Pèrfid',
              confidence: 0.19,
            ),
          ],
          edibility: Edibilitat.comestible,
          candidatesEdibility: {
            'calocybe_gambosa': Edibilitat.comestible,
            'entoloma_sinuatum': Edibilitat.toxic,
          },
        );
        expect(level, equals(NivellSeguretat.confusioPossible));
      });

      test(
          'does NOT escalate if candidate 2 toxic confidence is below 0.15 (noise threshold)',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'calocybe_gambosa',
              displayName: 'Moixernó',
              confidence: 0.75,
            ),
            const ClassificacioResult(
              boletId: 'entoloma_sinuatum',
              displayName: 'Pèrfid',
              confidence: 0.10,
            ),
          ],
          edibility: Edibilitat.comestible,
          candidatesEdibility: {
            'calocybe_gambosa': Edibilitat.comestible,
            'entoloma_sinuatum': Edibilitat.toxic,
          },
        );
        expect(level, equals(NivellSeguretat.segur));
      });

      test(
          'does NOT escalate if top candidate confidence is overwhelming (>= 0.88) for non-lethal toxic candidate',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'calocybe_gambosa',
              displayName: 'Moixernó',
              confidence: 0.90,
            ),
            const ClassificacioResult(
              boletId: 'entoloma_sinuatum',
              displayName: 'Pèrfid',
              confidence: 0.18,
            ),
          ],
          edibility: Edibilitat.comestible,
          candidatesEdibility: {
            'calocybe_gambosa': Edibilitat.comestible,
            'entoloma_sinuatum': Edibilitat.toxic,
          },
        );
        expect(level, equals(NivellSeguretat.segur));
      });

      test('returns segur when candidate 2 is edible with confidence >= 0.15',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'boletus_edulis',
              displayName: 'Cep',
              confidence: 0.75,
            ),
            const ClassificacioResult(
              boletId: 'cantharellus_cibarius',
              displayName: 'Rossinyol',
              confidence: 0.22,
            ),
          ],
          edibility: Edibilitat.excellent,
          candidatesEdibility: {
            'boletus_edulis': Edibilitat.excellent,
            'cantharellus_cibarius': Edibilitat.excellent,
          },
        );
        expect(level, equals(NivellSeguretat.segur));
      });
    });

    group('Lethal Taxa Synchronization & Detection', () {
      test('SafetyGateService.lethalSpecies matches all seed_data mortal taxa',
          () {
        final seededMortalIds = SeedData.bolets
            .where((b) => b.edibility.value == 'mortal')
            .map((b) => b.id.value)
            .toSet();

        expect(SafetyGateService.lethalSpecies, equals(seededMortalIds));
        expect(
            SafetyGateService.lethalSpecies, contains('gyromitra_esculenta'));
        expect(SafetyGateService.lethalSpecies.length, equals(6));
      });

      test(
          'findLethalCandidate detects gyromitra_esculenta at >= 10% confidence',
          () {
        final candidate = service.findLethalCandidate([
          const ClassificacioResult(
            boletId: 'morchella_esculenta',
            displayName: 'Múrgola',
            confidence: 0.85,
          ),
          const ClassificacioResult(
            boletId: 'gyromitra_esculenta',
            displayName: 'Bolet de greix',
            confidence: 0.12,
          ),
        ]);

        expect(candidate, isNotNull);
        expect(candidate!.boletId, equals('gyromitra_esculenta'));
      });

      test(
          'evaluateSafety escalates to perill when gyromitra is candidate 2 at 11%',
          () {
        final level = service.evaluateSafety(
          [
            const ClassificacioResult(
              boletId: 'morchella_esculenta',
              displayName: 'Múrgola',
              confidence: 0.86,
            ),
            const ClassificacioResult(
              boletId: 'gyromitra_esculenta',
              displayName: 'Bolet de greix',
              confidence: 0.11,
            ),
          ],
          edibility: Edibilitat.excellent,
        );

        expect(level, equals(NivellSeguretat.perill));
      });
    });
  });
}
