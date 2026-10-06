import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';
import 'package:boscdex/domain/models/edibilitat.dart';
import 'package:boscdex/domain/models/raritat_tier.dart';
import 'package:boscdex/presentation/shared/offline_indicator.dart';
import 'package:boscdex/presentation/shared/edibility_badge.dart';
import 'package:boscdex/presentation/shared/safety_alert_box.dart';
import 'package:boscdex/presentation/shared/rarity_border.dart';
import 'package:boscdex/presentation/splash/splash_screen.dart';
import 'package:boscdex/providers/preferences_provider.dart';

void main() {
  testWidgets('OfflineIndicator renders offline pill',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OfflineIndicator(),
        ),
      ),
    );

    expect(find.text('100% Offline'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  });

  testWidgets(
      'EdibilityBadge renders correct Catalan label and icon with high-contrast colors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EdibilityBadge(edibilitat: Edibilitat.excellent),
        ),
      ),
    );

    expect(find.text('Comestible excel·lent'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, equals(Edibilitat.excellent.badgeBackgroundColor));
    expect(decoration.color!.alpha, equals(255),
        reason: 'Background must be 100% opaque');

    final text = tester.widget<Text>(find.text('Comestible excel·lent'));
    expect(text.style?.color, equals(RetroColors.ink));

    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(icon.color, equals(Edibilitat.excellent.badgeIconColor));
  });

  testWidgets(
      'EdibilityBadge renders icon only when iconOnly is true with opaque background',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EdibilityBadge(
            edibilitat: Edibilitat.comestible,
            iconOnly: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.restaurant), findsOneWidget);
    expect(find.text('Comestible'), findsNothing);

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(
        decoration.color, equals(Edibilitat.comestible.badgeBackgroundColor));
    expect(decoration.color!.alpha, equals(255));

    final icon = tester.widget<Icon>(find.byIcon(Icons.restaurant));
    expect(icon.color, equals(Edibilitat.comestible.badgeIconColor));
  });

  testWidgets(
      'SafetyAlertBox renders warning title and species and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SafetyAlertBox(
            confusionSpecies: 'Amanita phalloides (Farinera borda)',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('ALERTA DE CONFUSIÓ PERILLOSA'), findsOneWidget);
    expect(
        find.text(
            'Es pot confondre fàcilment amb: Amanita phalloides (Farinera borda)'),
        findsOneWidget);

    await tester.tap(find.byType(SafetyAlertBox));
    expect(tapped, isTrue);
  });

  testWidgets('RarityBorder renders without error for all rarity tiers',
      (WidgetTester tester) async {
    for (final tier in RaritatTier.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RarityBorder(
              tier: tier,
              borderWidth: 8.0,
              borderRadius: BorderRadius.circular(4.0),
              child: const Text('Mushroom Card'),
            ),
          ),
        ),
      );

      expect(find.text('Mushroom Card'), findsOneWidget);
    }
  });

  testWidgets('RetroProgressBar clamps progress cleanly and handles NaN',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: const [
              RetroProgressBar(progress: 0.5, totalSegments: 6),
              RetroProgressBar(progress: 1.5, totalSegments: 6),
              RetroProgressBar(progress: double.nan, totalSegments: 6),
              RetroProgressBar(progress: 0.0, totalSegments: 1),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(RetroProgressBar), findsNWidgets(4));
  });

  testWidgets(
      'SplashScreen renders retro game title and cancels timer on dispose',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'disclaimerAccepted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    expect(find.text('Boscdex'), findsOneWidget);
    expect(find.text('★ CARREGANT EL BOSC ★'), findsOneWidget);

    // Unmount early to verify timer cancellation in dispose() doesn't throw
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
}
