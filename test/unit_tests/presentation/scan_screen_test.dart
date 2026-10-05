import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boscdex/presentation/scan/scan_screen.dart';
import 'package:boscdex/providers/classifier_provider.dart';
import 'package:boscdex/domain/services/classifier_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:boscdex/providers/preferences_provider.dart';
import 'package:drift/native.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/domain/models/classificacio_result.dart';

class _EmptyClassifierService extends MockClassifierService {
  @override
  Future<List<MushroomClassificationResult>> classifyMushroom(
      Uint8List imageBytes) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [];
  }

  @override
  Future<List<ClassificacioResult>> classify(Uint8List imageBytes) =>
      classifyMushroom(imageBytes);

  @override
  Future<List<TreeClassificationResult>> classifyTree(
      Uint8List imageBytes) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase testDb;
  late SharedPreferences prefs;

  setUp(() async {
    testDb = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({
      'disclaimerAccepted': true,
      'toxicComparisonViewCount': 0,
    });
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await testDb.close();
  });

  void setupMockChannels({
    required int permissionStatus,
    required Map<dynamic, dynamic> requestResult,
    List<Map<String, dynamic>> availableCameras = const [],
  }) {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'checkPermissionStatus') {
          return permissionStatus;
        }
        if (methodCall.method == 'requestPermissions') {
          return requestResult;
        }
        return null;
      },
    );

    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/camera'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'availableCameras') {
          return availableCameras;
        }
        return null;
      },
    );
  }

  void clearMockChannels() {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/camera'),
      null,
    );
  }

  group('ScanScreen Unit Tests', () {
    tearDown(() {
      clearMockChannels();
    });

    testWidgets(
        'renders mode switcher, controls, and handles fallback when no camera is detected',
        (WidgetTester tester) async {
      // Setup permission granted (1) but 0 cameras detected
      setupMockChannels(
        permissionStatus: 1, // granted
        requestResult: {1: 1},
        availableCameras: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            classifierProvider.overrideWithValue(MockClassifierService()),
          ],
          child: const MaterialApp(
            home: ScanScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check Mode Selector
      expect(find.text('Bolets'), findsOneWidget);
      expect(find.text('Arbres'), findsOneWidget);

      // Check GPS Badge
      expect(find.text('GPS'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);

      // Check Default Instructions for Bolets
      expect(find.text('Enfoca el barret i les làmines del bolet'),
          findsOneWidget);

      // Check Fallback View for no cameras
      expect(find.text('No s\'ha detectat cap càmera al dispositiu.'),
          findsOneWidget);
      expect(
          find.text(
              'Fes servir la Galeria o prem Disparador per provar la identificació.'),
          findsOneWidget);

      // Check Bottom Controls
      expect(find.byKey(const Key('shutter_button')), findsOneWidget);
      expect(find.byKey(const Key('gallery_picker_button')), findsOneWidget);

      // Tap 'Arbres' mode
      await tester.tap(find.text('Arbres'));
      await tester.pumpAndSettle();

      // Check Instructions updated for Arbres
      expect(find.text('Enfoca l\'escorça o les fulles de l\'arbre'),
          findsOneWidget);

      // Tap 'Bolets' mode back
      await tester.tap(find.text('Bolets'));
      await tester.pumpAndSettle();

      expect(find.text('Enfoca el barret i les làmines del bolet'),
          findsOneWidget);
    });

    testWidgets(
        'renders permission denied view when camera permission is denied',
        (WidgetTester tester) async {
      // Permission denied (0)
      setupMockChannels(
        permissionStatus: 0, // denied
        requestResult: {1: 0},
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            classifierProvider.overrideWithValue(MockClassifierService()),
          ],
          child: const MaterialApp(
            home: ScanScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Permís de càmera necessari'), findsOneWidget);
      expect(
        find.text(
            'Boscdex necessita la càmera per identificar bolets al bosc.'),
        findsOneWidget,
      );
      expect(find.text('Demanar permís'), findsOneWidget);
    });

    testWidgets(
        'renders open settings button when camera permission is permanently denied',
        (WidgetTester tester) async {
      // Permanently denied (4)
      setupMockChannels(
        permissionStatus: 4, // permanentlyDenied
        requestResult: {1: 4},
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            classifierProvider.overrideWithValue(MockClassifierService()),
          ],
          child: const MaterialApp(
            home: ScanScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Permís de càmera necessari'), findsOneWidget);
      expect(
        find.text(
            'Activa el permís des dels Paràmetres del teu iPhone per escanejar.'),
        findsOneWidget,
      );
      expect(find.text('Obrir Paràmetres'), findsOneWidget);
    });

    testWidgets('shutter tap triggers scan animation',
        (WidgetTester tester) async {
      setupMockChannels(
        permissionStatus: 1,
        requestResult: {1: 1},
        availableCameras: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDatabaseProvider.overrideWithValue(testDb),
            classifierProvider.overrideWithValue(_EmptyClassifierService()),
          ],
          child: const MaterialApp(
            home: ScanScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final shutter = find.byKey(const Key('shutter_button'));
      expect(shutter, findsOneWidget);

      await tester.tap(shutter);
      await tester.pump(); // Start scan animation

      // Verify scanning text appears during scan
      expect(find.text('ANALITZANT AMB EDGE-AI...'), findsOneWidget);

      // Advance past the 200ms mock latency
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 50));

      // Scan has finished cleanly, animation stopped
      expect(find.text('ANALITZANT AMB EDGE-AI...'), findsNothing);
    });

    testWidgets(
        'switching to Arbres mode and tapping shutter triggers scan animation',
        (WidgetTester tester) async {
      setupMockChannels(
        permissionStatus: 1,
        requestResult: {1: 1},
        availableCameras: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDatabaseProvider.overrideWithValue(testDb),
            classifierProvider.overrideWithValue(_EmptyClassifierService()),
          ],
          child: const MaterialApp(
            home: ScanScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap on 'Arbres' mode button
      final arbresTab = find.text('Arbres');
      expect(arbresTab, findsOneWidget);
      await tester.tap(arbresTab);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final shutter = find.byKey(const Key('shutter_button'));
      expect(shutter, findsOneWidget);

      await tester.tap(shutter);
      await tester.pump();

      // Verify scanning indicator appears
      expect(find.text('ANALITZANT AMB EDGE-AI...'), findsOneWidget);

      // Advance past the 200ms mock latency
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 50));

      // Scan has finished cleanly, animation stopped
      expect(find.text('ANALITZANT AMB EDGE-AI...'), findsNothing);
    });
  });
}
