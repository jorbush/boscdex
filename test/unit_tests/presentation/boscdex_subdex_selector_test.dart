import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/boscdex/boscdex_screen.dart';
import 'package:boscdex/presentation/boscdex/boscdex_card.dart';
import 'package:boscdex/presentation/boscdex/arbre_card.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Boscdex Dual-Dex Sub-catalog Selector Tests', () {
    late AppDatabase db;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'visitedArbres': <String>[]});
      prefs = await SharedPreferences.getInstance();
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      // In-memory sqlite is automatically cleaned up with the test process
    });

    testWidgets(
        'Toggling between Bolets and Arbres sub-catalogs updates stats, filters, and cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: BoscdexScreen(),
          ),
        ),
      );

      // Settle initial load
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // 1. Initially on Bolets
      expect(find.text('🍄 Bolets'), findsOneWidget);
      expect(find.text('🌲 Arbres'), findsOneWidget);
      expect(find.textContaining('descoberts'), findsOneWidget);
      expect(find.text('Comestibles'), findsOneWidget);
      expect(find.text('Tòxics/mortals'), findsOneWidget);

      // Verify mushroom cards are displayed
      expect(find.byType(BoscdexCard), findsWidgets);
      expect(find.byType(ArbreCard), findsNothing);

      // 2. Tap on '🌲 Arbres' to switch sub-catalog
      final arbresTab = find.byKey(const Key('section_tab_arbres'));
      await tester.tap(arbresTab);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Verify header stats switch to tree indicators
      expect(find.textContaining('identificats'), findsOneWidget);

      // Verify tree leaf filters appear
      expect(find.byKey(const Key('arbre_filter_agulla')), findsOneWidget);
      expect(find.byKey(const Key('arbre_filter_caduca')), findsOneWidget);
      expect(find.byKey(const Key('arbre_filter_perenne')), findsOneWidget);

      // Verify ArbreCards are now rendered
      expect(find.byType(ArbreCard), findsWidgets);
      expect(find.byType(BoscdexCard), findsNothing);
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.text('Pi blanc'), findsOneWidget);

      // 3. Tap leaf filter 'Caduca'
      final caducaFilter = find.byKey(const Key('arbre_filter_caduca'));
      await tester.tap(caducaFilter);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Only deciduous trees should be displayed (Faig, Castanyer)
      expect(find.text('Faig'), findsOneWidget);
      expect(find.text('Castanyer'), findsOneWidget);
      expect(find.text('Pi roig'), findsNothing);

      // 4. Switch back to '🍄 Bolets'
      final boletsTab = find.byKey(const Key('section_tab_bolets'));
      await tester.tap(boletsTab);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Bolets cards return
      expect(find.byType(BoscdexCard), findsWidgets);
      expect(find.byType(ArbreCard), findsNothing);
      expect(find.textContaining('descoberts'), findsOneWidget);

      // Unmount widget tree cleanly to dispose active StreamProviders
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
