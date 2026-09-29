import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boscdex/presentation/detail/season_indicator.dart';
import 'package:boscdex/presentation/detail/morphology_section.dart';

void main() {
  group('Detail Widgets Component Tests', () {
    testWidgets(
        'SeasonIndicator highlights active months and provides accessibility label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonIndicator(fruitingMonths: [9, 10, 11]),
          ),
        ),
      );

      // Verify header and month pills render
      expect(find.text('Temporada'), findsOneWidget);
      expect(find.text('Set'), findsOneWidget);
      expect(find.text('Oct'), findsOneWidget);
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Gen'), findsOneWidget);

      // Verify semantics label
      final semanticsFinder = find.byType(Semantics);
      expect(semanticsFinder, findsWidgets);
    });

    testWidgets('SeasonIndicator handles empty season gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SeasonIndicator(fruitingMonths: []),
          ),
        ),
      );

      expect(find.text('Temporada'), findsOneWidget);
      expect(find.text('Gen'), findsOneWidget);
    });

    testWidgets('MorphologySection displays cap, gills, and stem without latex',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MorphologySection(
                cap: 'Convex a aplanat',
                gills: 'Decurrents i ataronjades',
                stem: 'Curt i robust',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Morfologia'), findsOneWidget);
      expect(find.text('Barret'), findsOneWidget);
      expect(find.text('Convex a aplanat'), findsOneWidget);
      expect(find.text('Làmines'), findsOneWidget);
      expect(find.text('Decurrents i ataronjades'), findsOneWidget);
      expect(find.text('Peu'), findsOneWidget);
      expect(find.text('Curt i robust'), findsOneWidget);
      expect(find.text('Làtex'), findsNothing);
    });

    testWidgets('MorphologySection displays latex when present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MorphologySection(
                cap: 'Color taronja amb cercles concèntrics',
                gills: 'Apretades',
                stem: 'Buit per dins',
                latex: 'Làtex color pastanaga que enverda',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Làtex'), findsOneWidget);
      expect(find.text('Làtex color pastanaga que enverda'), findsOneWidget);
    });
  });
}
