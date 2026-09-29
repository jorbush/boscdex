import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/classificacio_result.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/presentation/scan/tree_classification_result_sheet.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Tree Classification & Result Sheet Tests', () {
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

    test('MockClassifierService classifyTree returns valid tree candidates',
        () async {
      final classifier = MockClassifierService();
      final results = await classifier.classifyTree(Uint8List(0));

      expect(results, isNotEmpty);
      expect(results.first.arbreId, equals('pinus_sylvestris'));
      expect(results.first.confidence, greaterThan(0.90));
      expect(results.length, greaterThan(1));
    });

    testWidgets(
        'TreeClassificationResultSheet displays tree info, traits, and associated bolets',
        (WidgetTester tester) async {
      bool inspected = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TreeClassificationResultSheet(
                results: const [
                  ArbreClassificacioResult(
                    arbreId: 'pinus_sylvestris',
                    displayName: 'Pi roig',
                    confidence: 0.93,
                  ),
                  ArbreClassificacioResult(
                    arbreId: 'pinus_halepensis',
                    displayName: 'Pi blanc',
                    confidence: 0.45,
                  ),
                ],
                onInspected: () {
                  inspected = true;
                },
              ),
            ),
          ),
        ),
      );

      // Settle async DB queries
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify title and confidence
      expect(find.text('Resultat d\'arbre'), findsOneWidget);
      expect(find.text('93% coincidència'), findsOneWidget);

      // Verify tree identification
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.text('Pinus sylvestris'), findsOneWidget);

      // Verify botanical traits
      expect(find.text('Agulla'), findsOneWidget);
      expect(find.text('Tronc superior ataronjat'), findsOneWidget);
      expect(find.text('Silici o àcid'), findsOneWidget);

      // Verify associated mushrooms section and Rovelló association
      expect(
        find.text('Bolets que pots cercar sota aquest arbre:'),
        findsOneWidget,
      );
      expect(find.textContaining('Rovelló'), findsWidgets);

      // Verify secondary candidate is listed
      expect(find.text('Pi blanc'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);

      // Verify action button
      final viewButton = find.text('Veure fitxa completa de l\'arbre');
      expect(viewButton, findsOneWidget);
      await tester.ensureVisible(viewButton);
      await tester.pumpAndSettle();
      await tester.tap(viewButton);
      expect(inspected, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'TreeClassificationResultSheet registers sighting to Diari when tapping Registrar troballa al Diari',
        (WidgetTester tester) async {
      bool registered = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TreeClassificationResultSheet(
                results: const [
                  TreeClassificationResult(
                    arbreId: 'pinus_sylvestris',
                    displayName: 'Pi roig',
                    confidence: 0.93,
                  ),
                ],
                onRegistered: () {
                  registered = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final registerButton =
          find.byKey(const Key('register_tree_sighting_button'));
      expect(registerButton, findsOneWidget);
      expect(find.text('Registrar troballa al Diari'), findsOneWidget);

      await tester.ensureVisible(registerButton);
      await tester.pump();
      await tester.tap(registerButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(registered, isTrue);

      final sightings =
          await db.avistamentDao.getAvistamentsByArbre('pinus_sylvestris');
      expect(sightings.length, equals(1));
      expect(sightings.first.arbreId, equals('pinus_sylvestris'));

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
