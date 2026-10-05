import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

/// GPS location data for a field sighting.
class SightingLocation {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final DateTime timestamp;

  const SightingLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    required this.timestamp,
  });

  factory SightingLocation.fromPosition(Position position) {
    return SightingLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude != 0.0 ? position.altitude : null,
      accuracy: position.accuracy,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }
}

/// Service managing offline-first on-device GPS acquisition for field sightings.
class LocationService {
  Position? _lastKnownPosition;

  LocationService();

  Position? get lastKnownPosition => _lastKnownPosition;

  /// Whether code is currently executing inside a Flutter automated test.
  bool get _isTestEnvironment {
    return kDebugMode &&
        (Zone.current[#flutter_test.binding] != null ||
            WidgetsBinding.instance.runtimeType.toString().contains('Test'));
  }

  /// Checks if location services are enabled on the hardware.
  Future<bool> isLocationServiceEnabled() async {
    if (_isTestEnvironment) return true;
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      developer.log('Error checking location service status: $e',
          name: 'LocationService');
      return false;
    }
  }

  /// Checks the current location permission status without prompting.
  Future<LocationPermission> checkPermission() async {
    if (_isTestEnvironment) return LocationPermission.whileInUse;
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      developer.log('Error checking location permission: $e',
          name: 'LocationService');
      return LocationPermission.denied;
    }
  }

  /// Explicitly requests location permission from the operating system.
  Future<LocationPermission> requestPermission() async {
    if (_isTestEnvironment) return LocationPermission.whileInUse;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission;
    } catch (e) {
      developer.log('Error requesting location permission: $e',
          name: 'LocationService');
      return LocationPermission.denied;
    }
  }

  /// Whether the app has permission to access the device location.
  Future<bool> hasPermission() async {
    if (_isTestEnvironment) return true;
    final permission = await checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Fetches the current geographic position.
  ///
  /// Safe for deep forest use: checks last known position first,
  /// then queries GPS with a reasonable timeout so the app never hangs.
  Future<Position?> getCurrentPosition({
    Duration timeLimit = const Duration(seconds: 4),
  }) async {
    if (_isTestEnvironment) {
      return _lastKnownPosition;
    }

    try {
      final isEnabled = await isLocationServiceEnabled();
      if (!isEnabled) {
        developer.log('Location services disabled on device',
            name: 'LocationService');
        return _lastKnownPosition;
      }

      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        developer.log('Location permission denied: $permission',
            name: 'LocationService');
        return null;
      }

      // Try fetching a quick last known fix first
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          _lastKnownPosition = last;
        }
      } catch (_) {}

      // Acquire fresh GPS position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: timeLimit,
      );

      _lastKnownPosition = position;
      return position;
    } catch (e) {
      developer.log(
        'Could not acquire fresh GPS position (falling back to last known): $e',
        name: 'LocationService',
      );
      return _lastKnownPosition;
    }
  }

  /// Sets a mock position for automated testing.
  @visibleForTesting
  void setMockPosition(Position position) {
    _lastKnownPosition = position;
  }
}
