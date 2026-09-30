import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boscdex/domain/services/sound_effect_service.dart';
import 'package:boscdex/providers/preferences_provider.dart';
import 'package:boscdex/providers/sound_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SoundEffectService Unit Tests', () {
    test('Default instance initializes with enabled = true', () {
      final service = SoundEffectService();
      expect(service.enabled, isTrue);
      service.dispose();
    });

    test('Initializes with custom enabled flag', () {
      final service = SoundEffectService(enabled: false);
      expect(service.enabled, isFalse);
      service.dispose();
    });

    test('Sound methods execute safely in test environment without throwing',
        () async {
      final service = SoundEffectService(enabled: true);

      // In test environment, native method channel calls are bypassed gracefully
      await expectLater(service.playDiscovery(), completes);
      await expectLater(service.playBadgeAward(), completes);
      await expectLater(service.playShutter(), completes);
      await expectLater(service.playBlip(), completes);
      await expectLater(service.play(RetroSoundEffect.discovery), completes);

      service.dispose();
    });

    test('Disabled service skips playback immediately', () async {
      final service = SoundEffectService(enabled: false);

      await expectLater(service.playDiscovery(), completes);
      await expectLater(service.playBadgeAward(), completes);
      await expectLater(service.playShutter(), completes);
      await expectLater(service.playBlip(), completes);

      service.dispose();
    });

    test(
        'soundEffectsEnabledProvider reads from and writes to SharedPreferences',
        () {
      SharedPreferences.setMockInitialValues({'soundEffectsEnabled': false});
      final prefs = SharedPreferences.getInstance();

      prefs.then((sp) {
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sp),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(soundEffectsEnabledProvider), isFalse);

        // Toggle sound
        container.read(soundEffectsEnabledProvider.notifier).toggle();
        expect(container.read(soundEffectsEnabledProvider), isTrue);
        expect(sp.getBool('soundEffectsEnabled'), isTrue);

        // Set explicitly
        container.read(soundEffectsEnabledProvider.notifier).setEnabled(false);
        expect(container.read(soundEffectsEnabledProvider), isFalse);
        expect(sp.getBool('soundEffectsEnabled'), isFalse);
      });
    });

    test(
        'soundEffectServiceProvider syncs enabled state with soundEffectsEnabledProvider',
        () async {
      SharedPreferences.setMockInitialValues({'soundEffectsEnabled': true});
      final sp = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sp),
        ],
      );
      addTearDown(container.dispose);

      final soundService = container.read(soundEffectServiceProvider);
      expect(soundService.enabled, isTrue);

      container.read(soundEffectsEnabledProvider.notifier).setEnabled(false);
      final updatedService = container.read(soundEffectServiceProvider);
      expect(updatedService.enabled, isFalse);
    });
  });
}
