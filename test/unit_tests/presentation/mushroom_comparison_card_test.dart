import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/reference_photo_service.dart';
import 'package:boscdex/presentation/shared/mushroom_comparison_card.dart';
import 'package:boscdex/presentation/shared/photo_zoom_dialog.dart';

void main() {
  group('MushroomComparisonCard Widget Tests', () {
    late ReferencePhotoService photoService;

    const rovello = Bolet(
      id: 'lactarius_deliciosus',
      catalanName: 'Rovelló / Pinetell',
      scientificName: 'Lactarius deliciosus',
      family: 'Russulaceae',
      rarityTier: 'comu',
      edibility: 'excellent',
      fruitingSeason: '[9,10,11]',
      altitudeMin: 400,
      altitudeMax: 1800,
      capDescription: 'Ataronjat concèntric',
      gillsDescription: 'Ataronjades',
      stemDescription: 'Cilíndric',
      latexDescription: 'Taronja',
      safetyNotes: null,
      dexNumber: 1,
      imageAssetPath: 'assets/images/mushrooms/lactarius_deliciosus.png',
      silhouetteAssetPath: null,
    );

    const falsRovello = Bolet(
      id: 'lactarius_chrysorrheus',
      catalanName: 'Fals rovelló / Lleterola de llet groga',
      scientificName: 'Lactarius chrysorrheus',
      family: 'Russulaceae',
      rarityTier: 'comu',
      edibility: 'toxic',
      fruitingSeason: '[9,10,11]',
      altitudeMin: 200,
      altitudeMax: 1500,
      capDescription: 'Grogós ocraci',
      gillsDescription: 'Blanquinoses',
      stemDescription: 'Clar',
      latexDescription: 'Blanc que vira a groc sofre',
      safetyNotes: 'Tòxic gastrointestinal',
      dexNumber: 36,
      imageAssetPath: 'assets/images/mushrooms/lactarius_chrysorrheus.png',
      silhouetteAssetPath: null,
    );

    setUp(() {
      photoService = ReferencePhotoService();
      photoService.setAttributionsForTesting({
        'lactarius_deliciosus': const ReferencePhotoAttribution(
          speciesId: 'lactarius_deliciosus',
          scientificName: 'Lactarius deliciosus',
          catalanName: 'Rovelló / Pinetell',
          author: 'Fabian Brambach',
          licenseCode: 'cc-by',
          licenseName: 'CC BY 4.0',
          attributionText: '(c) Fabian Brambach, CC BY',
          sourceUrl: 'https://inaturalist.org/obs/1',
          assetPath: 'assets/images/reference/lactarius_deliciosus.jpg',
        ),
        'lactarius_chrysorrheus': const ReferencePhotoAttribution(
          speciesId: 'lactarius_chrysorrheus',
          scientificName: 'Lactarius chrysorrheus',
          catalanName: 'Lleterola de llet groga',
          author: 'Naturalist X',
          licenseCode: 'cc-by-sa',
          licenseName: 'CC BY-SA 4.0',
          attributionText: '(c) Naturalist X, CC BY-SA',
          sourceUrl: 'https://inaturalist.org/obs/2',
          assetPath: 'assets/images/reference/lactarius_chrysorrheus.jpg',
        ),
      });
    });

    Widget createWidgetUnderTest({
      Uint8List? userImageBytes,
      List<Bolet> lookalikes = const [],
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ca'),
          Locale('es'),
          Locale('en'),
        ],
        locale: const Locale('ca'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: MushroomComparisonCard(
              userImageBytes: userImageBytes,
              topCandidate: rovello,
              lookalikes: lookalikes,
              referencePhotoService: photoService,
            ),
          ),
        ),
      );
    }

    testWidgets(
        'Renders comparison card with reference photo and author attribution',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Comparativa fotogràfica'), findsOneWidget);
      expect(find.text('Referència botànica'), findsOneWidget);
      expect(find.textContaining('Fabian Brambach'), findsOneWidget);
      expect(find.textContaining('CC BY 4.0'), findsOneWidget);
    });

    testWidgets('Renders user capture section when userImageBytes is provided',
        (tester) async {
      final fakeBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      await tester.pumpWidget(createWidgetUnderTest(userImageBytes: fakeBytes));
      await tester.pumpAndSettle();

      expect(find.text('La teva captura'), findsOneWidget);
      expect(find.text('Referència botànica'), findsOneWidget);
    });

    testWidgets(
        'Tapping toxic lookalike chip switches to lookalike reference photo',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        lookalikes: [falsRovello],
      ));
      await tester.pumpAndSettle();

      // Lookalike chip should be present
      expect(find.textContaining('Lleterola de llet groga'), findsOneWidget);
      expect(find.text('Comparativa fotogràfica'), findsOneWidget);

      // Tap lookalike chip
      await tester.tap(find.textContaining('Lleterola de llet groga'));
      await tester.pumpAndSettle();

      // Header should switch to danger lookalike mode
      expect(find.text('Comparant amb doble tòxic'), findsOneWidget);
      expect(find.text('PERILL'), findsOneWidget);
      expect(find.text('Doble tòxic'), findsOneWidget);
      expect(find.textContaining('Naturalist X'), findsOneWidget);
    });

    testWidgets('PhotoZoomDialog shows zoom modal on tap', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => PhotoZoomDialog.show(
                context: context,
                assetPath: 'assets/images/reference/lactarius_deliciosus.jpg',
                title: 'Rovelló',
                subtitle: 'Lactarius deliciosus',
                attribution: 'Fabian Brambach (CC BY 4.0)',
              ),
              child: const Text('Open Zoom'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Open Zoom'));
      await tester.pumpAndSettle();

      expect(find.text('Rovelló'), findsOneWidget);
      expect(find.text('Lactarius deliciosus'), findsOneWidget);
      expect(find.textContaining('Fabian Brambach'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });
  });
}
