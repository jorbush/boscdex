import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';

import 'package:flutter/services.dart';
import 'package:boscdex/app.dart';
import 'package:boscdex/core/constants/app_constants.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/providers/classifier_provider.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Boscdex Full E2E User Journey', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': false,
        'toxicComparisonViewCount': 0,
      });

      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'checkPermissionStatus') {
            return 1; // PermissionStatus.granted
          }
          if (methodCall.method == 'requestPermissions') {
            return {1: 1}; // camera: granted
          }
          return null;
        },
      );

      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/camera'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'availableCameras') {
            return <Map<String, dynamic>>[];
          }
          return null;
        },
      );
    });

    tearDown(() async {
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
    });

    testWidgets(
        'First launch disclaimer -> Scan specimen -> Register -> Boscdex unlock -> Card navigation -> Journal sighting',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDatabaseProvider.overrideWithValue(testDb),
            classifierProvider.overrideWithValue(MockClassifierService()),
          ],
          child: const BoscdexApp(),
        ),
      );

      // 1. Initial splash screen
      expect(find.text('Boscdex'), findsOneWidget);

      // Advance splash timer (1500ms)
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();

      // 2. User lands on Disclaimer Screen (first launch)
      expect(find.text('Avís Legal Important'), findsOneWidget);
      expect(find.text('Començar a explorar'), findsOneWidget);

      // Verify button is initially disabled
      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNull);

      // Check the acceptance checkbox
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Button is now enabled -> tap to enter the app
      final startButtonFinder = find.text('Començar a explorar');
      await tester.tap(startButtonFinder);
      await tester.pumpAndSettle();

      // 3. User lands on Boscdex Album tab
      expect(find.text('Boscdex'), findsWidgets);
      expect(find.text('0/${AppConstants.catalogSpeciesCount} descoberts'),
          findsOneWidget);

      // 3b. User inspects an undiscovered bolet to check its habitat & location
      final undiscoveredCardFinder = find.text('#001 ???');
      expect(undiscoveredCardFinder, findsOneWidget);
      await tester.tap(undiscoveredCardFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify veiled identity and visible habitat
      expect(find.text('#001 ???'), findsOneWidget);
      expect(find.text('Espècie per catalogar'), findsOneWidget);
      expect(find.text('Hàbitat i Distribució'), findsOneWidget);
      expect(find.text('Claus Morfològiques Bloquejades'), findsOneWidget);

      // Tap "Cercar amb la càmera" CTA to launch the scanner
      final searchCtaFinder = find.text('Cercar amb la càmera');
      await tester.scrollUntilVisible(
        searchCtaFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(searchCtaFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // 4. User is on the Scan tab
      expect(find.text('Escanejar'), findsWidgets);

      // Verify Viewfinder elements
      expect(find.text('Bolets'), findsOneWidget);
      expect(find.text('Arbres'), findsOneWidget);
      expect(find.text('Enfoca el barret i les làmines del bolet'),
          findsOneWidget);
      expect(find.byKey(const Key('gallery_picker_button')), findsOneWidget);

      // Test mode switching to Arbres and back
      await tester.tap(find.text('Arbres'));
      await tester.pumpAndSettle();
      expect(find.text('Enfoca l\'escorça o les fulles de l\'arbre'),
          findsOneWidget);

      await tester.tap(find.text('Bolets'));
      await tester.pumpAndSettle();
      expect(find.text('Enfoca el barret i les làmines del bolet'),
          findsOneWidget);

      // 5. User taps the Shutter button to initiate scan
      final shutterFinder = find.byKey(const Key('shutter_button'));
      expect(shutterFinder, findsOneWidget);
      await tester.tap(shutterFinder);
      await tester.pump(); // Start scan

      // Advance past ML inference latency (350ms)
      await tester.pump(const Duration(milliseconds: 400));
      // Advance bottom sheet slide transition
      await tester.pump(const Duration(milliseconds: 300));
      // Allow async database details to complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 6. Classification Result Sheet appears
      expect(find.text('Resultat de l\'anàlisi'), findsOneWidget);
      expect(find.text('Registrar a la meva Boscdex'), findsOneWidget);

      // Tap "Registrar a la meva Boscdex"
      final registerButtonFinder = find.text('Registrar a la meva Boscdex');
      await tester.ensureVisible(registerButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(registerButtonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 6b. Botanical Safety Check Dialog appears because Rovelló has toxic lookalikes
      expect(find.text('Comprovació Botànica de Seguretat'), findsOneWidget);
      // Check all checklist items
      final checkboxes = find.byType(Checkbox);
      for (final checkbox in checkboxes.evaluate()) {
        await tester.tap(find.byWidget(checkbox.widget));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Tap confirm in safety dialog
      final confirmTraitsFinder = find.text('He comprovat aquests trets');
      expect(confirmTraitsFinder, findsOneWidget);
      await tester.tap(confirmTraitsFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Sheet dismissed, success snackbar shown
      expect(find.text('🎉 Nou bolet desbloquejat a la teva Boscdex!'),
          findsOneWidget);

      // 7. Return to Boscdex album tab
      final boscdexTabFinder = find.text('Boscdex').first;
      await tester.tap(boscdexTabFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Verify discovery counter has incremented from 0 to 1
      expect(find.text('1/${AppConstants.catalogSpeciesCount} descoberts'),
          findsOneWidget);

      // 8. Tap on the unlocked card in Boscdex grid to verify navigation to detail
      final cardFinder = find.text('Rovelló / Pinetell');
      expect(cardFinder, findsOneWidget);
      await tester.tap(cardFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify detail screen rendered
      expect(find.text('Lactarius deliciosus'), findsOneWidget);
      expect(find.text('Morfologia'), findsOneWidget);

      // Pop back to the main tabs
      Navigator.of(tester.element(find.text('Morfologia'))).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 9. Navigate to Journal tab
      final journalTabFinder = find.text('Diari');
      await tester.tap(journalTabFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Verify sighting is listed in the journal
      expect(find.text('El Meu Diari'), findsOneWidget);
      expect(find.text('Rovelló / Pinetell'), findsWidgets);

      // Dismiss snackbars and unmount widget tree so Riverpod/Drift streams flush
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
          .clearSnackBars();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });
}
