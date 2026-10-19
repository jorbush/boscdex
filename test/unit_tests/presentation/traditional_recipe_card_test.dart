import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/domain/models/culinary_recipe.dart';
import 'package:boscdex/presentation/detail/traditional_recipe_card.dart';

void main() {
  Widget buildTestWidget({
    required CulinaryRecipe recipe,
    Locale locale = const Locale('ca'),
  }) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [
        Locale('ca'),
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TraditionalRecipeCard(recipe: recipe),
          ),
        ),
      ),
    );
  }

  group('TraditionalRecipeCard Widget Tests', () {
    testWidgets('renders in collapsed state by default', (tester) async {
      final recipe = CulinaryRecipe.forSpecies('tuber_melanosporum')!;
      await tester.pumpWidget(buildTestWidget(recipe: recipe));
      await tester.pumpAndSettle();

      // Header is visible
      expect(find.text(recipe.dishNameCa), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      // Detailed preparation and wine pairing are not rendered while collapsed
      expect(find.text(recipe.methodCa), findsNothing);
      expect(find.text(recipe.winePairingCa), findsNothing);
    });

    testWidgets('expands on tap to display method, tip, and wine pairing',
        (tester) async {
      final recipe = CulinaryRecipe.forSpecies('tuber_melanosporum')!;
      await tester.pumpWidget(buildTestWidget(recipe: recipe));
      await tester.pumpAndSettle();

      // Tap header to expand
      await tester.tap(find.text(recipe.dishNameCa));
      await tester.pumpAndSettle();

      // Now details are visible
      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
      expect(find.text(recipe.descriptionCa), findsOneWidget);
      expect(find.text(recipe.methodCa), findsOneWidget);
      expect(find.text(recipe.tipCa), findsOneWidget);
      expect(find.text(recipe.winePairingCa), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_rounded), findsOneWidget);

      // Tap header again to collapse
      await tester.tap(find.text(recipe.dishNameCa));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      expect(find.text(recipe.methodCa), findsNothing);
    });

    testWidgets('renders warning icon for recipes with safety warnings',
        (tester) async {
      final recipe = CulinaryRecipe.forSpecies('neoboletus_luridiformis')!;
      await tester.pumpWidget(buildTestWidget(recipe: recipe));
      await tester.pumpAndSettle();

      // Expand card
      await tester.tap(find.text(recipe.dishNameCa));
      await tester.pumpAndSettle();

      // Shows warning icon instead of lightbulb
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_rounded), findsNothing);
      expect(find.text(recipe.tipCa), findsOneWidget);
    });

    testWidgets('respects selected Spanish locale', (tester) async {
      final recipe = CulinaryRecipe.forSpecies('craterellus_lutescens')!;

      await tester.pumpWidget(buildTestWidget(
        recipe: recipe,
        locale: const Locale('es'),
      ));
      await tester.pumpAndSettle();

      expect(find.text(recipe.dishNameEs), findsOneWidget);

      await tester.tap(find.text(recipe.dishNameEs));
      await tester.pumpAndSettle();

      expect(find.text(recipe.methodEs), findsOneWidget);
      expect(find.text(recipe.winePairingEs), findsOneWidget);
    });

    testWidgets('respects selected English locale', (tester) async {
      final recipe = CulinaryRecipe.forSpecies('craterellus_lutescens')!;

      await tester.pumpWidget(buildTestWidget(
        recipe: recipe,
        locale: const Locale('en'),
      ));
      await tester.pumpAndSettle();

      expect(find.text(recipe.dishNameEn), findsOneWidget);

      await tester.tap(find.text(recipe.dishNameEn));
      await tester.pumpAndSettle();

      expect(find.text(recipe.methodEn), findsOneWidget);
      expect(find.text(recipe.winePairingEn), findsOneWidget);
    });
  });
}
