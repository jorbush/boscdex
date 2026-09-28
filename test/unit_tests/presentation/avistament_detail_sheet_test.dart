import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/journal/avistament_detail_sheet.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    // In-memory sqlite is automatically cleaned up with the test process
  });

  Widget createWidgetUnderTest(Avistament avistament,
      {VoidCallback? onDeleted}) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: AvistamentDetailSheet(
            avistament: avistament,
            onDeleted: onDeleted,
          ),
        ),
      ),
    );
  }

  testWidgets('Renders AvistamentDetailSheet with high confidence score',
      (tester) async {
    final avistament = Avistament(
      id: 'test-1',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 9, 25, 10, 30),
      confidenceScore: 0.89,
      notes: 'Trobat sota un pi roig',
      altitude: 1250,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
    expect(find.text('Coincidència Neural AI'), findsOneWidget);
    expect(find.text('89%'), findsOneWidget);

    // Scroll down to reveal species card and bottom action buttons
    await tester.scrollUntilVisible(find.textContaining('Rovelló'), 200);
    await tester.pumpAndSettle();
    expect(find.textContaining('Rovelló'), findsOneWidget);

    await tester.scrollUntilVisible(find.byTooltip('Eliminar avistament'), 200);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Compartir'), findsOneWidget);
    expect(find.byTooltip('Eliminar avistament'), findsOneWidget);
    expect(find.text('Descarregar Foto'), findsOneWidget);
    expect(find.text('Veure fitxa completa a la Boscdex'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Renders AvistamentDetailSheet with low confidence alert',
      (tester) async {
    final avistament = Avistament(
      id: 'test-low',
      boletId: 'tricholoma_terreum',
      timestamp: DateTime(2026, 9, 25, 11, 0),
      confidenceScore: 0.45,
      notes: null,
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    expect(find.text('45%'), findsOneWidget);
    expect(find.textContaining('Coincidència moderada'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Delete button triggers confirmation dialog', (tester) async {
    final avistament = Avistament(
      id: 'test-delete',
      boletId: 'boletus_edulis',
      timestamp: DateTime(2026, 9, 25, 12, 0),
      confidenceScore: 0.95,
      notes: null,
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    final deleteBtn = find.byTooltip('Eliminar avistament');
    await tester.scrollUntilVisible(deleteBtn, 200);
    await tester.pumpAndSettle();

    expect(deleteBtn, findsOneWidget);

    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    expect(find.text('Eliminar avistament?'), findsOneWidget);
    expect(find.text('Cancel·lar'), findsOneWidget);

    await tester.tap(find.text('Cancel·lar'));
    await tester.pumpAndSettle();
  });
}
