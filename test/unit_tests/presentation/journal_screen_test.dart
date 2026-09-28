import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/journal/journal_provider.dart';
import 'package:boscdex/presentation/journal/journal_screen.dart';
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

  Widget createWidgetUnderTest({
    List<Avistament> avistaments = const [],
    Map<String, String> boletsMap = const {},
  }) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        avistamentsProvider.overrideWith((ref) => Stream.value(avistaments)),
        allBoletsMapProvider.overrideWith((ref) => boletsMap),
      ],
      child: const MaterialApp(
        home: JournalScreen(),
      ),
    );
  }

  testWidgets('JournalScreen renders empty state when no sightings exist',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('El Meu Diari'), findsOneWidget);
    expect(find.text('DIARI D\'AVENTURES'), findsOneWidget);
    expect(
      find.text('Encara no tens cap avistament. Escaneja el teu primer bolet!'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('JournalScreen renders sighting cards with confidence pill',
      (tester) async {
    final now = DateTime(2026, 9, 25, 14, 0);
    final avistament = Avistament(
      id: 'journal-test-1',
      boletId: 'lactarius_deliciosus',
      timestamp: now,
      confidenceScore: 0.92,
      notes: 'Bosc de pinedes al Berguedà',
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [avistament],
      boletsMap: {'lactarius_deliciosus': 'Rovelló / Pinetell'},
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Rovelló'), findsOneWidget);
    expect(find.text('92%'), findsOneWidget);
    expect(find.text('Bosc de pinedes al Berguedà'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Tapping sighting opens AvistamentDetailSheet modal',
      (tester) async {
    final avistament = Avistament(
      id: 'journal-test-modal',
      boletId: 'boletus_edulis',
      timestamp: DateTime.now(),
      confidenceScore: 0.98,
      notes: 'Gran exemplar sota un faig',
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [avistament],
      boletsMap: {'boletus_edulis': 'Cep'},
    ));
    await tester.pumpAndSettle();

    final item = find.textContaining('Cep');
    expect(item, findsOneWidget);

    await tester.tap(item);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
    expect(find.text('98%'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Descarregar Foto'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(find.text('Descarregar Foto'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
