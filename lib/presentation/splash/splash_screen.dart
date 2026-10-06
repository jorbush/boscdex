import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../providers/preferences_provider.dart';
import '../shared/boscdex_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        final isAccepted = ref.read(disclaimerAcceptedProvider);
        if (isAccepted) {
          context.go('/boscdex');
        } else {
          context.go('/disclaimer');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Retro Brand Logo Emblem
                const BoscdexLogo(
                  size: 130,
                  showBorder: true,
                  borderWidth: 3.5,
                  showShadow: true,
                  shadowOffset: 5,
                ),
                const SizedBox(height: 24),

                // Retro Game Title
                const Text(
                  'Boscdex',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: RetroColors.ink,
                    shadows: [
                      Shadow(
                        color: RetroColors.forestGreen,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  l10n.splashSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: RetroColors.inkSoft,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // 16-Bit Loading Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: RetroColors.goldCoin,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: RetroColors.ink, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: RetroColors.ink,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n.insertCoinToExplore,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: RetroColors.ink,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
