import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/presentation/shared/offline_indicator.dart';
import 'package:boscdex/presentation/shared/edibility_badge.dart';
import 'package:boscdex/presentation/shared/safety_alert_box.dart';
import 'package:boscdex/domain/models/edibilitat.dart';

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

  testWidgets('EdibilityBadge renders correct Catalan label and icon',
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
  });

  testWidgets('EdibilityBadge renders icon only when iconOnly is true',
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
}
