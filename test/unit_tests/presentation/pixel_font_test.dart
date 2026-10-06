import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/theme/app_theme.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PixelifySans Font Theme Tests', () {
    test('RetroFonts.pixel constant is defined correctly', () {
      expect(RetroFonts.pixel, equals('PixelifySans'));
    });

    test('AppTheme retroTheme applies RetroFonts.pixel globally and to all text styles', () {
      final theme = AppTheme.retroTheme;

      expect(theme.appBarTheme.titleTextStyle?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.headlineLarge?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.headlineMedium?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.titleLarge?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.titleMedium?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.bodyLarge?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.bodyMedium?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.bodySmall?.fontFamily, equals('PixelifySans'));
      expect(theme.textTheme.labelLarge?.fontFamily, equals('PixelifySans'));
      expect(
        theme.bottomNavigationBarTheme.selectedLabelStyle?.fontFamily,
        equals('PixelifySans'),
      );
      expect(
        theme.bottomNavigationBarTheme.unselectedLabelStyle?.fontFamily,
        equals('PixelifySans'),
      );
    });

    testWidgets('Renders Catalan, Spanish, and English text with PixelifySans font',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.retroTheme,
          home: Scaffold(
            body: Column(
              children: const [
                Text(
                  'Boscdex #001',
                  style: TextStyle(fontFamily: RetroFonts.pixel),
                ),
                Text(
                  'Rovelló / Pinetell - Excel·lent',
                  style: TextStyle(fontFamily: RetroFonts.pixel),
                ),
                Text(
                  'Moixernó - Caçador de Bolets',
                  style: TextStyle(fontFamily: RetroFonts.pixel),
                ),
                Text(
                  '★ CARREGANT EL BOSC ★',
                  style: TextStyle(fontFamily: RetroFonts.pixel),
                ),
                Text(
                  '¡Atención! Posible confusión con especie tóxica',
                  style: TextStyle(fontFamily: RetroFonts.pixel),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Boscdex #001'), findsOneWidget);
      expect(find.text('Rovelló / Pinetell - Excel·lent'), findsOneWidget);
      expect(find.text('Moixernó - Caçador de Bolets'), findsOneWidget);
      expect(find.text('★ CARREGANT EL BOSC ★'), findsOneWidget);
      expect(find.text('¡Atención! Posible confusión con especie tóxica'), findsOneWidget);
    });
  });
}
