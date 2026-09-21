import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/classificacio_result.dart';
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
  });
}
