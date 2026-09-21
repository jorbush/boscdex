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

    test('awards mestre_boletaire at 50 discoveries', () async {
      const initialBadges = Insignia.registry;

      final updated = await service.evaluateBadges(
        discoveryCount: 50,
        hasRovello: false,
        hasPinetell: false,
        toxicComparisonViewCount: 0,
        hasTreeAlliance: false,
        currentBadges: initialBadges,
      );

      final badge = updated.firstWhere((b) => b.id == 'mestre_boletaire');
      expect(badge.isAwarded, isTrue);
      expect(badge.progressCount, equals(50));
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
  });
}
