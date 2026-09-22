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
  });
}
