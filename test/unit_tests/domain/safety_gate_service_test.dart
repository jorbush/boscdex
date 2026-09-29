import 'package:flutter_test/flutter_test.dart';
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
  });
}
