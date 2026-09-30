import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/sound_effect_service.dart';
import 'preferences_provider.dart';

/// Riverpod provider for the singleton [SoundEffectService].
///
/// Automatically propagates the user's audio preference from [soundEffectsEnabledProvider]
/// and disposes the native player instance upon provider disposal.
final soundEffectServiceProvider = Provider<SoundEffectService>((ref) {
  bool soundEnabled = true;
  try {
    soundEnabled = ref.watch(soundEffectsEnabledProvider);
  } catch (_) {
    soundEnabled = true;
  }
  final service = SoundEffectService(enabled: soundEnabled);
  ref.onDispose(() => service.dispose());
  return service;
});
