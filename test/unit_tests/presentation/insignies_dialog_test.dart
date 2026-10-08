import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/forager_level.dart';
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/presentation/boscdex/insignies_dialog.dart';
import 'package:boscdex/providers/database_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('InsigniesDialog Widget Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    testWidgets('Renders all 6 badges with initial locked states',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            foragerLevelProvider.overrideWithValue(ForagerLevel.initial()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 700,
                width: 400,
                child: InsigniesDialog(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Title and trophy icon
      expect(find.text('Les Meves Insígnies'), findsOneWidget);
      expect(find.text('0/6'), findsOneWidget);

      // Verify canonical badge names appear
      expect(find.text('Primer pas al bosc'), findsOneWidget);
      expect(find.text('Caçador de rovellons'), findsOneWidget);
      expect(find.text('Micòleg prudent'), findsOneWidget);
      expect(
          find.text('Aliança silvestre', skipOffstage: false), findsOneWidget);
      expect(
          find.text('Cistell de tardor', skipOffstage: false), findsOneWidget);
      expect(
          find.text('Mestre boletaire', skipOffstage: false), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Reflects awarded badge state', (WidgetTester tester) async {
      // Award the primer_pas_al_bosc badge
      await db.insigniaDao
          .awardInsignia('primer_pas_al_bosc', DateTime(2026, 9, 29));
      await db.insigniaDao.updateProgress('primer_pas_al_bosc', 1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            foragerLevelProvider.overrideWithValue(ForagerLevel.initial()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 700,
                width: 400,
                child: InsigniesDialog(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Now 1 out of 6 should be awarded
      expect(find.text('1/6'), findsOneWidget);
      expect(find.text('DESBLOQUEJAT'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
