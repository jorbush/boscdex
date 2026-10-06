import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/presentation/journal/journal_provider.dart';
import 'package:boscdex/presentation/settings/settings_screen.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsScreen Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'disclaimerAccepted': true,
        'hapticFeedbackEnabled': true,
        'toxicComparisonViewCount': 0,
        'visitedArbres': <String>[],
      });
      prefs = await SharedPreferences.getInstance();
    });

    Widget createWidgetUnderTest({
      int discoveryCount = 12,
      List<dynamic> avistaments = const [],
    }) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          discoveryCountProvider
              .overrideWith((ref) => Stream.value(discoveryCount)),
          avistamentsProvider
              .overrideWith((ref) => Stream.value(avistaments.cast())),
          totalBoletsCountProvider.overrideWithValue(22),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      );
    }

    testWidgets('Renders SettingsScreen identity, sections, and stats',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest(discoveryCount: 12));
      await tester.pumpAndSettle();

      // 1. Verify AppBar and App Identity
      expect(find.text('Configuració'), findsOneWidget);
      expect(find.text('Boscdex'), findsOneWidget);
      expect(find.text('v1.0.0'), findsOneWidget);
      expect(find.text('100% Offline'), findsOneWidget);

      // 2. Verify Section Headers
      expect(find.text('PREFERÈNCIES DE L\'APLICACIÓ'), findsOneWidget);
      expect(find.text('SEGURETAT I AVÍS LEGAL'), findsOneWidget);
      expect(find.text('DADES I MOTOR IA LOCAL'), findsOneWidget);
      expect(find.text('SOBRE BOSCDEX'), findsOneWidget);

      // 3. Verify Switches for Sound Effects and Haptic Feedback
      expect(find.text('Efectes de so retro 8-bit'), findsOneWidget);
      expect(find.text('Resposta hàptica (Vibració)'), findsOneWidget);
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(2));
      expect(tester.widgetList<Switch>(switches).every((s) => s.value), isTrue);

      // Toggle first switch (sound)
      await tester.tap(switches.first);
      await tester.pumpAndSettle();
      expect(tester.widgetList<Switch>(switches).first.value, isFalse);

      // 4. Verify Safety & AI Engine details
      expect(find.text('Avís legal i descàrrec'), findsOneWidget);
      expect(find.text('Filtre de certesa IA (70%)'), findsOneWidget);
      expect(find.text('Xarxa Neuronal On-Device'), findsOneWidget);
      expect(find.text('Catàleg Relacional SQLite'), findsOneWidget);
      expect(find.textContaining('12 / 22 bolets catalogats'), findsOneWidget);
      expect(find.text('Compromís de Privacitat'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('Navigation: opens SettingsScreen and pops back',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/boscdex',
        routes: [
          GoRoute(
            path: '/boscdex',
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text('Boscdex Home'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    tooltip: 'Configuració',
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
              body: const Text('Boscdex Content'),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            discoveryCountProvider.overrideWith((ref) => Stream.value(5)),
            avistamentsProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify on initial route
      expect(find.text('Boscdex Home'), findsOneWidget);

      // Find Settings IconButton and tap
      final settingsButton = find.byTooltip('Configuració');
      expect(settingsButton, findsOneWidget);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify SettingsScreen is active
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Configuració'), findsOneWidget);

      // Tap back button in SettingsScreen AppBar
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify popped back to Boscdex Home
      expect(find.byType(SettingsScreen), findsNothing);
      expect(find.text('Boscdex Home'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets('Tapping legal disclaimer navigates to /disclaimer',
        (tester) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/disclaimer',
            builder: (context, state) {
              navigatedPath = '/disclaimer';
              return const Scaffold(body: Text('Disclaimer Page'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            discoveryCountProvider.overrideWith((ref) => Stream.value(0)),
            avistamentsProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find disclaimer tile
      final disclaimerTile = find.text('Avís legal i descàrrec');
      expect(disclaimerTile, findsOneWidget);

      await tester.tap(disclaimerTile);
      await tester.pumpAndSettle();

      expect(navigatedPath, '/disclaimer');
      expect(find.text('Disclaimer Page'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}
