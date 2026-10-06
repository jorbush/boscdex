import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/presentation/detail/season_indicator.dart';
import 'package:boscdex/presentation/detail/morphology_section.dart';
import 'package:boscdex/presentation/detail/toxic_twin_alert.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

    testWidgets(
        'MorphologySection renders localized titles in Spanish and English',
        (WidgetTester tester) async {
      // 1. Spanish
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: MorphologySection(
                cap: 'Convexo',
                gills: 'Apretadas',
                stem: 'Robusto',
                latex: 'Látex blanco',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Morfología'), findsOneWidget);
      expect(find.text('Sombrero'), findsOneWidget);
      expect(find.text('Láminas'), findsOneWidget);
      expect(find.text('Pie'), findsOneWidget);
      expect(find.text('Látex'), findsOneWidget);

      // 2. English
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: MorphologySection(
                cap: 'Convex',
                gills: 'Crowded',
                stem: 'Sturdy',
                latex: 'White latex',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Morphology'), findsOneWidget);
      expect(find.text('Cap'), findsOneWidget);
      expect(find.text('Gills'), findsOneWidget);
      expect(find.text('Stem'), findsOneWidget);
      expect(find.text('Latex'), findsOneWidget);
    });

    testWidgets(
        'SeasonIndicator renders localized month names in Spanish and English',
        (WidgetTester tester) async {
      // 1. Spanish
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SeasonIndicator(fruitingMonths: [9, 10, 11]),
          ),
        ),
      );

      expect(find.text('Temporada'), findsOneWidget);
      expect(find.text('Ene'), findsOneWidget);
      expect(find.text('Sep'), findsOneWidget);
      expect(find.text('Dic'), findsOneWidget);

      // 2. English
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ca'),
            Locale('es'),
            Locale('en'),
          ],
          home: Scaffold(
            body: SeasonIndicator(fruitingMonths: [9, 10, 11]),
          ),
        ),
      );

      expect(find.text('Season'), findsOneWidget);
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Sep'), findsOneWidget);
      expect(find.text('Dec'), findsOneWidget);
    });

    testWidgets(
        'ToxicTwinAlert renders lookalike name, notes, action prompt, and triggers onTap when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToxicTwinAlert(
              lookalikeName: 'Reig bord',
              comparisonNotes:
                  'El Reig bord té un barret vermell brillant amb esquames blanques.',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('ATENCIÓ: Es pot confondre amb'), findsOneWidget);
      expect(find.text('Reig bord'), findsOneWidget);
      expect(find.textContaining('barret vermell brillant'), findsOneWidget);
      expect(find.text('Veure fitxa completa a la Boscdex'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // Tap on the alert card
      await tester.tap(find.byType(ToxicTwinAlert));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets(
        'ToxicTwinAlert renders cleanly as static alert when onTap is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToxicTwinAlert(
              lookalikeName: 'Gírgola d\'olivera',
              comparisonNotes: 'Creix sobre fusta d\'olivera.',
            ),
          ),
        ),
      );

      expect(find.text('ATENCIÓ: Es pot confondre amb'), findsOneWidget);
      expect(find.text('Gírgola d\'olivera'), findsOneWidget);
      expect(find.text('Veure fitxa completa a la Boscdex'), findsNothing);
    });
  });
}
