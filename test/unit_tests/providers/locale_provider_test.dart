import 'package:boscdex/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider Unit Tests', () {
    test('Default locale is Catalan (ca) when no preference is stored',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final locale = container.read(appLocaleProvider);
      expect(locale, equals(const Locale('ca')));
      expect(locale.languageCode, equals('ca'));
    });

    test('Loads stored locale from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'appLocale': 'es'});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final locale = container.read(appLocaleProvider);
      expect(locale.languageCode, equals('es'));
    });

    test('setLocale updates state and persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(appLocaleProvider.notifier);

      notifier.setLocale(const Locale('es'));
      expect(container.read(appLocaleProvider).languageCode, equals('es'));
      expect(prefs.getString('appLocale'), equals('es'));

      notifier.setLocale(const Locale('en'));
      expect(container.read(appLocaleProvider).languageCode, equals('en'));
      expect(prefs.getString('appLocale'), equals('en'));

      notifier.setLocale(const Locale('ca'));
      expect(container.read(appLocaleProvider).languageCode, equals('ca'));
      expect(prefs.getString('appLocale'), equals('ca'));
    });
  });
}
