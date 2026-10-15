import 'package:boscdex/core/localization/species_localizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeciesLocalizer Unit Tests', () {
    test('Translates common mushroom names in ca, es, en', () {
      // Rovelló
      expect(
        SpeciesLocalizer.getMushroomName('lactarius_deliciosus',
            languageCode: 'ca'),
        equals('Rovelló / Pinetell'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('lactarius_deliciosus',
            languageCode: 'es'),
        equals('Níscalo / Robellón'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('lactarius_deliciosus',
            languageCode: 'en'),
        equals('Saffron Milk Cap'),
      );

      // Cep
      expect(
        SpeciesLocalizer.getMushroomName('boletus_edulis', languageCode: 'ca'),
        equals('Cep'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('boletus_edulis', languageCode: 'es'),
        equals('Boleto / Hongo calabaza'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('boletus_edulis', languageCode: 'en'),
        equals('Penny Bun / Porcini'),
      );

      // Farinera borda (Death cap)
      expect(
        SpeciesLocalizer.getMushroomName('amanita_phalloides',
            languageCode: 'ca'),
        equals('Farinera borda'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('amanita_phalloides',
            languageCode: 'es'),
        equals('Oronja verde / Cicuta verde'),
      );
      expect(
        SpeciesLocalizer.getMushroomName('amanita_phalloides',
            languageCode: 'en'),
        equals('Death Cap'),
      );
    });

    test('Translates common tree names in ca, es, en', () {
      // Pi roig
      expect(
        SpeciesLocalizer.getTreeName('pinus_sylvestris', languageCode: 'ca'),
        equals('Pi roig'),
      );
      expect(
        SpeciesLocalizer.getTreeName('pinus_sylvestris', languageCode: 'es'),
        equals('Pino silvestre / Pino albar'),
      );
      expect(
        SpeciesLocalizer.getTreeName('pinus_sylvestris', languageCode: 'en'),
        equals('Scots Pine'),
      );

      // Alzina
      expect(
        SpeciesLocalizer.getTreeName('quercus_ilex', languageCode: 'ca'),
        equals('Alzina'),
      );
      expect(
        SpeciesLocalizer.getTreeName('quercus_ilex', languageCode: 'es'),
        equals('Encina'),
      );
      expect(
        SpeciesLocalizer.getTreeName('quercus_ilex', languageCode: 'en'),
        equals('Holm Oak'),
      );
    });

    test('Falls back gracefully for unknown IDs or missing translations', () {
      expect(
        SpeciesLocalizer.getMushroomName('unknown_species',
            fallbackName: 'Bolet Desconegut'),
        equals('Bolet Desconegut'),
      );
      expect(
        SpeciesLocalizer.getTreeName('unknown_tree',
            fallbackName: 'Arbre Desconegut'),
        equals('Arbre Desconegut'),
      );
      expect(
        SpeciesLocalizer.getMushroomName(null, fallbackName: 'Default'),
        equals('Default'),
      );
    });

    test('Localizes morphology descriptions across ca, es, en', () {
      // Rovelló cap
      expect(
        SpeciesLocalizer.getCapDescription('lactarius_deliciosus',
            languageCode: 'ca'),
        contains('convex que s\'aplana'),
      );
      expect(
        SpeciesLocalizer.getCapDescription('lactarius_deliciosus',
            languageCode: 'es'),
        contains('convexo que se aplana'),
      );
      expect(
        SpeciesLocalizer.getCapDescription('lactarius_deliciosus',
            languageCode: 'en'),
        contains('convex flattening'),
      );

      // Rovelló latex
      expect(
        SpeciesLocalizer.getLatexDescription('lactarius_deliciosus',
            languageCode: 'ca'),
        contains('color pastanaga clar'),
      );
      expect(
        SpeciesLocalizer.getLatexDescription('lactarius_deliciosus',
            languageCode: 'es'),
        contains('color zanahoria claro'),
      );
      expect(
        SpeciesLocalizer.getLatexDescription('lactarius_deliciosus',
            languageCode: 'en'),
        contains('bright carrot-orange'),
      );
    });

    test('Localizes safety notes and lookalike comparisons across ca, es, en',
        () {
      // Farinera borda (Amanita phalloides) safety notes
      expect(
        SpeciesLocalizer.getSafetyNotes('amanita_phalloides',
            languageCode: 'ca'),
        contains('MORTAL. Conté amatoxines'),
      );
      expect(
        SpeciesLocalizer.getSafetyNotes('amanita_phalloides',
            languageCode: 'es'),
        contains('MORTAL. Contiene amatoxinas'),
      );
      expect(
        SpeciesLocalizer.getSafetyNotes('amanita_phalloides',
            languageCode: 'en'),
        contains('DEADLY. Contains lethal amatoxins'),
      );

      // Lookalike comparison Rovelló vs Amanita muscaria
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'lactarius_deliciosus',
          'amanita_muscaria',
          languageCode: 'ca',
        ),
        contains('barret vermell brillant'),
      );
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'lactarius_deliciosus',
          'amanita_muscaria',
          languageCode: 'es',
        ),
        contains('sombrero rojo brillante'),
      );
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'lactarius_deliciosus',
          'amanita_muscaria',
          languageCode: 'en',
        ),
        contains('bright red cap'),
      );

      // Bidirectional resolution: reverse order lookup yields identical note
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'amanita_muscaria',
          'lactarius_deliciosus',
          languageCode: 'ca',
        ),
        contains('barret vermell brillant'),
      );

      // Newly added lookalike: Xampinyó silvestre vs Cicuta blanca (Amanita verna)
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'agaricus_campestris',
          'amanita_verna',
          languageCode: 'ca',
        ),
        contains('Cicuta blanca'),
      );
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'amanita_verna',
          'agaricus_campestris',
          languageCode: 'en',
        ),
        contains('Spring Amanita'),
      );

      // Newly added lookalike: Cep negre vs Mataparent de Satanàs
      expect(
        SpeciesLocalizer.getComparisonNotes(
          'boletus_aereus',
          'rubroboletus_satanas',
          languageCode: 'ca',
        ),
        contains('Mataparent de Satanàs'),
      );
    });

    test('Localizes tree traits across ca, es, en', () {
      expect(
        SpeciesLocalizer.getTreeBark('pinus_sylvestris', languageCode: 'ca'),
        equals('Tronc superior ataronjat'),
      );
      expect(
        SpeciesLocalizer.getTreeBark('pinus_sylvestris', languageCode: 'es'),
        equals('Tronco superior anaranjado'),
      );
      expect(
        SpeciesLocalizer.getTreeBark('pinus_sylvestris', languageCode: 'en'),
        equals('Upper trunk orange-ochre'),
      );

      expect(
        SpeciesLocalizer.getTreeLeafType('quercus_ilex', languageCode: 'ca'),
        equals('Perenne'),
      );
      expect(
        SpeciesLocalizer.getTreeLeafType('quercus_ilex', languageCode: 'es'),
        equals('Perenne'),
      );
      expect(
        SpeciesLocalizer.getTreeLeafType('quercus_ilex', languageCode: 'en'),
        equals('Evergreen'),
      );

      expect(
        SpeciesLocalizer.getTreeSoil('pinus_halepensis', languageCode: 'ca'),
        equals('Calcari'),
      );
      expect(
        SpeciesLocalizer.getTreeSoil('pinus_halepensis', languageCode: 'es'),
        equals('Calcáreo'),
      );
      expect(
        SpeciesLocalizer.getTreeSoil('pinus_halepensis', languageCode: 'en'),
        equals('Calcareous / Limestone'),
      );
    });
  });
}
