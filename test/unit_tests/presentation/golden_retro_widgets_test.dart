import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';
import 'package:boscdex/domain/models/edibilitat.dart';
import 'package:boscdex/domain/models/raritat_tier.dart';
import 'package:boscdex/presentation/shared/edibility_badge.dart';
import 'package:boscdex/presentation/shared/offline_indicator.dart';
import 'package:boscdex/presentation/shared/rarity_border.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Retro Pixel-Art Golden Snapshot Tests', () {
    testWidgets('Edibility badges golden matrix', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(340, 380));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final widget = MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          backgroundColor: const Color(0xFFF7F5EE),
          body: Center(
            child: RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFF7F5EE),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final e in Edibilitat.values) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            EdibilityBadge(edibilitat: e, iconOnly: true),
                            const SizedBox(width: 8),
                            EdibilityBadge(edibilitat: e),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      await expectLater(
        find.byType(RepaintBoundary).last,
        matchesGoldenFile('goldens/edibility_badges_matrix.png'),
      );
    });

    testWidgets('Rarity borders golden matrix', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 440));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final widget = MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF1E2822),
          body: Center(
            child: RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1E2822),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final tier in RaritatTier.values) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RarityBorder(
                          tier: tier,
                          child: Container(
                            width: 150,
                            height: 38,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              tier.label,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      await expectLater(
        find.byType(RepaintBoundary).last,
        matchesGoldenFile('goldens/rarity_borders_matrix.png'),
      );
    });

    testWidgets('Retro progress bar golden states',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 240));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final widget = MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF7F5EE),
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 200,
                      child: RetroProgressBar(
                          progress: 0.0, height: 10, totalSegments: 6),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 200,
                      child: RetroProgressBar(
                          progress: 0.33, height: 10, totalSegments: 6),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 200,
                      child: RetroProgressBar(
                          progress: 0.67, height: 10, totalSegments: 6),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 200,
                      child: RetroProgressBar(
                          progress: 1.0, height: 10, totalSegments: 6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      await expectLater(
        find.byType(RepaintBoundary).last,
        matchesGoldenFile('goldens/retro_progress_bar_states.png'),
      );
    });

    testWidgets('Offline indicator golden pill', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(240, 160));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const widget = MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFFF7F5EE),
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: OfflineIndicator(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      await expectLater(
        find.byType(RepaintBoundary).last,
        matchesGoldenFile('goldens/offline_indicator_pill.png'),
      );
    });
  });
}
