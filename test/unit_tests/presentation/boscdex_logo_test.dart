import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/presentation/shared/boscdex_logo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BoscdexLogo Widget Tests', () {
    testWidgets('Renders canonical logo with default attributes',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BoscdexLogo(),
          ),
        ),
      );

      expect(find.byType(BoscdexLogo), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals('assets/icons/boscdex_logo.png'));
    });

    testWidgets('Renders mascot variant when useMascot is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BoscdexLogo(useMascot: true),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals('assets/icons/boscdex_mascot.png'));
    });

    testWidgets('Applies custom size and shadow styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BoscdexLogo(
              size: 80.0,
              showBorder: true,
              borderWidth: 2.5,
              showShadow: true,
              shadowOffset: 4.0,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minWidth, equals(80.0));
      expect(container.constraints?.minHeight, equals(80.0));
    });
  });
}
