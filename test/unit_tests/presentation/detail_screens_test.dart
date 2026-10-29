import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/detail/bolet_detail_screen.dart';
import 'package:boscdex/presentation/detail/arbre_detail_screen.dart';
import 'package:boscdex/presentation/detail/toxic_twin_alert.dart';
import 'package:boscdex/presentation/shared/photo_zoom_dialog.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Detail Screens Widget Tests', () {
    late AppDatabase db;
    late SharedPreferences prefs;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': true,
        'toxicComparisonViewCount': 0,
        'visitedArbres': <String>[],
      });
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets(
        'BoletDetailScreen renders specimen information and toxic twin alert',
        (WidgetTester tester) async {
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoletDetailScreen(id: 'lactarius_deliciosus'),
          ),
        ),
      );

      // Discrete pumps to settle async DB queries without hanging on spinners
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify mushroom details render
      expect(find.text('Rovelló / Pinetell'), findsOneWidget);
      expect(find.text('Lactarius deliciosus'), findsOneWidget);
      expect(find.text('Comestible excel·lent'), findsOneWidget);

      // Verify morphology section headers render
      expect(find.text('Morfologia'), findsOneWidget);

      // Verify toxic lookalike alert renders with exact lookalike name and comparison notes
      expect(
        find.byType(ToxicTwinAlert, skipOffstage: false),
        findsWidgets,
      );
      expect(
        find.text('Reig bord', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.textContaining('mai presenta làtex taronja', skipOffstage: false),
        findsOneWidget,
      );

      // Verify header cover image magnifying glass is present and mode switch tabs are gone
      expect(find.byIcon(Icons.zoom_in_rounded), findsOneWidget);
      expect(find.text('👾 Pixel Art'), findsNothing);
      expect(find.text('📷 Foto Real'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'BoletDetailScreen renders mystery undiscovered view with habitat location when not discovered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoletDetailScreen(id: 'lactarius_deliciosus'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify veiled identity:
      expect(find.text('#001 ???'), findsOneWidget);
      expect(find.text('Espècie per catalogar'), findsOneWidget);
      expect(find.text('No descobert'), findsOneWidget);
      expect(find.text('Comestibilitat: ???'), findsOneWidget);
      expect(find.text('Rovelló / Pinetell'), findsNothing);
      expect(find.text('Lactarius deliciosus'), findsNothing);
      expect(find.text('Comestible excel·lent'), findsNothing);

      // Verify magnifying glass and mode tabs are NOT present when undiscovered:
      expect(find.byIcon(Icons.zoom_in_rounded), findsNothing);
      expect(find.text('👾 Pixel Art'), findsNothing);
      expect(find.text('📷 Foto Real'), findsNothing);

      // Verify Habitat and Distribution (Location) renders:
      expect(find.text('Hàbitat i Distribució'), findsOneWidget);
      expect(find.text('Arbres associats'), findsOneWidget);
      expect(find.text('Altitud de fructificació'), findsOneWidget);

      // Verify morphology is locked:
      expect(find.text('Claus Morfològiques Bloquejades'), findsOneWidget);
      expect(find.text('Morfologia'), findsNothing);

      // Verify toxic twin alert is ALWAYS visible for safety even when undiscovered:
      expect(find.byType(ToxicTwinAlert), findsWidgets);

      // Verify Camera CTA:
      expect(find.text('Cercar amb la càmera'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'BoletDetailScreen tapping magnifying glass opens PhotoZoomDialog',
        (WidgetTester tester) async {
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoletDetailScreen(id: 'lactarius_deliciosus'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final zoomButton = find.byIcon(Icons.zoom_in_rounded);
      expect(zoomButton, findsOneWidget);

      await tester.tap(zoomButton);
      await tester.pumpAndSettle();

      expect(find.byType(PhotoZoomDialog), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('BoletDetailScreen renders not found state for invalid id',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoletDetailScreen(id: 'non_existent_mushroom'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No trobat'), findsOneWidget);
      expect(find.text('Aquest bolet no existeix.'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'ArbreDetailScreen obfuscates undiscovered associated bolets and reveals discovered ones',
        (WidgetTester tester) async {
      // 1. Initially undiscovered: Rovelló is undiscovered (#001)
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: ArbreDetailScreen(id: 'pinus_sylvestris'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify tree name and details
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.text('Pinus sylvestris'), findsOneWidget);
      expect(
        find.text('Bolets associats', skipOffstage: false),
        findsOneWidget,
      );

      // Verify undiscovered edible associated bolets show obfuscated dex number (#001 Rovelló)
      expect(
        find.text('#001 ???', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Rovelló / Pinetell', skipOffstage: false),
        findsNothing,
      );

      // Verify undiscovered toxic associated bolets are unmasked for safety
      expect(
        find.textContaining('Cabra / Rovelló bord', skipOffstage: false),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());

      // 2. Now mark lactarius_deliciosus as discovered
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: ArbreDetailScreen(id: 'pinus_sylvestris'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Now Rovelló is revealed!
      expect(
        find.text('Rovelló / Pinetell', skipOffstage: false),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'ArbreDetailScreen renders reference photo header and opens zoom dialog on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: ArbreDetailScreen(id: 'pinus_sylvestris'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify zoom button is present in the cover header
      final zoomButton = find.byIcon(Icons.zoom_in_rounded);
      expect(zoomButton, findsOneWidget);

      await tester.tap(zoomButton);
      await tester.pumpAndSettle();

      // Verify PhotoZoomDialog opened with tree name and scientific name
      expect(find.byType(PhotoZoomDialog), findsOneWidget);
      expect(find.text('Pi roig'), findsWidgets);
      expect(find.text('Pinus sylvestris'), findsWidgets);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'BoletDetailScreen renders unlocked safety information for undiscovered toxic mushroom',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoletDetailScreen(id: 'amanita_phalloides'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Unmasked name & scientific classification for safety
      expect(find.text('Farinera borda'), findsOneWidget);
      expect(find.text('Amanita phalloides'), findsOneWidget);
      expect(find.text('Espècie per catalogar'), findsNothing);

      // 2. Warning badges: Mortal edibility + Undiscovered
      expect(find.text('Mortal'), findsOneWidget);
      expect(find.text('No descobert'), findsOneWidget);

      // 3. Real photo header cover & magnifying glass zoom button unlocked
      expect(find.byIcon(Icons.zoom_in_rounded), findsOneWidget);

      // 4. Morphology keys unlocked
      expect(find.text('Morfologia'), findsOneWidget);
      expect(find.text('Claus Morfològiques Bloquejades'), findsNothing);

      // 5. Preventive safety advisory card displayed instead of camera hunting CTA
      expect(find.text('Avís de Seguretat Preventiva'), findsOneWidget);
      expect(find.text('Cercar amb la càmera'), findsNothing);

      // 6. 16-bit arcade sprite card remains in silhouette until field discovery
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ColorFiltered &&
              widget.colorFilter ==
                  const ColorFilter.mode(
                    Color(0xFF1E2822),
                    BlendMode.srcIn,
                  ),
        ),
        findsWidgets,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('ArbreDetailScreen renders not found state for invalid id',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: ArbreDetailScreen(id: 'non_existent_tree'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No trobat'), findsOneWidget);
      expect(find.text('Aquest arbre no existeix.'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'BoletDetailScreen renders localized names, morphology, and location header in Spanish',
        (WidgetTester tester) async {
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: BoletDetailScreen(id: 'lactarius_deliciosus'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Níscalo / Robellón'), findsOneWidget);
      expect(find.text('Excelente comestible'), findsOneWidget);
      expect(find.text('Ubicación'), findsOneWidget);
      expect(find.text('Morfología'), findsOneWidget);
      expect(find.text('Sombrero'), findsOneWidget);
      expect(find.text('Láminas'), findsOneWidget);
      expect(find.text('Pie'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());

      // Test a species with safety notes (amanita_phalloides)
      await db.descobrimentDao
          .markDiscovered('amanita_phalloides', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: BoletDetailScreen(id: 'amanita_phalloides'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Notas', skipOffstage: false), findsWidgets);
      expect(
        find.textContaining('MORTAL. Contiene amatoxinas', skipOffstage: false),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'BoletDetailScreen renders localized names, morphology, and location header in English',
        (WidgetTester tester) async {
      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: BoletDetailScreen(id: 'lactarius_deliciosus'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Saffron Milk Cap'), findsOneWidget);
      expect(find.text('Excellent edible'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Morphology'), findsOneWidget);
      expect(find.text('Cap'), findsOneWidget);
      expect(find.text('Gills'), findsOneWidget);
      expect(find.text('Stem'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());

      // Test a species with safety notes (amanita_phalloides)
      await db.descobrimentDao
          .markDiscovered('amanita_phalloides', DateTime.now(), null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: BoletDetailScreen(id: 'amanita_phalloides'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Notes', skipOffstage: false), findsWidgets);
      expect(
        find.textContaining('DEADLY. Contains lethal amatoxins',
            skipOffstage: false),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'ArbreDetailScreen renders localized traits in Spanish and English',
        (WidgetTester tester) async {
      // 1. Spanish
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: ArbreDetailScreen(id: 'pinus_sylvestris'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pino silvestre / Pino albar'), findsOneWidget);
      expect(find.text('Corteza'), findsOneWidget);
      expect(find.text('Hoja'), findsOneWidget);
      expect(find.text('Tronco superior anaranjado'), findsOneWidget);

      // 2. English
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
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
            home: ArbreDetailScreen(id: 'pinus_sylvestris'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Scots Pine'), findsOneWidget);
      expect(find.text('Bark'), findsOneWidget);
      expect(find.text('Leaf'), findsOneWidget);
      expect(find.text('Upper trunk orange-ochre'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'Tapping ToxicTwinAlert in BoletDetailScreen navigates to lookalike screen and increments comparison count',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await db.descobrimentDao
          .markDiscovered('lactarius_deliciosus', DateTime.now(), null);

      final router = GoRouter(
        initialLocation: '/boscdex/lactarius_deliciosus',
        routes: [
          GoRoute(
            path: '/boscdex/:id',
            builder: (context, state) {
              final id = state.params['id']!;
              return BoletDetailScreen(id: id);
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to make ToxicTwinAlert visible
      final alertFinder = find.byType(ToxicTwinAlert);
      expect(alertFinder, findsNWidgets(4));
      await tester.ensureVisible(alertFinder.first);
      await tester.pumpAndSettle();

      // Tap first ToxicTwinAlert (amanita_muscaria)
      await tester.tap(alertFinder.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify comparison badge counter was incremented
      expect(container.read(toxicComparisonViewCountProvider), equals(1));

      // Verify router navigated to lookalike amanita_muscaria
      expect(router.location, equals('/boscdex/amanita_muscaria'));

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
