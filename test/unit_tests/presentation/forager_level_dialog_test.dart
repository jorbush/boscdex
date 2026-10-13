import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/domain/models/forager_level.dart';
import 'package:boscdex/domain/models/insignia.dart' as domain;
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/presentation/boscdex/boscdex_screen.dart';
import 'package:boscdex/presentation/boscdex/forager_level_dialog.dart';
import 'package:boscdex/presentation/boscdex/insignies_dialog.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Forager Level & Interactive LVL Badge Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'visitedArbres': <String>[]});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets(
        'ForagerLevelDialog renders level details, progress, and roadmap',
        (WidgetTester tester) async {
      final sampleLevel = ForagerLevel.calculate(
        discoveredBolets: 2, // 200
        identifiedArbres: 1, // 75
        awardedBadges: 0,
        totalSightings: 1, // 25 -> 300 XP (Level 3: Rastrejador Silvestre)
      );

      await tester.binding.setSurfaceSize(const Size(500, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foragerLevelProvider.overrideWithValue(sampleLevel),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ForagerLevelDialog(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify header and level title
      expect(find.text('Nivell de Boletaire'), findsOneWidget);
      expect(find.text('LVL 3'), findsNWidgets(2)); // Header badge + hero card
      expect(find.text('Rastrejador Silvestre'), findsWidgets);
      expect(find.text('300 XP'), findsOneWidget);

      // Verify progress & remaining XP to Level 4 (threshold: 500 XP -> 200 XP needed)
      expect(find.text('Fonts d\'Experiència'), findsOneWidget);
      expect(find.textContaining('200 XP per al Nivell 4'), findsOneWidget);

      // Verify breakdown stats
      expect(find.text('Bolets catalogats'), findsOneWidget);
      expect(find.text('Arbres identificats'), findsOneWidget);
      expect(find.text('Insígnies assolides'), findsOneWidget);
      expect(find.text('Avistaments al diari'), findsOneWidget);
      expect(find.text('+200 XP'), findsOneWidget);
      expect(find.text('+75 XP'), findsOneWidget);
      expect(find.text('+25 XP'), findsOneWidget);

      // Verify roadmap
      expect(find.text('Escala de Rànquings'), findsOneWidget);
      expect(find.text('ACTUAL'), findsOneWidget);
      expect(find.text('Novell del Bosc'), findsOneWidget);
      expect(find.text('Mestre del Bosc'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets(
        'BoscdexScreen displays dynamic LVL badge and tapping opens dialog',
        (tester) async {
      final sampleLevel = ForagerLevel.calculate(
        discoveredBolets: 5,
        identifiedArbres: 2,
        awardedBadges: 2,
        totalSightings: 3,
      );

      await tester.binding.setSurfaceSize(const Size(500, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            foragerLevelProvider.overrideWithValue(sampleLevel),
            boscdexEntriesProvider
                .overrideWith((ref) => Stream.value(<BoscdexEntry>[])),
            arbresBoscdexProvider
                .overrideWith((ref) => Stream.value(<ArbreBoscdexEntry>[])),
            discoveryCountProvider.overrideWith((ref) => Stream.value(5)),
            visitedArbresCountProvider.overrideWithValue(2),
            totalBoletsCountProvider.overrideWithValue(22),
            boletIdsWithTreesProvider
                .overrideWith((ref) => Future.value(<String>{})),
          ],
          child: const MaterialApp(
            home: BoscdexScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // 1. Verify dynamic badge matches sample level
      final lvlBadge = find.byKey(const Key('boscdex_lvl_badge'));
      expect(lvlBadge, findsOneWidget);
      expect(find.text('LVL ${sampleLevel.level}'), findsOneWidget);

      // 2. Tap on LVL badge to trigger bottom sheet
      await tester.tap(lvlBadge);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ForagerLevelDialog), findsOneWidget);

      // Dismiss modal
      Navigator.of(tester.element(find.byType(ForagerLevelDialog))).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ForagerLevelDialog), findsNothing);

      // 3. Tap on discovered count text to trigger bottom sheet
      final discoveredText = find.byKey(const Key('boscdex_discovered_text'));
      expect(discoveredText, findsOneWidget);
      await tester.tap(discoveredText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ForagerLevelDialog), findsOneWidget);

      // Dismiss modal
      Navigator.of(tester.element(find.byType(ForagerLevelDialog))).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ForagerLevelDialog), findsNothing);

      // 4. Tap on progress bar to trigger bottom sheet
      final progressBar = find.byKey(const Key('boscdex_progress_bar'));
      expect(progressBar, findsOneWidget);
      await tester.tap(progressBar);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ForagerLevelDialog), findsOneWidget);

      // Clean up modal and unmount
      Navigator.of(tester.element(find.byType(ForagerLevelDialog))).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('InsigniesDialog renders level navigation banner',
        (tester) async {
      final sampleLevel = ForagerLevel.calculate(
        discoveredBolets: 1,
        identifiedArbres: 0,
        awardedBadges: 0,
        totalSightings: 0,
      );

      await tester.binding.setSurfaceSize(const Size(500, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foragerLevelProvider.overrideWithValue(sampleLevel),
            insigniesProvider
                .overrideWith((ref) => Future.value(<domain.Insignia>[])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 800,
                width: 400,
                child: InsigniesDialog(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final banner = find.byKey(const Key('insignies_lvl_banner'));
      expect(banner, findsOneWidget);
      expect(find.text('LVL 2'), findsOneWidget);
      expect(find.textContaining('100 XP'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets(
        'ForagerLevelDialog renders properly when player is at Max Level 10',
        (WidgetTester tester) async {
      final maxLevel = ForagerLevel.calculate(
        discoveredBolets: 22,
        identifiedArbres: 5,
        awardedBadges: 6,
        totalSightings: 50,
      );

      await tester.binding.setSurfaceSize(const Size(500, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foragerLevelProvider.overrideWithValue(maxLevel),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ForagerLevelDialog(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('LVL 10'), findsNWidgets(2));
      expect(find.text('Mestre del Bosc'), findsWidgets);
      expect(find.textContaining('Nivell màxim assolit!'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  });
}
