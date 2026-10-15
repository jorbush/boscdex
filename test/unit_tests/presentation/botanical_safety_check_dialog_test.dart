import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/presentation/scan/botanical_safety_check_dialog.dart';

void main() {
  group('BotanicalSafetyCheckDialog Widget Tests', () {
    testWidgets(
        'Renders checklist items and keeps confirm button disabled until all checked',
        (WidgetTester tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  dialogResult = await BotanicalSafetyCheckDialog.show(
                    context,
                    speciesId: 'lactarius_deliciosus',
                    speciesName: 'Rovelló / Pinetell',
                    isLethalRisk: false,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify title, species name, and warning badge
      expect(find.text('Comprovació Botànica de Seguretat'), findsOneWidget);
      expect(find.textContaining('Rovelló / Pinetell'), findsWidgets);

      // Find confirm button
      final confirmButtonFinder =
          find.widgetWithText(ElevatedButton, 'He comprovat aquests trets');
      expect(confirmButtonFinder, findsOneWidget);

      // Confirm button is disabled initially (onPressed == null)
      final ElevatedButton initialBtn = tester.widget(confirmButtonFinder);
      expect(initialBtn.onPressed, isNull);

      // Check first checkbox only
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2)); // Lactarius has 2 items
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();

      // Still disabled
      final ElevatedButton halfCheckedBtn = tester.widget(confirmButtonFinder);
      expect(halfCheckedBtn.onPressed, isNull);

      // Check second checkbox
      await tester.tap(checkboxes.last);
      await tester.pumpAndSettle();

      // Now enabled!
      final ElevatedButton fullyCheckedBtn = tester.widget(confirmButtonFinder);
      expect(fullyCheckedBtn.onPressed, isNotNull);

      // Tap confirm button
      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      // Dialog closed and returned true
      expect(find.byType(BotanicalSafetyCheckDialog), findsNothing);
      expect(dialogResult, isTrue);
    });

    testWidgets('Canceling dialog returns false without recording sighting',
        (WidgetTester tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  dialogResult = await BotanicalSafetyCheckDialog.show(
                    context,
                    speciesId: 'calocybe_gambosa',
                    speciesName: 'Moixernó',
                    isLethalRisk: true,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Lethal risk banner displayed
      expect(find.text('RISC EXTREM: CONFUSIÓ MORTAL'), findsOneWidget);

      // Tap cancel button ("Tinc dubtes / Cancel·lar")
      final cancelFinder = find.text('Tinc dubtes / Cancel·lar');
      expect(cancelFinder, findsOneWidget);
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();

      // Dialog dismissed and returned false
      expect(find.byType(BotanicalSafetyCheckDialog), findsNothing);
      expect(dialogResult, isFalse);
    });

    testWidgets('Renders Spanish localization correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          supportedLocales: const [Locale('ca'), Locale('es'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => BotanicalSafetyCheckDialog.show(
                  context,
                  speciesId: 'boletus_edulis',
                  speciesName: 'Boleto / Hongo calabaza',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Comprobación Botánica de Seguridad'), findsOneWidget);
      expect(find.text('He verificado estos rasgos'), findsOneWidget);
      expect(find.text('Tengo dudas / Cancelar'), findsOneWidget);
    });

    testWidgets('Renders English localization correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: const [Locale('ca'), Locale('es'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => BotanicalSafetyCheckDialog.show(
                  context,
                  speciesId: 'cantharellus_cibarius',
                  speciesName: 'Golden Chanterelle',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Botanical Safety Verification'), findsOneWidget);
      expect(find.text('I have verified these traits'), findsOneWidget);
      expect(find.text('I have doubts / Cancel'), findsOneWidget);
    });

    testWidgets('Renders toxic mode with warning header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => BotanicalSafetyCheckDialog.show(
                  context,
                  speciesId: 'tricholoma_equestre',
                  speciesName: 'Groguet',
                  isToxic: true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('AVÍS: ESPÈCIE TÒXICA'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('Renders general fallback checklist for unspecialized species',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => BotanicalSafetyCheckDialog.show(
                  context,
                  speciesId: 'some_generic_mushroom',
                  speciesName: 'Bolet desconegut',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('volva o anell d\'Amanita'), findsOneWidget);
      expect(find.textContaining('confusió perillosa'), findsOneWidget);
    });
  });
}
