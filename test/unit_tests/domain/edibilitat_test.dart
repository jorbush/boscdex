import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/models/edibilitat.dart';
import 'package:boscdex/domain/models/raritat_tier.dart';

void main() {
  group('Edibilitat', () {
    test('provides correct Catalan labels', () {
      expect(Edibilitat.excellent.label, equals('Comestible excel·lent'));
      expect(Edibilitat.comestible.label, equals('Comestible'));
      expect(Edibilitat.senseValor.label, equals('Sense valor culinari'));
      expect(Edibilitat.toxic.label, equals('Tòxic'));
      expect(Edibilitat.mortal.label, equals('Mortal'));
    });

    test('isEdible returns true only for excellent and comestible', () {
      expect(Edibilitat.excellent.isEdible, isTrue);
      expect(Edibilitat.comestible.isEdible, isTrue);
      expect(Edibilitat.senseValor.isEdible, isFalse);
      expect(Edibilitat.toxic.isEdible, isFalse);
      expect(Edibilitat.mortal.isEdible, isFalse);
    });

    test('fromString parses various cases safely', () {
      expect(EdibilitatExtension.fromString('excellent'),
          equals(Edibilitat.excellent));
      expect(EdibilitatExtension.fromString('sense_valor'),
          equals(Edibilitat.senseValor));
      expect(EdibilitatExtension.fromString('senseValor'),
          equals(Edibilitat.senseValor));
      expect(EdibilitatExtension.fromString('toxic'), equals(Edibilitat.toxic));
      expect(
          EdibilitatExtension.fromString('mortal'), equals(Edibilitat.mortal));
      expect(EdibilitatExtension.fromString('desconegut'),
          equals(Edibilitat.senseValor));
    });

    test(
        'badgeBackgroundColor and badgeIconColor are fully opaque for all tiers',
        () {
      for (final edibility in Edibilitat.values) {
        expect(edibility.badgeBackgroundColor.alpha, equals(255),
            reason: '${edibility.name} badge background must be fully opaque');
        expect(edibility.badgeIconColor.alpha, equals(255),
            reason: '${edibility.name} badge icon must be fully opaque');
      }
    });

    test('badgeBackgroundColor has distinct light pastel tint per tier', () {
      expect(
          Edibilitat.excellent.badgeBackgroundColor.value, equals(0xFFE0EFE4));
      expect(
          Edibilitat.comestible.badgeBackgroundColor.value, equals(0xFFE5F4EA));
      expect(
          Edibilitat.senseValor.badgeBackgroundColor.value, equals(0xFFECEFEA));
      expect(Edibilitat.toxic.badgeBackgroundColor.value, equals(0xFFFDF0E4));
      expect(Edibilitat.mortal.badgeBackgroundColor.value, equals(0xFFFCE8E7));
    });
  });

  group('RaritatTier', () {
    test('provides 5 Pokédex-style tiers in Catalan', () {
      expect(RaritatTier.comu.label, equals('Comú'));
      expect(RaritatTier.pocFrequent.label, equals('Poc freqüent'));
      expect(RaritatTier.rar.label, equals('Rar'));
      expect(RaritatTier.moltRar.label, equals('Molt rar'));
      expect(RaritatTier.llegendari.label, equals('Llegendari'));
    });

    test('fromString parses snake_case and camelCase', () {
      expect(RaritatTierExtension.fromString('comu'), equals(RaritatTier.comu));
      expect(RaritatTierExtension.fromString('poc_frequent'),
          equals(RaritatTier.pocFrequent));
      expect(RaritatTierExtension.fromString('pocFrequent'),
          equals(RaritatTier.pocFrequent));
      expect(RaritatTierExtension.fromString('molt_rar'),
          equals(RaritatTier.moltRar));
      expect(RaritatTierExtension.fromString('llegendari'),
          equals(RaritatTier.llegendari));
      expect(
          RaritatTierExtension.fromString('other'), equals(RaritatTier.comu));
    });
  });
}
