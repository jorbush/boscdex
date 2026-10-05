import 'package:boscdex/domain/models/catalonia_zone.dart';
import 'package:boscdex/presentation/journal/journal_map_projection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JournalMapProjection', () {
    test('toNormalized returns null if latitude or longitude is null', () {
      expect(JournalMapProjection.toNormalized(null, 1.85), isNull);
      expect(JournalMapProjection.toNormalized(42.10, null), isNull);
      expect(JournalMapProjection.toNormalized(null, null), isNull);
    });

    test('projects Northern Catalonia (Val d\'Aran) correctly near top-left',
        () {
      // Vielha: lat 42.70, lon 0.80
      final offset = JournalMapProjection.toNormalized(42.70, 0.80);
      expect(offset, isNotNull);
      expect(offset!.dx, inInclusiveRange(0.15, 0.30));
      expect(offset.dy, inInclusiveRange(0.05, 0.18));
    });

    test('projects Central Pyrenees (Berga) in the central-northern sector',
        () {
      // Berga: lat 42.10, lon 1.85
      final offset = JournalMapProjection.toNormalized(42.10, 1.85);
      expect(offset, isNotNull);
      expect(offset!.dx, inInclusiveRange(0.45, 0.60));
      expect(offset.dy, inInclusiveRange(0.25, 0.40));
    });

    test(
        'projects Eastern Catalonia (Olot / Girona) in the north-eastern sector',
        () {
      // Olot: lat 42.18, lon 2.49
      final offset = JournalMapProjection.toNormalized(42.18, 2.49);
      expect(offset, isNotNull);
      expect(offset!.dx, inInclusiveRange(0.65, 0.80));
      expect(offset.dy, inInclusiveRange(0.20, 0.38));
    });

    test(
        'projects Southern Catalonia (Tortosa / Els Ports) in the south-western sector',
        () {
      // Tortosa: lat 40.81, lon 0.52
      final offset = JournalMapProjection.toNormalized(40.81, 0.52);
      expect(offset, isNotNull);
      expect(offset!.dx, inInclusiveRange(0.10, 0.25));
      expect(offset.dy, inInclusiveRange(0.70, 0.92));
    });

    test('clamps out-of-bounds coordinates to safe margin [0.04, 0.96]', () {
      final farNorthWest = JournalMapProjection.toNormalized(45.0, -2.0);
      expect(farNorthWest!.dx, 0.04);
      expect(farNorthWest.dy, 0.04);

      final farSouthEast = JournalMapProjection.toNormalized(38.0, 5.0);
      expect(farSouthEast!.dx, 0.96);
      expect(farSouthEast.dy, 0.96);
    });

    test('zoneCenter returns relativeBounds center', () {
      final center = JournalMapProjection.zoneCenter(CataloniaZone.altPirineu);
      expect(center.dx, closeTo(0.28, 0.01));
      expect(center.dy, closeTo(0.16, 0.01));
    });

    test('format coordinates displays proper hemisphere indicators', () {
      expect(JournalMapProjection.format(42.104, 1.852), '42.10° N, 1.85° E');
      expect(JournalMapProjection.format(-10.5, -5.2), '10.50° S, 5.20° O');
    });
  });
}
