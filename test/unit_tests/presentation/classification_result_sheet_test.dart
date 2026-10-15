import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/classificacio_result.dart';
import 'package:boscdex/presentation/scan/botanical_safety_check_dialog.dart';
import 'package:boscdex/presentation/scan/classification_result_sheet.dart';
import 'package:boscdex/presentation/shared/safety_alert_box.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('ClassificationResultSheet Widget Tests', () {
    late AppDatabase db;
    late SharedPreferences prefs;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': true,
        'toxicComparisonViewCount': 0,
      });
      prefs = await SharedPreferences.getInstance();
    });

    tearDown(() async {
      // In-memory sqlite is automatically cleaned up with the test process
    });

    testWidgets('renders red danger alert when identified mushroom is mortal',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'amanita_phalloides',
                    displayName: 'Farinera borda',
                    confidence: 0.94,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('danger_alert_banner')), findsOneWidget);
      expect(find.text('ATENCIÓ: ESPÈCIE MORTAL'), findsOneWidget);
      expect(find.textContaining('No el consumeixis mai'), findsOneWidget);

      // Unmount widget tree cleanly before test ends
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('renders amber alert when classification confidence is low',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'boletus_edulis',
                    displayName: 'Cep',
                    confidence: 0.62,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('No es pot identificar amb certesa'),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'renders SafetyAlertBox when high confidence edible has toxic lookalike',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'lactarius_deliciosus',
                    displayName: 'Rovelló',
                    confidence: 0.95,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SafetyAlertBox), findsOneWidget);
      expect(find.textContaining('Reig bord'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'renders other candidate possibilities with high-contrast text and progress bars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'lactarius_deliciosus',
                    displayName: 'Rovelló',
                    confidence: 0.85,
                  ),
                  ClassificacioResult(
                    boletId: 'lactarius_sanguifluus',
                    displayName: 'Rovelló de sang',
                    confidence: 0.52,
                  ),
                  ClassificacioResult(
                    boletId: 'suillus_luteus',
                    displayName: 'Llenegot',
                    confidence: 0.18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Altres possibles espècies:'), findsOneWidget);
      expect(find.text('Rovelló de sang'), findsOneWidget);
      expect(find.text('52%'), findsOneWidget);
      expect(find.text('Llenegot'), findsOneWidget);
      expect(find.text('18%'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'ClassificationResultSheet displays GPS coordinates and persists them to database',
        (WidgetTester tester) async {
      final mockPosition = Position(
        latitude: 42.18,
        longitude: 1.85,
        timestamp: DateTime(2026, 10, 1),
        accuracy: 4.0,
        altitude: 850.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                initialLocation: mockPosition,
                results: const [
                  ClassificacioResult(
                    boletId: 'lactarius_deliciosus',
                    displayName: 'Rovelló',
                    confidence: 0.95,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify GPS pill shows coordinates
      expect(find.textContaining('42.18° N, 1.85° E'), findsOneWidget);
      expect(find.textContaining('850 m'), findsOneWidget);

      // Tap Register CTA
      await tester.tap(find.text('Registrar a la meva Boscdex'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Handle Botanical Safety Check Dialog if displayed
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        for (final cb in checkboxes.evaluate()) {
          await tester.tap(find.byWidget(cb.widget));
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();
        final confirmBtn = find.text('He comprovat aquests trets');
        if (confirmBtn.evaluate().isNotEmpty) {
          await tester.tap(confirmBtn);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
        }
      }

      // Verify record in database has GPS coordinates
      final avistaments = await db.select(db.avistaments).get();
      expect(avistaments.length, 1);
      final saved = avistaments.first;
      expect(saved.latitude, 42.18);
      expect(saved.longitude, 1.85);
      expect(saved.altitude, 850.0);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets(
        'renders localized lookalike names in SafetyAlertBox under Spanish locale',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            locale: Locale('es'),
            supportedLocales: [Locale('ca'), Locale('es'), Locale('en')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'lactarius_deliciosus',
                    displayName: 'Níscalo',
                    confidence: 0.95,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SafetyAlertBox), findsOneWidget);
      // Under Spanish locale, Amanita muscaria is "Matamoscas"
      expect(find.textContaining('Matamoscas'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'renders SafetyAlertBox when runner-up candidate is mortal (Top-N Toxicity Gate)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'boletus_edulis',
                    displayName: 'Cep',
                    confidence: 0.74,
                  ),
                  ClassificacioResult(
                    boletId: 'amanita_phalloides',
                    displayName: 'Farinera borda',
                    confidence: 0.22,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // boletus_edulis has no direct toxic lookalikes in the database,
      // but runner-up Amanita phalloides triggers the Top-N Toxicity Gate!
      expect(find.byType(SafetyAlertBox), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SafetyAlertBox),
          matching: find.textContaining('Farinera borda'),
        ),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'prompts botanical safety checklist before registering low-confidence candidate',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'boletus_edulis',
                    displayName: 'Cep',
                    confidence: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final registerButton = find.text('Registrar a la meva Boscdex');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.byType(BotanicalSafetyCheckDialog), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'prompts botanical safety checklist before registering when secondary candidate is toxic',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClassificationResultSheet(
                results: [
                  ClassificacioResult(
                    boletId: 'calocybe_gambosa',
                    displayName: 'Moixernó',
                    confidence: 0.74,
                  ),
                  ClassificacioResult(
                    boletId: 'entoloma_sinuatum',
                    displayName: 'Pèrfid',
                    confidence: 0.20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final registerButton = find.text('Registrar a la meva Boscdex');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.byType(BotanicalSafetyCheckDialog), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
