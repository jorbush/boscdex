import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/presentation/shared/pixel_icons.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PixelIcons Widget Tests', () {
    testWidgets('PixelBoletIcon renders asset with crisp FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelBoletIcon(size: 24),
          ),
        ),
      );

      expect(find.byType(PixelBoletIcon), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.boletPath));
      expect(image.width, equals(24));
      expect(image.height, equals(24));
      expect(image.filterQuality, equals(FilterQuality.none));
    });

    testWidgets('PixelArbreIcon renders asset with crisp FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelArbreIcon(size: 20),
          ),
        ),
      );

      expect(find.byType(PixelArbreIcon), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.arbrePath));
      expect(image.width, equals(20));
      expect(image.height, equals(20));
      expect(image.filterQuality, equals(FilterQuality.none));
    });

    testWidgets('PixelTrophyIcon renders asset with crisp FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelTrophyIcon(size: 28),
          ),
        ),
      );

      expect(find.byType(PixelTrophyIcon), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.trophyPath));
      expect(image.width, equals(28));
      expect(image.height, equals(28));
      expect(image.filterQuality, equals(FilterQuality.none));
    });

    testWidgets(
        'PixelZonePinIcon renders active and inactive variants with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                PixelZonePinIcon(isActive: true, size: 16),
                PixelZonePinIcon(isActive: false, size: 16),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(PixelZonePinIcon), findsNWidgets(2));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, equals(2));

      final activeAsset = images[0].image as AssetImage;
      expect(activeAsset.assetName, equals(PixelIcons.pinActivePath));
      expect(images[0].filterQuality, equals(FilterQuality.none));

      final inactiveAsset = images[1].image as AssetImage;
      expect(inactiveAsset.assetName, equals(PixelIcons.pinInactivePath));
      expect(images[1].filterQuality, equals(FilterQuality.none));
    });

    testWidgets(
        'PixelCompassIcon renders compass asset with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelCompassIcon(size: 18),
          ),
        ),
      );

      expect(find.byType(PixelCompassIcon), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.compassPath));
      expect(image.width, equals(18));
      expect(image.height, equals(18));
      expect(image.filterQuality, equals(FilterQuality.none));
    });

    testWidgets(
        'PixelDexIcon renders active and inactive states with ColorFiltered filter',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                PixelDexIcon(isActive: true, size: 26),
                PixelDexIcon(isActive: false, size: 24),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(PixelDexIcon), findsNWidgets(2));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, equals(2));

      final activeAsset = images[0].image as AssetImage;
      expect(activeAsset.assetName, equals(PixelIcons.dexPath));
      expect(images[0].filterQuality, equals(FilterQuality.none));
      expect(images[0].width, equals(26));

      // Inactive icon is wrapped in ColorFiltered
      expect(find.byType(ColorFiltered), findsOneWidget);
      final inactiveAsset = images[1].image as AssetImage;
      expect(inactiveAsset.assetName, equals(PixelIcons.dexPath));
      expect(images[1].width, equals(24));
    });

    testWidgets(
        'PixelCameraIcon renders active and inactive states with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                PixelCameraIcon(isActive: true, size: 26),
                PixelCameraIcon(isActive: false, size: 24),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(PixelCameraIcon), findsNWidgets(2));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, equals(2));

      final activeAsset = images[0].image as AssetImage;
      expect(activeAsset.assetName, equals(PixelIcons.cameraPath));
      expect(images[0].filterQuality, equals(FilterQuality.none));
      expect(images[0].width, equals(26));

      expect(find.byType(ColorFiltered), findsOneWidget);
      final inactiveAsset = images[1].image as AssetImage;
      expect(inactiveAsset.assetName, equals(PixelIcons.cameraPath));
      expect(images[1].width, equals(24));
    });

    testWidgets(
        'PixelJournalIcon renders active and inactive states with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                PixelJournalIcon(isActive: true, size: 26),
                PixelJournalIcon(isActive: false, size: 24),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(PixelJournalIcon), findsNWidgets(2));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, equals(2));

      final activeAsset = images[0].image as AssetImage;
      expect(activeAsset.assetName, equals(PixelIcons.journalPath));
      expect(images[0].filterQuality, equals(FilterQuality.none));
      expect(images[0].width, equals(26));

      expect(find.byType(ColorFiltered), findsOneWidget);
      final inactiveAsset = images[1].image as AssetImage;
      expect(inactiveAsset.assetName, equals(PixelIcons.journalPath));
      expect(images[1].width, equals(24));
    });

    testWidgets('PixelMapIcon renders map asset with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelMapIcon(size: 20),
          ),
        ),
      );

      expect(find.byType(PixelMapIcon), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.mapPath));
      expect(image.width, equals(20));
      expect(image.height, equals(20));
      expect(image.filterQuality, equals(FilterQuality.none));
    });

    testWidgets(
        'PixelListIcon renders scroll list asset with FilterQuality.none',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PixelListIcon(size: 20),
          ),
        ),
      );

      expect(find.byType(PixelListIcon), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(PixelIcons.listPath));
      expect(image.width, equals(20));
      expect(image.height, equals(20));
      expect(image.filterQuality, equals(FilterQuality.none));
    });
  });
}
