import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/services/location_service.dart';

/// Provider for singleton [LocationService].
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// FutureProvider that checks if location permission is granted.
final hasLocationPermissionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.hasPermission();
});

/// FutureProvider that fetches the current location.
final currentLocationProvider =
    FutureProvider.autoDispose<Position?>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentPosition();
});
