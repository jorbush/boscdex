import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/journal/journal_map_marker.dart';
import 'package:boscdex/presentation/journal/journal_map_view.dart';
import 'package:boscdex/presentation/shared/pixel_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mushroomSighting = Avistament(
    id: 'sighting-mushroom-1',
    boletId: 'lactarius_deliciosus',
    timestamp: DateTime(2026, 10, 1, 10, 30),
    latitude: 42.18,
    longitude: 1.85,
    altitude: 850.0,
    confidenceScore: 0.94,
    notes: 'Sota un pi roig al Berguedà',
    photoPath: null,
  );

  final treeSighting = Avistament(
    id: 'sighting-tree-1',
    arbreId: 'pinus_sylvestris',
    timestamp: DateTime(2026, 10, 1, 11, 0),
    latitude: 41.78,
    longitude: 2.40,
    altitude: 920.0,
    confidenceScore: 0.88,
    notes: 'Exemplar madur amb escorça rogenca al Montseny',
    photoPath: null,
  );

  final noGpsSighting = Avistament(
    id: 'sighting-no-gps-1',
    boletId: 'boletus_edulis',
    timestamp: DateTime(2026, 10, 1, 12, 0),
    latitude: null,
    longitude: null,
    altitude: null,
    confidenceScore: 0.91,
    notes: null,
    photoPath: null,
  );

  Widget createWidgetUnderTest({
    required List<Avistament> avistaments,
    Map<String, String> boletsMap = const {
      'lactarius_deliciosus': 'Rovelló',
      'boletus_edulis': 'Cep',
    },
    Map<String, String> arbresMap = const {
      'pinus_sylvestris': 'Pi roig',
    },
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: JournalMapView(
            avistaments: avistaments,
            boletsMap: boletsMap,
            arbresMap: arbresMap,
            animate: false,
          ),
        ),
      ),
    );
  }

  testWidgets('Renders empty state overlay when no sightings have GPS',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [noGpsSighting],
    ));
    await tester.pumpAndSettle();

    expect(find.text('SENSE COORDENADES GPS'), findsOneWidget);
    expect(find.textContaining('cap amb dades GPS'), findsOneWidget);
    expect(find.byType(JournalMapMarker), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'Renders markers on Catalonia map for mushroom and tree sightings with GPS',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [mushroomSighting, treeSighting, noGpsSighting],
    ));
    await tester.pumpAndSettle();

    // Verify filter chips with counts and pixel icons
    expect(find.text('Tots (2)'), findsOneWidget);
    expect(find.text('Bolets (1)'), findsOneWidget);
    expect(find.text('Arbres (1)'), findsOneWidget);
    expect(find.byType(PixelBoletIcon), findsWidgets);
    expect(find.byType(PixelArbreIcon), findsWidgets);

    // Verify non-GPS indicator pill
    expect(find.text('1 sense GPS'), findsOneWidget);

    // 2 markers should be rendered
    expect(find.byType(JournalMapMarker), findsNWidgets(2));
    expect(find.byKey(const Key('map_marker_sighting-mushroom-1')),
        findsOneWidget);
    expect(find.byKey(const Key('map_marker_sighting-tree-1')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Category filters switch marker visibility', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [mushroomSighting, treeSighting],
    ));
    await tester.pumpAndSettle();

    expect(find.byType(JournalMapMarker), findsNWidgets(2));

    // Tap Bolets filter
    await tester.tap(find.byKey(const Key('map_filter_bolets')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('map_marker_sighting-mushroom-1')),
        findsOneWidget);
    expect(find.byKey(const Key('map_marker_sighting-tree-1')), findsNothing);

    // Tap Arbres filter
    await tester.tap(find.byKey(const Key('map_filter_arbres')));
    await tester.pumpAndSettle();

    expect(
        find.byKey(const Key('map_marker_sighting-mushroom-1')), findsNothing);
    expect(find.byKey(const Key('map_marker_sighting-tree-1')), findsOneWidget);

    // Tap Tots filter
    await tester.tap(find.byKey(const Key('map_filter_tots')));
    await tester.pumpAndSettle();

    expect(find.byType(JournalMapMarker), findsNWidgets(2));

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'Tapping a marker opens Inspection HUD with species details and coordinates',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [mushroomSighting, treeSighting],
    ));
    await tester.pumpAndSettle();

    // Inspection HUD should initially be hidden
    expect(find.byKey(const Key('hud_view_detail_button')), findsNothing);

    // Tap mushroom marker
    await tester.tap(find.byKey(const Key('map_marker_sighting-mushroom-1')));
    await tester.pumpAndSettle();

    // HUD should now be visible
    expect(find.byKey(const Key('hud_view_detail_button')), findsOneWidget);
    expect(find.text('BOLET'), findsOneWidget);
    expect(find.text('Rovelló'), findsOneWidget);
    expect(find.text('94%'), findsWidgets);
    expect(find.textContaining('42.18° N'), findsOneWidget);
    expect(find.textContaining('850 m'), findsOneWidget);

    // Dismiss HUD with X button
    await tester.tap(find.byKey(const Key('hud_dismiss_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hud_view_detail_button')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'Tapping "Veure Detall" from HUD opens AvistamentDetailSheet modal',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [treeSighting],
    ));
    await tester.pumpAndSettle();

    // Tap tree marker
    await tester.tap(find.byKey(const Key('map_marker_sighting-tree-1')));
    await tester.pumpAndSettle();

    expect(find.text('ARBRE'), findsOneWidget);
    expect(find.text('Pi roig'), findsOneWidget);
    expect(find.text('88%'), findsWidgets);

    // Tap "Veure Detall"
    await tester.tap(find.byKey(const Key('hud_view_detail_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Sighting Detail Sheet should open
    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Reset zoom button can be triggered without errors',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      avistaments: [mushroomSighting],
    ));
    await tester.pumpAndSettle();

    final resetButton = find.byKey(const Key('map_reset_zoom_button'));
    expect(resetButton, findsOneWidget);

    await tester.tap(resetButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
