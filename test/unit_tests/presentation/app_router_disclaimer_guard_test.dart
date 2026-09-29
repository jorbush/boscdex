import 'package:boscdex/core/router/app_router.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
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

  group('AppRouter Deep-Link Disclaimer Guard Tests', () {
    late AppDatabase testDb;

    setUp(() {
      testDb = AppDatabase.forTesting(NativeDatabase.memory());
    });

    testWidgets(
        'Deep-linking into /boscdex redirects to /disclaimer when disclaimer is not accepted',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': false,
      });
      final prefs = await SharedPreferences.getInstance();

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

      // Attempt direct deep link to /boscdex
      appRouter.go('/boscdex');
      await tester.pumpAndSettle();

      // Assert user is intercepted and shown the disclaimer screen
      expect(find.text('Avís Legal Important'), findsOneWidget);
      expect(find.text('Començar a explorar'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets(
        'Deep-linking into /boscdex succeeds when disclaimer is already accepted',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': true,
      });
      final prefs = await SharedPreferences.getInstance();

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

      // Attempt direct deep link to /boscdex
      appRouter.go('/boscdex');
      await tester.pumpAndSettle();

      // Assert user directly lands on Boscdex Album
      expect(find.text('Boscdex'), findsWidgets);
      expect(find.text('Avís Legal Important'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });
}
