import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/domain/models/catalonia_zone.dart';
import 'package:boscdex/presentation/detail/catalonia_pixel_map.dart';
import 'package:boscdex/presentation/shared/pixel_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CataloniaPixelMap Widget Tests', () {
    testWidgets('Renders CataloniaPixelMap with active zones and legend',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(450, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const activeZones = [
        CataloniaZone.altPirineu,
        CataloniaZone.prepirineuCentral,
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CataloniaPixelMap(
                activeZones: activeZones,
                speciesName: 'Rovelló',
              ),
            ),
          ),
        ),
      );

      // Discrete pump for animation initialization
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Verify Header and active counter
      expect(find.text('Ubicació'), findsOneWidget);
      expect(find.text('2 / 7 zones'), findsOneWidget);

      // 2. Verify Compass/Map indicator with pixel icon
      expect(find.text('CATALUNYA'), findsOneWidget);
      expect(find.byType(PixelCompassIcon), findsOneWidget);

      // 3. Verify Legend and PixelZonePinIcons
      expect(find.text('Presència habitual'), findsOneWidget);
      expect(find.text('Sense presència'), findsOneWidget);
      expect(find.byType(PixelZonePinIcon), findsWidgets);

      // 4. Verify zone selector chips are rendered
      expect(find.text('Alt Pirineu'), findsOneWidget);
      expect(find.text('Prepirineu / Central'), findsOneWidget);

      // 5. Verify initial selected zone details are rendered
      expect(find.text('Alt Pirineu i Aran'), findsOneWidget);
      expect(find.textContaining('Val d\'Aran'), findsOneWidget);

      // 6. Tap chip to change selection
      final chipFinder = find.text('Prepirineu / Central');
      await tester.tap(chipFinder);
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Prepirineu i Cat. Central'), findsOneWidget);
      expect(find.textContaining('Berguedà, Solsonès'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('Renders CataloniaPixelMap in Spanish', (tester) async {
      await tester.binding.setSurfaceSize(const Size(450, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const activeZones = [
        CataloniaZone.altPirineu,
        CataloniaZone.prepirineuCentral,
      ];

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: CataloniaPixelMap(
                activeZones: activeZones,
                speciesName: 'Níscalo',
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Ubicación'), findsOneWidget);
      expect(find.text('2 / 7 zonas'), findsOneWidget);
      expect(find.text('Presencia habitual'), findsOneWidget);
      expect(find.text('Sin presencia'), findsOneWidget);
      expect(find.text('Alto Pirineo'), findsOneWidget);
      expect(find.text('Alto Pirineo y Arán'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('Renders CataloniaPixelMap in English', (tester) async {
      await tester.binding.setSurfaceSize(const Size(450, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const activeZones = [
        CataloniaZone.altPirineu,
        CataloniaZone.prepirineuCentral,
      ];

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: CataloniaPixelMap(
                activeZones: activeZones,
                speciesName: 'Saffron Milk Cap',
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Location'), findsOneWidget);
      expect(find.text('2 / 7 zones'), findsOneWidget);
      expect(find.text('Regular presence'), findsOneWidget);
      expect(find.text('No presence'), findsOneWidget);
      expect(find.text('High Pyrenees'), findsOneWidget);
      expect(find.text('High Pyrenees & Aran'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
