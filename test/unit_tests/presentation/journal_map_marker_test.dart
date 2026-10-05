import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/journal/journal_map_marker.dart';
import 'package:boscdex/presentation/shared/pixel_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('JournalMapMarker renders mushroom with specific specimen sprite',
      (tester) async {
    final mushroomSighting = Avistament(
      id: 'm1',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 10, 1),
      confidenceScore: 0.95,
    );

    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalMapMarker(
            avistament: mushroomSighting,
            displayName: 'Rovelló',
            isTree: false,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pump();

    // Verify Image.asset points to specific mushroom sprite
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect(
      (imageWidget.image as AssetImage).assetName,
      'assets/images/mushrooms/lactarius_deliciosus.png',
    );

    // Verify confidence pill
    expect(find.text('95%'), findsOneWidget);

    // Verify tap callback
    await tester.tap(find.byType(JournalMapMarker));
    expect(tapped, isTrue);
  });

  testWidgets('JournalMapMarker renders tree with specific specimen sprite',
      (tester) async {
    final treeSighting = Avistament(
      id: 't1',
      arbreId: 'pinus_sylvestris',
      timestamp: DateTime(2026, 10, 1),
      confidenceScore: 0.82,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalMapMarker(
            avistament: treeSighting,
            displayName: 'Pi roig',
            isTree: true,
            isSelected: false,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect(
      (imageWidget.image as AssetImage).assetName,
      'assets/images/trees/pinus_sylvestris.png',
    );

    expect(find.text('82%'), findsOneWidget);
  });

  testWidgets('JournalMapMarker renders selected state with halo',
      (tester) async {
    final mushroomSighting = Avistament(
      id: 'm1',
      boletId: 'boletus_edulis',
      timestamp: DateTime(2026, 10, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalMapMarker(
            avistament: mushroomSighting,
            displayName: 'Cep',
            isTree: false,
            isSelected: true,
            pulseValue: 0.5,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    // In selected state, halo container is rendered
    expect(find.byType(JournalMapMarker), findsOneWidget);
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(
      (imageWidget.image as AssetImage).assetName,
      'assets/images/mushrooms/boletus_edulis.png',
    );
  });

  testWidgets(
      'JournalMapMarker falls back to generic pixel icon when id is null',
      (tester) async {
    final sightingWithoutId = Avistament(
      id: 'unknown1',
      timestamp: DateTime(2026, 10, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalMapMarker(
            avistament: sightingWithoutId,
            displayName: 'Desconegut',
            isTree: false,
            isSelected: false,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PixelBoletIcon), findsOneWidget);
  });
}
