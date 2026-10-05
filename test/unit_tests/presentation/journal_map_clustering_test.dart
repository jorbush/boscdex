import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/journal/journal_map_cluster.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JournalMapClustering Unit Tests', () {
    test('Empty sightings list returns empty clusters', () {
      final clusters = JournalMapClustering.cluster([]);
      expect(clusters, isEmpty);
    });

    test('Filters out sightings without GPS coordinates', () {
      final sightings = [
        Avistament(
          id: 'no-gps-1',
          boletId: 'boletus_edulis',
          timestamp: DateTime(2026, 10, 1),
        ),
        Avistament(
          id: 'no-gps-2',
          arbreId: 'pinus_sylvestris',
          timestamp: DateTime(2026, 10, 1),
        ),
      ];

      final clusters = JournalMapClustering.cluster(sightings);
      expect(clusters, isEmpty);
    });

    test(
        'Groups multiple sightings with identical coordinates into single cluster',
        () {
      final sightings = [
        Avistament(
          id: 's1',
          boletId: 'lactarius_deliciosus',
          timestamp: DateTime(2026, 10, 1, 10, 0),
          latitude: 42.18,
          longitude: 1.85,
        ),
        Avistament(
          id: 's2',
          arbreId: 'pinus_sylvestris',
          timestamp: DateTime(2026, 10, 1, 10, 5),
          latitude: 42.18,
          longitude: 1.85,
        ),
        Avistament(
          id: 's3',
          boletId: 'tricholoma_terreum',
          timestamp: DateTime(2026, 10, 1, 10, 10),
          latitude: 42.18,
          longitude: 1.85,
        ),
      ];

      final clusters = JournalMapClustering.cluster(sightings);
      expect(clusters.length, equals(1));
      final cluster = clusters.first;
      expect(cluster.isCluster, isTrue);
      expect(cluster.count, equals(3));
      expect(
          cluster.sightings.map((s) => s.id), containsAll(['s1', 's2', 's3']));
      expect(cluster.latitude, equals(42.18));
      expect(cluster.longitude, equals(1.85));
    });

    test('Groups nearby sightings within spatial threshold', () {
      final s1 = Avistament(
        id: 's1',
        boletId: 'lactarius_deliciosus',
        timestamp: DateTime(2026, 10, 1),
        latitude: 42.1800,
        longitude: 1.8500,
      );
      // Very close coordinate (~50 meters away)
      final s2 = Avistament(
        id: 's2',
        boletId: 'boletus_edulis',
        timestamp: DateTime(2026, 10, 1),
        latitude: 42.1805,
        longitude: 1.8505,
      );

      final clusters = JournalMapClustering.cluster([s1, s2]);
      expect(clusters.length, equals(1));
      expect(clusters.first.count, equals(2));
      expect(clusters.first.isCluster, isTrue);
    });

    test('Separates distant sightings across Catalonia into distinct clusters',
        () {
      // Berguedà
      final sBergueda = Avistament(
        id: 's-bergueda',
        boletId: 'lactarius_deliciosus',
        timestamp: DateTime(2026, 10, 1),
        latitude: 42.18,
        longitude: 1.85,
      );
      // Montseny
      final sMontseny = Avistament(
        id: 's-montseny',
        arbreId: 'fagus_sylvatica',
        timestamp: DateTime(2026, 10, 1),
        latitude: 41.78,
        longitude: 2.40,
      );
      // Terres de l'Ebre / Els Ports
      final sPorts = Avistament(
        id: 's-ports',
        boletId: 'cantharellus_cibarius',
        timestamp: DateTime(2026, 10, 1),
        latitude: 40.82,
        longitude: 0.35,
      );

      final clusters =
          JournalMapClustering.cluster([sBergueda, sMontseny, sPorts]);
      expect(clusters.length, equals(3));
      for (final cluster in clusters) {
        expect(cluster.count, equals(1));
        expect(cluster.isCluster, isFalse);
      }
    });
  });
}
