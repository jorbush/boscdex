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
}
