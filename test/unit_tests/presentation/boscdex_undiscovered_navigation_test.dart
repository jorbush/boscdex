import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/presentation/boscdex/boscdex_card.dart';
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets(
      'Tapping undiscovered BoscdexCard navigates to /boscdex/:id instead of showing SnackBar',
      (tester) async {
    String? navigatedPath;

    const mockBolet = Bolet(
      id: 'boletus_edulis',
      catalanName: 'Cep',
      scientificName: 'Boletus edulis',
      family: 'Boletaceae',
      rarityTier: 'poc_frequent',
      edibility: 'excellent',
      fruitingSeason: '[9,10,11]',
      dexNumber: 2,
      capDescription: 'Barret gros',
      gillsDescription: 'Porus fins',
      stemDescription: 'Peu robust',
      latexDescription: null,
      safetyNotes: null,
      imageAssetPath: null,
      silhouetteAssetPath: null,
      altitudeMin: 600,
      altitudeMax: 1800,
    );

    const undiscoveredEntry = BoscdexEntry(
      bolet: mockBolet,
      isDiscovered: false,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: SizedBox(
              width: 150,
              height: 180,
              child: BoscdexCard(entry: undiscoveredEntry),
            ),
          ),
        ),
        GoRoute(
          path: '/boscdex/:id',
          builder: (context, state) {
            navigatedPath = '/boscdex/${state.params['id']}';
            return Scaffold(
              body: Text('Detail Screen: ${state.params['id']}'),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify undiscovered card label and silhouette
    expect(find.text('#002 ???'), findsOneWidget);

    // Tap the card
    await tester.tap(find.byType(BoscdexCard));
    await tester.pumpAndSettle();

    // Verify navigation happened and no SnackBar was triggered
    expect(navigatedPath, '/boscdex/boletus_edulis');
    expect(find.text('Detail Screen: boletus_edulis'), findsOneWidget);
    expect(find.text('Encara no has descobert aquest bolet!'), findsNothing);
  });

  testWidgets(
      'Undiscovered toxic BoscdexCard reveals name and danger badge with silhouette sprite',
      (tester) async {
    String? navigatedPath;

    const mockToxicBolet = Bolet(
      id: 'amanita_phalloides',
      catalanName: 'Farinera borda',
      scientificName: 'Amanita phalloides',
      family: 'Amanitaceae',
      rarityTier: 'frequent',
      edibility: 'mortal',
      fruitingSeason: '[9,10,11]',
      dexNumber: 10,
      capDescription: 'Verdós o groguenc',
      gillsDescription: 'Làmines blanques',
      stemDescription: 'Peu blanc amb anell i volva',
      latexDescription: null,
      safetyNotes: 'Mortal fins i tot en dosis ínfimes.',
      imageAssetPath: null,
      silhouetteAssetPath: null,
      altitudeMin: 100,
      altitudeMax: 1200,
    );

    const undiscoveredToxicEntry = BoscdexEntry(
      bolet: mockToxicBolet,
      isDiscovered: false,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: SizedBox(
              width: 150,
              height: 180,
              child: BoscdexCard(entry: undiscoveredToxicEntry),
            ),
          ),
        ),
        GoRoute(
          path: '/boscdex/:id',
          builder: (context, state) {
            navigatedPath = '/boscdex/${state.params['id']}';
            return Scaffold(
              body: Text('Detail Screen: ${state.params['id']}'),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // 1. Revealed name and dex number for safety (NOT #010 ???)
    expect(find.text('#010'), findsOneWidget);
    expect(find.text('Farinera borda'), findsOneWidget);
    expect(find.text('#010 ???'), findsNothing);

    // 2. Danger badge icon (mortal: Icons.dangerous)
    expect(find.byIcon(Icons.dangerous), findsOneWidget);

    // 3. Sprite is rendered in silhouette
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColorFiltered &&
            widget.colorFilter ==
                const ColorFilter.mode(
                  Color(0xFF1E2822),
                  BlendMode.srcIn,
                ),
      ),
      findsWidgets,
    );

    // 4. Tap navigates to detail screen
    await tester.tap(find.byType(BoscdexCard));
    await tester.pumpAndSettle();

    expect(navigatedPath, '/boscdex/amanita_phalloides');
    expect(find.text('Detail Screen: amanita_phalloides'), findsOneWidget);
  });
}
