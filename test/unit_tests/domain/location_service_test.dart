import 'package:boscdex/domain/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocationService locationService;

  setUp(() {
    locationService = LocationService();
  });

  test('LocationService returns true for isLocationServiceEnabled in tests',
      () async {
    final enabled = await locationService.isLocationServiceEnabled();
    expect(enabled, isTrue);
  });

  test('LocationService returns whileInUse permission in tests', () async {
    final permission = await locationService.checkPermission();
    expect(permission, LocationPermission.whileInUse);

    final requested = await locationService.requestPermission();
    expect(requested, LocationPermission.whileInUse);

    final hasPerm = await locationService.hasPermission();
    expect(hasPerm, isTrue);
  });

  test('LocationService returns setMockPosition when configured', () async {
    final mockPos = Position(
      latitude: 42.18,
      longitude: 1.85,
      timestamp: DateTime(2026, 10, 1),
      accuracy: 5.0,
      altitude: 850.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    locationService.setMockPosition(mockPos);

    final pos = await locationService.getCurrentPosition();
    expect(pos, isNotNull);
    expect(pos!.latitude, 42.18);
    expect(pos.longitude, 1.85);
    expect(pos.altitude, 850.0);
    expect(locationService.lastKnownPosition, equals(mockPos));
  });

  test('SightingLocation.fromPosition converts fields correctly', () {
    final position = Position(
      latitude: 41.78,
      longitude: 2.40,
      timestamp: DateTime(2026, 10, 1, 12, 0),
      accuracy: 8.0,
      altitude: 920.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    final loc = SightingLocation.fromPosition(position);
    expect(loc.latitude, 41.78);
    expect(loc.longitude, 2.40);
    expect(loc.altitude, 920.0);
    expect(loc.accuracy, 8.0);
  });
}
