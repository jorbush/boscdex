import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/reference_photo_service.dart';
import 'package:boscdex/presentation/shared/tree_comparison_card.dart';
import 'package:boscdex/presentation/shared/photo_zoom_dialog.dart';

void main() {
  group('TreeComparisonCard Widget Tests', () {
    late ReferencePhotoService photoService;

    const piRoig = Arbre(
      id: 'pinus_sylvestris',
      catalanName: 'Pi roig',
      scientificName: 'Pinus sylvestris',
      leafType: 'Agulla',
      barkDescription: 'Tronc superior ataronjat',
      typicalSoil: 'Silici o àcid',
      imageAssetPath: 'assets/images/trees/pinus_sylvestris.png',
    );

    setUp(() {
      photoService = ReferencePhotoService();
      photoService.setAttributionsForTesting({
        'pinus_sylvestris': const ReferencePhotoAttribution(
          speciesId: 'pinus_sylvestris',
          scientificName: 'Pinus sylvestris',
          catalanName: 'Pi roig',
          author: 'Dominicus Johannes Bergsma',
          licenseCode: 'cc-by-sa',
          licenseName: 'CC BY-SA 4.0',
          attributionText: '(c) Dominicus Johannes Bergsma, CC BY-SA 4.0',
          sourceUrl:
              'https://commons.wikimedia.org/wiki/File:Pinus_sylvestris.jpg',
          assetPath: 'assets/images/reference/pinus_sylvestris.jpg',
        ),
      });
    });

    Widget createTestWidget({
      Uint8List? userImageBytes,
      Locale locale = const Locale('ca'),
    }) {
      return MaterialApp(
        locale: locale,
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
        home: Scaffold(
          body: SingleChildScrollView(
            child: TreeComparisonCard(
              userImageBytes: userImageBytes,
              tree: piRoig,
              referencePhotoService: photoService,
            ),
          ),
        ),
      );
    }

    testWidgets(
        'renders side-by-side comparison when userImageBytes is provided',
        (tester) async {
      final mockBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);

      await tester.pumpWidget(createTestWidget(userImageBytes: mockBytes));
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Comparativa fotogràfica'), findsOneWidget);

      // User capture column
      expect(find.text('La teva captura'), findsOneWidget);

      // Reference photo column
      expect(find.text('Referència botànica'), findsOneWidget);

      // Attribution banner
      expect(find.textContaining('Dominicus Johannes Bergsma'), findsOneWidget);
    });

    testWidgets('renders only reference photo when userImageBytes is null',
        (tester) async {
      await tester.pumpWidget(createTestWidget(userImageBytes: null));
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Comparativa fotogràfica'), findsOneWidget);

      // User capture should NOT be present
      expect(find.text('La teva captura'), findsNothing);

      // Botanical reference column is present
      expect(find.text('Referència botànica'), findsOneWidget);
      expect(find.textContaining('Dominicus Johannes Bergsma'), findsOneWidget);
    });

    testWidgets('tapping reference photo opens PhotoZoomDialog',
        (tester) async {
      await tester.pumpWidget(createTestWidget(userImageBytes: null));
      await tester.pumpAndSettle();

      final zoomGesture = find.byType(GestureDetector).first;
      await tester.tap(zoomGesture);
      await tester.pumpAndSettle();

      expect(find.byType(PhotoZoomDialog), findsOneWidget);
      expect(find.text('Pi roig'), findsWidgets);
      expect(find.text('Pinus sylvestris'), findsOneWidget);
    });

    testWidgets('renders properly localized labels in Spanish and English',
        (tester) async {
      // Spanish
      await tester.pumpWidget(createTestWidget(
        userImageBytes: Uint8List.fromList([1, 2, 3]),
        locale: const Locale('es'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Comparativa fotográfica'), findsOneWidget);
      expect(find.text('Tu captura'), findsOneWidget);
      expect(find.text('Referencia botánica'), findsOneWidget);

      // English
      await tester.pumpWidget(createTestWidget(
        userImageBytes: Uint8List.fromList([1, 2, 3]),
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Photo comparison'), findsOneWidget);
      expect(find.text('Your capture'), findsOneWidget);
      expect(find.text('Botanical reference'), findsOneWidget);
    });
  });
}
