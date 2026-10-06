import 'package:boscdex/domain/models/catalonia_zone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CataloniaZone Localization & Properties Unit Tests', () {
    test('All 7 Catalonia zones have unique non-empty IDs', () {
      final ids = <String>{};
      for (final zone in CataloniaZone.values) {
        expect(zone.id, isNotEmpty);
        expect(ids.add(zone.id), isTrue,
            reason: 'Duplicate zone id: ${zone.id}');
      }
      expect(ids.length, equals(7));
    });

    test('getLabel returns localized names for all 7 zones in ca, es, en', () {
      // 1. altPirineu
      expect(CataloniaZone.altPirineu.getLabel('ca'),
          equals('Alt Pirineu i Aran'));
      expect(CataloniaZone.altPirineu.getLabel('es'),
          equals('Alto Pirineo y Arán'));
      expect(CataloniaZone.altPirineu.getLabel('en'),
          equals('High Pyrenees & Aran'));

      // 2. prepirineuCentral
      expect(CataloniaZone.prepirineuCentral.getLabel('ca'),
          equals('Prepirineu i Cat. Central'));
      expect(CataloniaZone.prepirineuCentral.getLabel('es'),
          equals('Prepirineo y Cat. Central'));
      expect(CataloniaZone.prepirineuCentral.getLabel('en'),
          equals('Pre-Pyrenees & Central Cat.'));

      // 3. transversalMontseny
      expect(CataloniaZone.transversalMontseny.getLabel('ca'),
          equals('Serralada Transversal i Montseny'));
      expect(CataloniaZone.transversalMontseny.getLabel('es'),
          equals('Cordillera Transversal y Montseny'));
      expect(CataloniaZone.transversalMontseny.getLabel('en'),
          equals('Transversal Range & Montseny'));

      // 4. litoralPrelitoral
      expect(CataloniaZone.litoralPrelitoral.getLabel('ca'),
          equals('Litoral i Prelitoral'));
      expect(CataloniaZone.litoralPrelitoral.getLabel('es'),
          equals('Litoral y Prelitoral'));
      expect(CataloniaZone.litoralPrelitoral.getLabel('en'),
          equals('Coastal & Pre-coastal'));

      // 5. ponent
      expect(CataloniaZone.ponent.getLabel('ca'), equals('Plana de Ponent'));
      expect(
          CataloniaZone.ponent.getLabel('es'), equals('Llanura de Poniente'));
      expect(CataloniaZone.ponent.getLabel('en'),
          equals('Western Plain (Ponent)'));

      // 6. serraladaSudPrades
      expect(CataloniaZone.serraladaSudPrades.getLabel('ca'),
          equals('Muntanyes de Prades i Tarragona'));
      expect(CataloniaZone.serraladaSudPrades.getLabel('es'),
          equals('Montañas de Prades y Tarragona'));
      expect(CataloniaZone.serraladaSudPrades.getLabel('en'),
          equals('Prades Mountains & Tarragona'));

      // 7. portsTerresEbre
      expect(CataloniaZone.portsTerresEbre.getLabel('ca'),
          equals('Terres de l\'Ebre i Els Ports'));
      expect(CataloniaZone.portsTerresEbre.getLabel('es'),
          equals('Tierras del Ebro y Los Puertos'));
      expect(CataloniaZone.portsTerresEbre.getLabel('en'),
          equals('Ebre Lands & Els Ports'));
    });

    test(
        'getShortLabel returns localized abbreviations for all 7 zones in ca, es, en',
        () {
      expect(
          CataloniaZone.altPirineu.getShortLabel('ca'), equals('Alt Pirineu'));
      expect(
          CataloniaZone.altPirineu.getShortLabel('es'), equals('Alto Pirineo'));
      expect(CataloniaZone.altPirineu.getShortLabel('en'),
          equals('High Pyrenees'));

      expect(CataloniaZone.prepirineuCentral.getShortLabel('ca'),
          equals('Prepirineu / Central'));
      expect(CataloniaZone.prepirineuCentral.getShortLabel('es'),
          equals('Prepirineo / Central'));
      expect(CataloniaZone.prepirineuCentral.getShortLabel('en'),
          equals('Pre-Pyrenees / Central'));

      expect(CataloniaZone.transversalMontseny.getShortLabel('ca'),
          equals('Girona / Montseny'));
      expect(CataloniaZone.transversalMontseny.getShortLabel('es'),
          equals('Girona / Montseny'));
      expect(CataloniaZone.transversalMontseny.getShortLabel('en'),
          equals('Girona / Montseny'));

      expect(CataloniaZone.litoralPrelitoral.getShortLabel('ca'),
          equals('Litoral / Prelitoral'));
      expect(CataloniaZone.litoralPrelitoral.getShortLabel('es'),
          equals('Litoral / Prelitoral'));
      expect(CataloniaZone.litoralPrelitoral.getShortLabel('en'),
          equals('Coastal / Pre-coastal'));

      expect(CataloniaZone.ponent.getShortLabel('ca'), equals('Ponent'));
      expect(CataloniaZone.ponent.getShortLabel('es'), equals('Poniente'));
      expect(CataloniaZone.ponent.getShortLabel('en'), equals('Ponent'));

      expect(CataloniaZone.serraladaSudPrades.getShortLabel('ca'),
          equals('Prades / Camp'));
      expect(CataloniaZone.serraladaSudPrades.getShortLabel('es'),
          equals('Prades / Camp'));
      expect(CataloniaZone.serraladaSudPrades.getShortLabel('en'),
          equals('Prades / Camp'));

      expect(CataloniaZone.portsTerresEbre.getShortLabel('ca'),
          equals('Els Ports / Ebre'));
      expect(CataloniaZone.portsTerresEbre.getShortLabel('es'),
          equals('Los Puertos / Ebro'));
      expect(CataloniaZone.portsTerresEbre.getShortLabel('en'),
          equals('Els Ports / Ebre'));
    });

    test(
        'getHabitatDescription returns non-empty localized text for all 7 zones in ca, es, en',
        () {
      for (final zone in CataloniaZone.values) {
        final caDesc = zone.getHabitatDescription('ca');
        final esDesc = zone.getHabitatDescription('es');
        final enDesc = zone.getHabitatDescription('en');

        expect(caDesc, isNotEmpty,
            reason: '${zone.id} ca description is empty');
        expect(esDesc, isNotEmpty,
            reason: '${zone.id} es description is empty');
        expect(enDesc, isNotEmpty,
            reason: '${zone.id} en description is empty');

        // Check language specific terms
        expect(caDesc, isNot(equals(enDesc)));
      }
    });

    test(
        'getLabel and getShortLabel fall back gracefully to Catalan on unknown languageCode',
        () {
      expect(CataloniaZone.altPirineu.getLabel('de'),
          equals(CataloniaZone.altPirineu.getLabel('ca')));
      expect(CataloniaZone.altPirineu.getShortLabel('fr'),
          equals(CataloniaZone.altPirineu.getShortLabel('ca')));
      expect(CataloniaZone.altPirineu.getHabitatDescription('it'),
          equals(CataloniaZone.altPirineu.getHabitatDescription('ca')));
    });

    test(
        'Default getters (label, shortLabel, habitatDescription) match Catalan',
        () {
      for (final zone in CataloniaZone.values) {
        expect(zone.label, equals(zone.getLabel('ca')));
        expect(zone.shortLabel, equals(zone.getShortLabel('ca')));
        expect(
            zone.habitatDescription, equals(zone.getHabitatDescription('ca')));
      }
    });
  });
}
