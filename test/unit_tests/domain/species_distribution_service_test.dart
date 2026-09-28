import 'package:boscdex/domain/models/catalonia_zone.dart';
import 'package:boscdex/domain/services/species_distribution_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeciesDistributionService Unit Tests', () {
    test('Returns accurate zones for Rovelló (Lactarius deliciosus)', () {
      final zones =
          SpeciesDistributionService.getZonesForSpecies('lactarius_deliciosus');
      expect(zones, contains(CataloniaZone.altPirineu));
      expect(zones, contains(CataloniaZone.prepirineuCentral));
      expect(zones, contains(CataloniaZone.transversalMontseny));
      expect(zones, contains(CataloniaZone.litoralPrelitoral));
      expect(zones, contains(CataloniaZone.serraladaSudPrades));
      expect(zones, contains(CataloniaZone.portsTerresEbre));
      expect(zones.length, 6);
    });

    test('Returns mountain zones for Cep (Boletus edulis)', () {
      final zones =
          SpeciesDistributionService.getZonesForSpecies('boletus_edulis');
      expect(zones, contains(CataloniaZone.altPirineu));
      expect(zones, contains(CataloniaZone.prepirineuCentral));
      expect(zones, contains(CataloniaZone.transversalMontseny));
      // Cep does not grow in the dry Ponent plain
      expect(zones, isNot(contains(CataloniaZone.ponent)));
    });

    test('Returns Mediterranean warm zones for Ou de reig (Amanita caesarea)',
        () {
      final zones =
          SpeciesDistributionService.getZonesForSpecies('amanita_caesarea');
      expect(zones, contains(CataloniaZone.transversalMontseny));
      expect(zones, contains(CataloniaZone.litoralPrelitoral));
      expect(zones, contains(CataloniaZone.serraladaSudPrades));
      // Ou de reig is thermophilic, does not inhabit high alpine Pyrenees
      expect(zones, isNot(contains(CataloniaZone.altPirineu)));
    });

    test('Fallback to default foraging belt for unknown species', () {
      final zones =
          SpeciesDistributionService.getZonesForSpecies('unknown_fungus');
      expect(zones, isNotEmpty);
      expect(zones, contains(CataloniaZone.prepirineuCentral));
      expect(zones, contains(CataloniaZone.transversalMontseny));
    });

    test('CataloniaZone enum labels, bounds, and comarques are non-empty', () {
      for (final zone in CataloniaZone.values) {
        expect(zone.id, isNotEmpty);
        expect(zone.label, isNotEmpty);
        expect(zone.shortLabel, isNotEmpty);
        expect(zone.comarques, isNotEmpty);
        expect(zone.habitatDescription, isNotEmpty);
        expect(zone.relativeBounds.width, greaterThan(0.1));
        expect(zone.relativeBounds.height, greaterThan(0.1));
      }
    });
  });
}
