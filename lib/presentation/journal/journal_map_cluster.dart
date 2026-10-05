import 'dart:ui';
import '../../data/database/app_database.dart';
import 'journal_map_projection.dart';

/// Represents a clustered group of one or more field sightings at the same or nearby location
/// on the 4:3 pixel art map of Catalonia.
class SightingCluster {
  final String id;
  final double latitude;
  final double longitude;
  final Offset normalizedPosition;
  final List<Avistament> sightings;

  const SightingCluster({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.normalizedPosition,
    required this.sightings,
  });

  /// True if more than one specimen is located in this cluster.
  bool get isCluster => sightings.length > 1;

  /// Total count of specimens in this cluster.
  int get count => sightings.length;
}

/// Spatial clustering engine for grouping co-located sightings on the field map.
class JournalMapClustering {
  JournalMapClustering._();

  /// Default spatial clustering threshold in normalized coordinates [0.0, 1.0].
  /// 0.018 corresponds to approximately 15-20 logical pixels on a standard mobile display,
  /// preventing map pins (44px wide) from directly occluding one another.
  static const double defaultThreshold = 0.018;

  /// Groups [sightings] with valid GPS coordinates into [SightingCluster]s.
  ///
  /// Sightings that share identical coordinates or are within [threshold] distance
  /// in normalized coordinates are grouped into the same cluster.
  static List<SightingCluster> cluster(
    List<Avistament> sightings, {
    double threshold = defaultThreshold,
  }) {
    final validSightings = sightings
        .where((s) => s.latitude != null && s.longitude != null)
        .toList();

    if (validSightings.isEmpty) return const [];

    final thresholdSquared = threshold * threshold;
    final List<List<Avistament>> groups = [];
    final List<Offset> groupPositions = [];

    for (final sighting in validSightings) {
      final norm = JournalMapProjection.toNormalized(
        sighting.latitude,
        sighting.longitude,
      );
      if (norm == null) continue;

      int matchedIndex = -1;
      for (int i = 0; i < groupPositions.length; i++) {
        final pos = groupPositions[i];
        final dx = norm.dx - pos.dx;
        final dy = norm.dy - pos.dy;
        final distSq = (dx * dx) + (dy * dy);
        if (distSq <= thresholdSquared) {
          matchedIndex = i;
          break;
        }
      }

      if (matchedIndex != -1) {
        groups[matchedIndex].add(sighting);
      } else {
        groups.add([sighting]);
        groupPositions.add(norm);
      }
    }

    final List<SightingCluster> clusters = [];
    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      final first = group.first;
      final pos = groupPositions[i];

      clusters.add(SightingCluster(
        id: 'cluster_${first.id}',
        latitude: first.latitude!,
        longitude: first.longitude!,
        normalizedPosition: pos,
        sightings: group,
      ));
    }

    return clusters;
  }
}
