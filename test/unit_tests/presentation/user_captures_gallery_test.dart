import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/detail/bolet_detail_screen.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    // In-memory sqlite is automatically cleaned up with the test process
  });

  Widget createWidgetUnderTest(String id) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: BoletDetailScreen(id: id),
      ),
    );
  }

  testWidgets(
      'BoletDetailScreen shows empty captures prompt when no user scans exist',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest('lactarius_deliciosus'));
    await tester.pumpAndSettle();

    expect(find.text('Les Teves Captures (0)'), findsOneWidget);
    expect(find.text('Cap captura registrada'), findsOneWidget);
    expect(
      find.text(
          'Troba aquest bolet al bosc i escaneja\'l per afegir la teva foto!'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'BoletDetailScreen shows photo gallery cards when user scans exist',
      (tester) async {
    final now = DateTime(2026, 9, 25, 15, 0);

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const drift.Value('capture-test-1'),
        boletId: const drift.Value('lactarius_deliciosus'),
        timestamp: drift.Value(now),
        confidenceScore: const drift.Value(0.91),
        notes: const drift.Value('Rovelló d\'or'),
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest('lactarius_deliciosus'));
    await tester.pumpAndSettle();

    expect(find.text('Les Teves Captures (1)'), findsOneWidget);
    expect(find.text('91%'), findsOneWidget);
    expect(find.text('Nova foto'), findsOneWidget);
    expect(find.text('Cap captura registrada'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
