import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/presentation/disclaimer/disclaimer_screen.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DisclaimerScreen Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'disclaimerAccepted': false});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('Renders disclaimer card and disabled button by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: DisclaimerScreen(),
          ),
        ),
      );

      expect(find.text('Avís Legal Important'), findsOneWidget);
      expect(find.text('Començar a explorar'), findsOneWidget);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Començar a explorar');
      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('Checking agreement enables start button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: DisclaimerScreen(),
          ),
        ),
      );

      // Tap checkbox row
      await tester.tap(find.text('He llegit i accepto les condicions d\'avisos de seguretat'));
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Començar a explorar');
      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Does not overflow on constrained screen dimensions (e.g. 320x480)',
        (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(320, 480);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: DisclaimerScreen(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Avís Legal Important'), findsOneWidget);
    });
  });
}
