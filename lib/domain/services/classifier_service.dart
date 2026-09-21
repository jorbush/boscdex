import 'dart:typed_data';
import '../models/classificacio_result.dart';

abstract class ClassifierService {
  Future<List<ClassificacioResult>> classify(Uint8List imageBytes);
  Future<List<ArbreClassificacioResult>> classifyTree(Uint8List imageBytes);
  Future<void> initialize();
  void dispose();
}

class MockClassifierService implements ClassifierService {
  int _scenarioIndex = 0;
  int _treeScenarioIndex = 0;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<List<ClassificacioResult>> classify(Uint8List imageBytes) async {
    // Simulate Edge-ML on-device inference latency (~300ms)
    await Future.delayed(const Duration(milliseconds: 350));

    final scenarios = [
      // 1. Rovelló (Lactarius deliciosus) - Common edible with lookalikes
      [
        const ClassificacioResult(
          boletId: 'lactarius_deliciosus',
          displayName: 'Rovelló / Pinetell',
          confidence: 0.91,
        ),
        const ClassificacioResult(
          boletId: 'lactarius_sanguifluus',
          displayName: 'Rovelló de sang',
          confidence: 0.52,
        ),
        const ClassificacioResult(
          boletId: 'suillus_luteus',
          displayName: 'Llenegot',
          confidence: 0.18,
        ),
      ],
      // 2. Ou de reig (Amanita caesarea) - High value with dangerous Amanita muscaria lookalike
      [
        const ClassificacioResult(
          boletId: 'amanita_caesarea',
          displayName: 'Ou de reig',
          confidence: 0.88,
        ),
        const ClassificacioResult(
          boletId: 'amanita_muscaria',
          displayName: 'Reig bord (Tòxic)',
          confidence: 0.44,
        ),
        const ClassificacioResult(
          boletId: 'cantharellus_cibarius',
          displayName: 'Rossinyol',
          confidence: 0.15,
        ),
      ],
      // 3. Rossinyol (Cantharellus cibarius) with Omphalotus olearius lookalike
      [
        const ClassificacioResult(
          boletId: 'cantharellus_cibarius',
          displayName: 'Rossinyol',
          confidence: 0.86,
        ),
        const ClassificacioResult(
          boletId: 'omphalotus_olearius',
          displayName: 'Gírgola d\'olivera (Tòxic)',
          confidence: 0.49,
        ),
        const ClassificacioResult(
          boletId: 'hydnum_repandum',
          displayName: 'Llengua de bou',
          confidence: 0.22,
        ),
      ],
      // 4. Low confidence scenario (< 0.70) - Triggers "No es pot identificar amb certesa"
      [
        const ClassificacioResult(
          boletId: 'tricholoma_terreum',
          displayName: 'Fredolic',
          confidence: 0.63,
        ),
        const ClassificacioResult(
          boletId: 'entoloma_sinuatum',
          displayName: 'Pèrfid (Tòxic)',
          confidence: 0.54,
        ),
        const ClassificacioResult(
          boletId: 'amanita_phalloides',
          displayName: 'Farinera borda (Mortal)',
          confidence: 0.38,
        ),
      ],
      // 5. Cep (Boletus edulis)
      [
        const ClassificacioResult(
          boletId: 'boletus_edulis',
          displayName: 'Cep',
          confidence: 0.94,
        ),
        const ClassificacioResult(
          boletId: 'suillus_luteus',
          displayName: 'Llenegot',
          confidence: 0.35,
        ),
        const ClassificacioResult(
          boletId: 'hydnum_repandum',
          displayName: 'Llengua de bou',
          confidence: 0.16,
        ),
      ],
    ];

    final result = scenarios[_scenarioIndex % scenarios.length];
    _scenarioIndex++;
    return result;
  }

  @override
  Future<List<ArbreClassificacioResult>> classifyTree(
      Uint8List imageBytes) async {
    // Simulate Edge-ML on-device inference latency (~300ms)
    await Future.delayed(const Duration(milliseconds: 350));

    final scenarios = [
      // 1. Pi roig (Pinus sylvestris)
      [
        const ArbreClassificacioResult(
          arbreId: 'pinus_sylvestris',
          displayName: 'Pi roig',
          confidence: 0.93,
        ),
        const ArbreClassificacioResult(
          arbreId: 'pinus_halepensis',
          displayName: 'Pi blanc',
          confidence: 0.45,
        ),
      ],
      // 2. Alzina (Quercus ilex)
      [
        const ArbreClassificacioResult(
          arbreId: 'quercus_ilex',
          displayName: 'Alzina',
          confidence: 0.91,
        ),
        const ArbreClassificacioResult(
          arbreId: 'castanea_sativa',
          displayName: 'Castanyer',
          confidence: 0.38,
        ),
      ],
      // 3. Faig (Fagus sylvatica)
      [
        const ArbreClassificacioResult(
          arbreId: 'fagus_sylvatica',
          displayName: 'Faig',
          confidence: 0.89,
        ),
        const ArbreClassificacioResult(
          arbreId: 'quercus_ilex',
          displayName: 'Alzina',
          confidence: 0.42,
        ),
      ],
      // 4. Pi blanc (Pinus halepensis)
      [
        const ArbreClassificacioResult(
          arbreId: 'pinus_halepensis',
          displayName: 'Pi blanc',
          confidence: 0.87,
        ),
        const ArbreClassificacioResult(
          arbreId: 'pinus_sylvestris',
          displayName: 'Pi roig',
          confidence: 0.51,
        ),
      ],
      // 5. Castanyer (Castanea sativa)
      [
        const ArbreClassificacioResult(
          arbreId: 'castanea_sativa',
          displayName: 'Castanyer',
          confidence: 0.92,
        ),
        const ArbreClassificacioResult(
          arbreId: 'fagus_sylvatica',
          displayName: 'Faig',
          confidence: 0.35,
        ),
      ],
    ];

    final result = scenarios[_treeScenarioIndex % scenarios.length];
    _treeScenarioIndex++;
    return result;
  }

  @override
  void dispose() {}
}
