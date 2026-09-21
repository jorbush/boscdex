import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/detail/bolet_detail_screen.dart';
import 'package:boscdex/presentation/detail/arbre_detail_screen.dart';
import 'package:boscdex/presentation/detail/toxic_twin_alert.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

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
        'ArbreDetailScreen renders tree information and associated bolets',
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

      // Verify tree name and details
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.text('Pinus sylvestris'), findsOneWidget);
      expect(
        find.text('Bolets associats', skipOffstage: false),
        findsOneWidget,
      );

      // Verify associated mushrooms chips appear (Rovelló grows with Pi roig)
      expect(
        find.textContaining('Rovelló', skipOffstage: false),
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
  });
}
