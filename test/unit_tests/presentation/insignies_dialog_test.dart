import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/models/forager_level.dart';
import 'package:boscdex/domain/models/insignia.dart' as domain;
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

    testWidgets('Renders all 14 badges with initial locked states',
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
      expect(find.text('0/${domain.Insignia.registry.length}'), findsOneWidget);

      // Verify canonical badge names appear
      expect(find.text('Primer pas al bosc'), findsOneWidget);
      expect(find.text('Caçador de rovellons'), findsOneWidget);
      expect(find.text('Micòleg prudent'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Gran enciclopèdia'), 300);
      expect(find.text('Gran enciclopèdia'), findsOneWidget);

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

      // Now 1 out of total should be awarded
      expect(find.text('1/${domain.Insignia.registry.length}'), findsOneWidget);
      expect(find.text('DESBLOQUEJAT'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
