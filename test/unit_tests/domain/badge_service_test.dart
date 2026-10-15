import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/models/insignia.dart';
import 'package:boscdex/domain/services/badge_service.dart';

void main() {
  group('BadgeService', () {
    late BadgeService service;

    setUp(() {
      service = BadgeService();
    });

    test('awards primer_pas_al_bosc on first discovery', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 1,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final primerPas = updated.firstWhere((b) => b.id == 'primer_pas_al_bosc');
      expect(primerPas.isAwarded, isTrue);
      expect(primerPas.progressCount, equals(1));
    });

    test('awards cacador_de_rovellons only when both rovellons are found',
        () async {
      const initialBadges = Insignia.registry;

      // Only one rovelló found
      var updated = await service.evaluateBadges(
        discoveryCount: 1,
        hasRovello: true,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      var cacador = updated.firstWhere((b) => b.id == 'cacador_de_rovellons');
      expect(cacador.isAwarded, isFalse);
      expect(cacador.progressCount, equals(1));

      // Both rovellons found
      updated = await service.evaluateBadges(
        discoveryCount: 2,
        hasRovello: true,
        hasPinetell: true,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      cacador = updated.firstWhere((b) => b.id == 'cacador_de_rovellons');
      expect(cacador.isAwarded, isTrue);
      expect(cacador.progressCount, equals(2));
    });

    test('awards micoleg_prudent after 5 toxic comparisons', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 0,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 5,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'micoleg_prudent');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(5));
    });

    test(
        'awards alianca_silvestre when user finds mushroom and visits host tree',
        () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 1,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: true,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'alianca_silvestre');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(1));
    });

    test('awards cistell_de_tardor at 15 discoveries', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 15,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'cistell_de_tardor');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(15));
    });

    test('awards mestre_boletaire at 20 discoveries', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 20,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'mestre_boletaire');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(20));
    });

    test('preserves awardedAt timestamp for already awarded badges', () async {
      final initialDate = DateTime(2026, 1, 15, 10, 0);
      final badgesWithAwarded = Insignia.registry.map((b) {
        if (b.id == 'primer_pas_al_bosc') {
          return Insignia(
            id: b.id,
            nom: b.nom,
            descripcio: b.descripcio,
            iconPath: b.iconPath,
            targetCount: b.targetCount,
            progressCount: 1,
            awardedAt: initialDate,
          );
        }
        return b;
      }).toList();

      final updated = await service.evaluateBadges(
        discoveryCount: 10,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: badgesWithAwarded,
      );

      final primerPas = updated.firstWhere((b) => b.id == 'primer_pas_al_bosc');
      expect(primerPas.isAwarded, isTrue);
      expect(primerPas.awardedAt, equals(initialDate));
    });

    test('clamps progressCount to targetCount when exceeded', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 25,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 10,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final micoleg = updated.firstWhere((b) => b.id == 'micoleg_prudent');
      expect(micoleg.progressCount, equals(5)); // Target is 5, views were 10
      expect(micoleg.isAwarded, isTrue);

      final cistell = updated.firstWhere((b) => b.id == 'cistell_de_tardor');
      expect(cistell.progressCount, equals(15)); // Target is 15, count was 25
      expect(cistell.isAwarded, isTrue);
    });

    test('awards senyor_dels_ceps when both ceps are discovered', () async {
      const initialBadges = Insignia.registry;

      var updated = await service.evaluateBadges(
        discoveryCount: 1,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        discoveredBoletIds: {'boletus_edulis'},
      );

      var badge = updated.firstWhere((b) => b.id == 'senyor_dels_ceps');
      expect(badge.isAwarded, isFalse);
      expect(badge.progressCount, equals(1));

      updated = await service.evaluateBadges(
        discoveryCount: 2,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        discoveredBoletIds: {'boletus_edulis', 'boletus_aereus'},
      );

      badge = updated.firstWhere((b) => b.id == 'senyor_dels_ceps');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(2));
    });

    test('awards gourmet_del_bosc when all 4 culinary stars are discovered',
        () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 4,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        discoveredBoletIds: {
          'boletus_edulis',
          'amanita_caesarea',
          'cantharellus_cibarius',
          'craterellus_cornucopioides',
        },
      );

      final badge = updated.firstWhere((b) => b.id == 'gourmet_del_bosc');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(4));
    });

    test('awards amic_dels_arbres when all 5 indicator trees are visited',
        () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 0,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        visitedTreeCount: 5,
      );

      final badge = updated.firstWhere((b) => b.id == 'amic_dels_arbres');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(5));
    });

    test(
        'awards esperit_de_primavera when all 3 spring mushrooms are discovered',
        () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 3,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        discoveredBoletIds: {
          'morchella_esculenta',
          'calocybe_gambosa',
          'marasmius_oreades',
        },
      );

      final badge = updated.firstWhere((b) => b.id == 'esperit_de_primavera');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(3));
    });

    test('awards sentinella_toxic after 15 toxic comparisons', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 0,
        toxicComparisonViewCount: 15,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'sentinella_toxic');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(15));
    });

    test('awards quadern_de_camp after 10 field sightings', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 0,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        sightingCount: 10,
      );

      final badge = updated.firstWhere((b) => b.id == 'quadern_de_camp');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(10));
    });

    test('awards cartograf_del_bosc after 5 GPS sightings', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 0,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
        gpsSightingCount: 5,
      );

      final badge = updated.firstWhere((b) => b.id == 'cartograf_del_bosc');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(5));
    });

    test('awards gran_enciclopedia when all 40 species are discovered',
        () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 40,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'gran_enciclopedia');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(40));
    });
  });
}
