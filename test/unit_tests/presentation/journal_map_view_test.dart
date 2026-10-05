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

  group('Clustering Tests', () {
    final clusterSighting1 = Avistament(
      id: 'sighting-cluster-1',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 10, 1, 10, 0),
      latitude: 42.18,
      longitude: 1.85,
      altitude: 850.0,
      confidenceScore: 0.95,
      notes: 'Primer rovelló trobat',
      photoPath: null,
    );

    final clusterSighting2 = Avistament(
      id: 'sighting-cluster-2',
      boletId: 'boletus_edulis',
      timestamp: DateTime(2026, 10, 1, 10, 15),
      latitude: 42.1802,
      longitude: 1.8503,
      altitude: 855.0,
      confidenceScore: 0.89,
      notes: 'Un cep a tocar del rovelló!',
      photoPath: null,
    );

    final clusterSighting3 = Avistament(
      id: 'sighting-cluster-3',
      arbreId: 'pinus_sylvestris',
      timestamp: DateTime(2026, 10, 1, 10, 20),
      latitude: 42.1801,
      longitude: 1.8501,
      altitude: 852.0,
      confidenceScore: 0.92,
      notes: 'El pi amfitrió',
      photoPath: null,
    );

    testWidgets(
        'Clusters overlapping sightings into a single marker with count badge',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        avistaments: [clusterSighting1, clusterSighting2, clusterSighting3],
      ));
      await tester.pumpAndSettle();

      // Only 1 marker should be rendered on the map, not 3 separate pins
      expect(find.byType(JournalMapMarker), findsOneWidget);

      // Verify the arcade gold counter badge displays x3
      expect(
          find.byKey(const Key('marker_cluster_count_badge')), findsOneWidget);
      expect(find.text('x3'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets(
        'Tapping clustered marker opens HUD with pager, chip selector, and cycling behavior',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        avistaments: [clusterSighting1, clusterSighting2, clusterSighting3],
      ));
      await tester.pumpAndSettle();

      // Tap the marker to open the inspection HUD
      await tester.tap(find.byType(JournalMapMarker));
      await tester.pumpAndSettle();

      // Verify cluster pager header and chip items
      expect(find.text('Troballa 1 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Rovelló'), findsOneWidget);
      expect(find.byKey(const Key('hud_prev_sighting_button')), findsOneWidget);
      expect(find.byKey(const Key('hud_next_sighting_button')), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_0')), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_1')), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_2')), findsOneWidget);

      // Tap NEXT button -> cycles to item 2 (Cep)
      await tester.tap(find.byKey(const Key('hud_next_sighting_button')));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 2 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Cep'), findsOneWidget);

      // Tap chip 2 directly -> switches to item 3 (Pi roig)
      await tester.tap(find.byKey(const Key('hud_cluster_specimen_chip_2')));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 3 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.text('ARBRE'), findsOneWidget);

      // Tap NEXT button from last item -> wraps back to item 1 (Rovelló)
      await tester.tap(find.byKey(const Key('hud_next_sighting_button')));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 1 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Rovelló'), findsOneWidget);

      // Tap PREV button from first item -> wraps backwards to item 3 (Pi roig)
      await tester.tap(find.byKey(const Key('hud_prev_sighting_button')));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 3 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Pi roig'), findsOneWidget);

      // Tapping the map marker pin itself cycles forward to item 1
      await tester.tap(find.byType(JournalMapMarker));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 1 de 3 en aquest punt'), findsOneWidget);
      expect(find.text('Rovelló'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets(
        'Filtering dynamically updates cluster count and specimen navigation',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        avistaments: [clusterSighting1, clusterSighting2, clusterSighting3],
      ));
      await tester.pumpAndSettle();

      expect(find.text('x3'), findsOneWidget);

      // Filter by Bolets only (2 mushrooms in cluster)
      await tester.tap(find.byKey(const Key('map_filter_bolets')));
      await tester.pumpAndSettle();

      expect(find.text('x2'), findsOneWidget);

      // Tap marker -> HUD displays 2 items
      await tester.tap(find.byType(JournalMapMarker));
      await tester.pumpAndSettle();

      expect(find.text('Troballa 1 de 2 en aquest punt'), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_0')), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_1')), findsOneWidget);
      expect(
          find.byKey(const Key('hud_cluster_specimen_chip_2')), findsNothing);

      // Filter by Arbres only (1 tree in location)
      await tester.tap(find.byKey(const Key('map_filter_arbres')));
      await tester.pumpAndSettle();

      // No cluster badge when itemCount == 1
      expect(find.byKey(const Key('marker_cluster_count_badge')), findsNothing);

      // Tap tree marker -> standard single inspection HUD without cluster pager
      await tester.tap(find.byType(JournalMapMarker));
      await tester.pumpAndSettle();

      expect(find.text('ARBRE'), findsOneWidget);
      expect(find.text('Pi roig'), findsOneWidget);
      expect(find.byKey(const Key('hud_prev_sighting_button')), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets(
        'Viewing details from clustered HUD opens detail sheet for the active specimen',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        avistaments: [clusterSighting1, clusterSighting2],
      ));
      await tester.pumpAndSettle();

      // Tap marker and switch to specimen 2 (Cep)
      await tester.tap(find.byType(JournalMapMarker));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('hud_next_sighting_button')));
      await tester.pumpAndSettle();

      expect(find.text('Cep'), findsOneWidget);

      // Tap "Veure Detall"
      await tester.tap(find.byKey(const Key('hud_view_detail_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
      expect(find.text('Cep'), findsWidgets);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}
