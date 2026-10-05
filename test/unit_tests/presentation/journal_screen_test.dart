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
    Map<String, String> arbresMap = const {},
  }) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        avistamentsProvider.overrideWith((ref) => Stream.value(avistaments)),
        allBoletsMapProvider.overrideWith((ref) => boletsMap),
        allArbresMapProvider.overrideWith((ref) => arbresMap),
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
      find.text(
          'Encara no tens cap avistament. Escaneja el teu primer bolet o arbre!'),
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

  testWidgets(
      'JournalScreen renders tree sighting cards with ARBRE tag and opens detail',
      (tester) async {
    final now = DateTime(2026, 9, 28, 16, 30);
    final treeAvistament = Avistament(
      id: 'journal-tree-test-1',
      arbreId: 'pinus_sylvestris',
      timestamp: now,
      confidenceScore: 0.95,
      notes: 'Bosc madur de pi roig',
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [treeAvistament],
      arbresMap: {'pinus_sylvestris': 'Pi roig'},
    ));
    await tester.pumpAndSettle();

    // Verify tree title and ARBRE badge
    expect(find.text('ARBRE'), findsOneWidget);
    expect(find.textContaining('Pi roig'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
    expect(find.text('Bosc madur de pi roig'), findsOneWidget);

    // Tap tree sighting to open AvistamentDetailSheet
    await tester.tap(find.textContaining('Pi roig'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
    expect(find.text('95%'), findsWidgets);

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

  testWidgets('Switching between Llista and Mapa view mode updates UI',
      (tester) async {
    final sightingWithGps = Avistament(
      id: 'journal-gps-test',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 10, 1, 9, 0),
      confidenceScore: 0.96,
      notes: null,
      photoPath: null,
      latitude: 42.18,
      longitude: 1.85,
      altitude: 850.0,
    );

    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [sightingWithGps],
      boletsMap: {'lactarius_deliciosus': 'Rovelló'},
    ));
    await tester.pumpAndSettle();

    // Verify view mode tabs exist
    expect(find.byKey(const Key('journal_tab_list')), findsOneWidget);
    expect(find.byKey(const Key('journal_tab_map')), findsOneWidget);

    // Initial mode is Llista -> shows sighting in list
    expect(find.textContaining('Rovelló'), findsWidgets);

    // Tap Mapa tab
    await tester.tap(find.byKey(const Key('journal_tab_map')));
    await tester.pumpAndSettle();

    // Map view is now active -> shows filter chips and marker
    expect(find.byKey(const Key('map_filter_tots')), findsOneWidget);
    expect(find.byKey(const Key('map_reset_zoom_button')), findsOneWidget);

    // Switch back to Llista tab
    await tester.tap(find.byKey(const Key('journal_tab_list')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('journal_tab_list')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
