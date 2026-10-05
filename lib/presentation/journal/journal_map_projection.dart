import 'dart:ui';
import '../../domain/models/catalonia_zone.dart';

/// Utilities for projecting geographic GPS coordinates (latitude, longitude)
/// to normalized (x, y) coordinates [0.0, 1.0] onto the 4:3 pixel art map of Catalonia.
class JournalMapProjection {
  JournalMapProjection._();

  // Geographic boundaries of Catalonia represented in the 4:3 pixel map canvas
  static const double minLongitude = 0.05; // Western border (Aragó / Franja)
  static const double maxLongitude = 3.45; // Eastern border (Cap de Creus)
  static const double minLatitude =
      40.40; // Southern border (Alcanar / Terres de l'Ebre)
  static const double maxLatitude =
      42.95; // Northern border (Val d'Aran / Alt Pirineu)

  /// Converts GPS coordinates to normalized [0.0, 1.0] coordinates on the map.
  /// Returns null if either latitude or longitude is null.
  static Offset? toNormalized(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return null;

    final x = (longitude - minLongitude) / (maxLongitude - minLongitude);
    final y = (maxLatitude - latitude) / (maxLatitude - minLatitude);

    // Clamp with small padding so markers never clip outside the map canvas
    return Offset(
      x.clamp(0.04, 0.96),
      y.clamp(0.04, 0.96),
    );
  }

  /// Returns the normalized center coordinate of a given [CataloniaZone].
  static Offset zoneCenter(CataloniaZone zone) {
    final bounds = zone.relativeBounds;
    return bounds.center;
  }

  /// Formats GPS coordinates in a human-friendly string (e.g. "42.18° N, 1.85° E").
  static String format(double latitude, double longitude) {
    final latDir = latitude >= 0 ? 'N' : 'S';
    final lonDir = longitude >= 0 ? 'E' : 'O';
    return '${latitude.abs().toStringAsFixed(2)}° $latDir, ${longitude.abs().toStringAsFixed(2)}° $lonDir';
  }
}
