import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the [SharedPreferences] instance.
///
/// Must be overridden in the root [ProviderScope] with the pre-initialized
/// instance from [main]. Throws if accessed before initialization.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a pre-initialized '
    'SharedPreferences instance in the root ProviderScope.',
  );
});

/// Notifier tracking whether the user has accepted the legal disclaimer.
final disclaimerAcceptedProvider =
    StateNotifierProvider<DisclaimerAcceptedNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DisclaimerAcceptedNotifier(prefs);
});

/// [StateNotifier] for disclaimer acceptance state.
class DisclaimerAcceptedNotifier extends StateNotifier<bool> {
  DisclaimerAcceptedNotifier(this._prefs)
      : super(_prefs.getBool('disclaimerAccepted') ?? false);

  final SharedPreferences _prefs;

  /// Marks the disclaimer as accepted and persists the choice.
  void accept() {
    state = true;
    _prefs.setBool('disclaimerAccepted', true);
  }
}

/// Notifier tracking the number of times the user has viewed
/// a toxic lookalike comparison screen (for the "Micòleg Prudent" badge).
final toxicComparisonViewCountProvider =
    StateNotifierProvider<ToxicComparisonViewCountNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ToxicComparisonViewCountNotifier(prefs);
});

/// [StateNotifier] for toxic comparison view count.
class ToxicComparisonViewCountNotifier extends StateNotifier<int> {
  ToxicComparisonViewCountNotifier(this._prefs)
      : super(_prefs.getInt('toxicComparisonViewCount') ?? 0);

  final SharedPreferences _prefs;

  /// Increments the view count and persists the new value.
  void increment() {
    state++;
    _prefs.setInt('toxicComparisonViewCount', state);
  }
}

/// Notifier tracking indicator tree IDs viewed/visited by the user (for the "Aliança Silvestre" badge).
final visitedArbresProvider =
    StateNotifierProvider<VisitedArbresNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return VisitedArbresNotifier(prefs);
});

/// [StateNotifier] for visited indicator tree IDs.
class VisitedArbresNotifier extends StateNotifier<Set<String>> {
  VisitedArbresNotifier(this._prefs)
      : super((_prefs.getStringList('visitedArbres') ?? const []).toSet());

  final SharedPreferences _prefs;

  /// Records an indicator tree as visited.
  void markVisited(String arbreId) {
    if (!state.contains(arbreId)) {
      final updated = {...state, arbreId};
      state = updated;
      _prefs.setStringList('visitedArbres', updated.toList());
    }
  }
}

/// Notifier tracking whether tactile haptic vibration is enabled.
final hapticFeedbackEnabledProvider =
    StateNotifierProvider<HapticFeedbackNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HapticFeedbackNotifier(prefs);
});

/// [StateNotifier] for haptic vibration preference.
class HapticFeedbackNotifier extends StateNotifier<bool> {
  HapticFeedbackNotifier(this._prefs)
      : super(_prefs.getBool('hapticFeedbackEnabled') ?? true);

  final SharedPreferences _prefs;

  /// Toggles tactile feedback on or off.
  void toggle() {
    state = !state;
    _prefs.setBool('hapticFeedbackEnabled', state);
  }

  /// Sets tactile feedback state explicitly.
  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setBool('hapticFeedbackEnabled', enabled);
  }
}

/// Notifier tracking whether 8-bit retro sound effects are enabled.
final soundEffectsEnabledProvider =
    StateNotifierProvider<SoundEffectsNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SoundEffectsNotifier(prefs);
});

/// [StateNotifier] for sound effects preference.
class SoundEffectsNotifier extends StateNotifier<bool> {
  SoundEffectsNotifier(this._prefs)
      : super(_prefs.getBool('soundEffectsEnabled') ?? true);

  final SharedPreferences _prefs;

  /// Toggles sound effects on or off.
  void toggle() {
    state = !state;
    _prefs.setBool('soundEffectsEnabled', state);
  }

  /// Sets sound effects state explicitly.
  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setBool('soundEffectsEnabled', enabled);
  }
}
