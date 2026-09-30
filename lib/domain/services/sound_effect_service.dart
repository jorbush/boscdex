import 'dart:async';
import 'dart:developer' as developer;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Sound effect identifier for 8-bit retro audio.
enum RetroSoundEffect {
  discovery('audio/discovery.wav', 0.85),
  badge('audio/badge.wav', 0.85),
  shutter('audio/shutter.wav', 0.75),
  blip('audio/blip.wav', 0.60);

  final String assetPath;
  final double defaultVolume;

  const RetroSoundEffect(this.assetPath, this.defaultVolume);
}

/// Service managing low-latency 8-bit chiptune audio playback.
///
/// Designed with offline-first local asset streaming and graceful error suppression
/// for automated testing and devices with disabled audio channels.
class SoundEffectService {
  AudioPlayer? _player;
  bool enabled;

  SoundEffectService({
    AudioPlayer? player,
    this.enabled = true,
  }) : _player = player;

  AudioPlayer get player => _player ??= AudioPlayer();

  /// Whether code is currently executing inside a Flutter automated test.
  bool get _isTestEnvironment {
    return kDebugMode &&
        (Zone.current[#flutter_test.binding] != null ||
            WidgetsBinding.instance.runtimeType.toString().contains('Test'));
  }

  /// Plays a specific [RetroSoundEffect].
  Future<void> play(RetroSoundEffect effect) async {
    if (!enabled) return;
    if (_isTestEnvironment && _player == null) {
      // In widget and unit tests without a mock player, avoid calling native platform channels
      return;
    }

    try {
      await player.stop();
      await player.play(
        AssetSource(effect.assetPath),
        volume: effect.defaultVolume,
      );
    } catch (e) {
      developer.log(
        'Audio playback suppressed for ${effect.name}: $e',
        name: 'SoundEffectService',
      );
    }
  }

  /// Plays the species discovery fanfare when unlocking a new specimen.
  Future<void> playDiscovery() => play(RetroSoundEffect.discovery);

  /// Plays the victory triumph fanfare when earning an insignia badge.
  Future<void> playBadgeAward() => play(RetroSoundEffect.badge);

  /// Plays the mechanical 8-bit camera shutter click on photo capture.
  Future<void> playShutter() => play(RetroSoundEffect.shutter);

  /// Plays the short retro selection blip on menu / filter interaction.
  Future<void> playBlip() => play(RetroSoundEffect.blip);

  /// Disposes underlying native audio player resources.
  void dispose() {
    try {
      _player?.dispose();
    } catch (_) {}
  }
}
