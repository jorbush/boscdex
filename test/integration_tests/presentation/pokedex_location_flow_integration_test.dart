import 'package:boscdex/core/router/app_router.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/presentation/detail/arbre_detail_screen.dart';
import 'package:boscdex/presentation/detail/bolet_detail_screen.dart';
import 'package:boscdex/providers/classifier_provider.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Pokédex Location Flow Integration Test', () {
    late AppDatabase testDb;
    late SharedPreferences prefs;

    setUp(() async {
      testDb = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': true,
        'toxicComparisonViewCount': 0,
        'visitedArbres': <String>[],
      });
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets(
        'Inspect undiscovered bolet habitat -> view associated trees -> navigate to tree profile',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDatabaseProvider.overrideWithValue(testDb),
            classifierProvider.overrideWithValue(MockClassifierService()),
          ],
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );

      // Settle initial splash / redirect to /boscdex
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();

      // 1. Verify we are on Boscdex screen and #001 is undiscovered
      expect(find.text('#001 ???'), findsOneWidget);

      // 2. Tap on the undiscovered card
      await tester.tap(find.text('#001 ???'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // 3. Verify BoletDetailScreen is mounted in undiscovered mystery mode
      expect(find.byType(BoletDetailScreen), findsOneWidget);
      expect(find.text('#001 ???'), findsOneWidget);
      expect(find.text('Espècie per catalogar'), findsOneWidget);
      expect(find.text('No descobert'), findsOneWidget);
      expect(find.text('Comestibilitat: ???'), findsOneWidget);

      // 4. Verify Habitat & Location information is visible
      expect(find.text('Hàbitat i Distribució'), findsOneWidget);
      expect(find.text('Ubicació'), findsOneWidget);
      expect(find.text('Arbres associats'), findsOneWidget);
      expect(find.text('Altitud de fructificació'), findsOneWidget);
      expect(find.text('Claus Morfològiques Bloquejades'), findsOneWidget);
      expect(find.text('Cercar amb la càmera'), findsOneWidget);

      // 5. Locate associated tree chip for Pi roig (symbiont of Rovelló)
      final piRoigChip = find.text('Pi roig');
      expect(piRoigChip, findsOneWidget);

      // 6. Scroll to and tap the associated tree chip
      await tester.ensureVisible(piRoigChip);
      await tester.pumpAndSettle();
      await tester.tap(piRoigChip);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // 7. Verify navigation to ArbreDetailScreen
      expect(find.byType(ArbreDetailScreen), findsOneWidget);
      expect(find.text('Pi roig'), findsWidgets);
      expect(find.text('Pinus sylvestris'), findsOneWidget);
      expect(find.text('Bolets associats'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });
}
