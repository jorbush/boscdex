import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/presentation/boscdex/boscdex_provider.dart';
import 'package:boscdex/presentation/journal/journal_provider.dart';
import 'package:boscdex/presentation/settings/settings_screen.dart';
import 'package:boscdex/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsScreen Language Selection Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          discoveryCountProvider.overrideWith((ref) => Stream.value(5)),
          avistamentsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            final locale = ref.watch(appLocaleProvider);
            return MaterialApp(
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ca'),
                Locale('es'),
                Locale('en'),
              ],
              home: const SettingsScreen(),
            );
          },
        ),
      );
    }

    testWidgets(
        'Renders language tile with Catalan default and switches to Spanish & English',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // 1. Initial State: Catalan
      final langTile = find.byKey(const Key('settings_language_tile'));
      expect(langTile, findsOneWidget);
      expect(find.text('Idioma de l\'aplicació'), findsOneWidget);
      expect(find.text('Català (Per defecte)'), findsOneWidget);

      // 2. Tap to open language selector dialog
      await tester.tap(langTile);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byKey(const Key('language_option_ca')), findsOneWidget);
      expect(find.byKey(const Key('language_option_es')), findsOneWidget);
      expect(find.byKey(const Key('language_option_en')), findsOneWidget);

      // 3. Select Spanish (es)
      await tester.tap(find.byKey(const Key('language_option_es')));
      await tester.pumpAndSettle();

      // Dialog closed and UI reactively updated to Spanish
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Configuración'), findsOneWidget);
      expect(find.text('Idioma de la aplicación'), findsOneWidget);
      expect(find.text('Castellano'), findsOneWidget);
      expect(find.text('Aviso legal y descargo'), findsOneWidget);
      expect(find.text('Filtro de certeza IA (70%)'), findsOneWidget);
      expect(find.text('Red Neuronal On-Device'), findsOneWidget);
      expect(sharedPreferences.getString('appLocale'), equals('es'));

      // 4. Tap again to switch to English (en)
      await tester.tap(find.byKey(const Key('settings_language_tile')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_option_en')));
      await tester.pumpAndSettle();

      // UI reactively updated to English
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('App Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Legal notice and disclaimer'), findsOneWidget);
      expect(find.text('AI Confidence Filter (70%)'), findsOneWidget);
      expect(find.text('On-Device Neural Network'), findsOneWidget);
      expect(sharedPreferences.getString('appLocale'), equals('en'));

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}
