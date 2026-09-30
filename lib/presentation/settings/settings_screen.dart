import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/retro_decorations.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/sound_provider.dart';
import '../boscdex/boscdex_provider.dart';
import '../journal/journal_provider.dart';
import '../shared/boscdex_logo.dart';
import '../shared/offline_indicator.dart';
import '../shared/pixel_icons.dart';

/// Screen displaying app settings, preferences, safety guidelines, and system diagnostics.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hapticEnabled = ref.watch(hapticFeedbackEnabledProvider);
    final soundEnabled = ref.watch(soundEffectsEnabledProvider);
    final discoveryCountAsync = ref.watch(discoveryCountProvider);
    final avistamentsAsync = ref.watch(avistamentsProvider);

    final discoveryCount = discoveryCountAsync.value ?? 0;
    final avistamentCount = avistamentsAsync.value?.length ?? 0;

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      appBar: AppBar(
        backgroundColor: RetroColors.creamBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: RetroColors.ink,
            size: 24,
          ),
          onPressed: () {
            if (hapticEnabled) HapticFeedback.selectionClick();
            context.pop();
          },
        ),
        title: const Text(
          'Configuració',
          style: TextStyle(
            color: RetroColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: RetroColors.ink,
            height: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. App Header Identity Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2.2,
              shadowOffset: 3,
            ),
            child: Column(
              children: [
                const BoscdexLogo(
                  size: 54,
                  showBorder: true,
                  borderWidth: 1.8,
                  showShadow: true,
                  shadowOffset: 2.0,
                ),
                const SizedBox(height: 10),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: RetroColors.ink,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'La Pokédex micològica de Catalunya',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: RetroColors.mintWash,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RetroColors.ink, width: 1.5),
                      ),
                      child: const Text(
                        'v${AppConstants.appVersion}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const OfflineIndicator(),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Section: Preferències de l'App
          _buildSectionHeader('PREFERÈNCIES DE L\'APLICACIÓ'),
          const SizedBox(height: 8),
          Container(
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 2.5,
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: soundEnabled,
                  activeColor: RetroColors.forestGreen,
                  title: const Text(
                    'Efectes de so retro 8-bit',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: const Text(
                    'Sons de disparador, fanfàrria de descobriment i medalles',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.goldLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      size: 18,
                      color: RetroColors.ink,
                    ),
                  ),
                  onChanged: (val) {
                    if (hapticEnabled) HapticFeedback.selectionClick();
                    ref
                        .read(soundEffectsEnabledProvider.notifier)
                        .setEnabled(val);
                    if (val) {
                      ref.read(soundEffectServiceProvider).playBlip();
                    }
                  },
                ),
                Container(height: 1, color: RetroColors.ink.withOpacity(0.12)),
                SwitchListTile.adaptive(
                  value: hapticEnabled,
                  activeColor: RetroColors.forestGreen,
                  title: const Text(
                    'Resposta hàptica (Vibració)',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: const Text(
                    'Feedback tàctil en prémer botons i descobrir espècies',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.mintWash,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.vibration_rounded,
                      size: 18,
                      color: RetroColors.forestGreen,
                    ),
                  ),
                  onChanged: (val) {
                    if (val) HapticFeedback.mediumImpact();
                    ref
                        .read(hapticFeedbackEnabledProvider.notifier)
                        .setEnabled(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Section: Seguretat Micològica
          _buildSectionHeader('SEGURETAT I AVÍS LEGAL'),
          const SizedBox(height: 8),
          Container(
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 2.5,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.alertDangerLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: RetroColors.arcadeRed,
                    ),
                  ),
                  title: const Text(
                    'Avís legal i descàrrec',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: const Text(
                    'Revisa els termes legals i avisos de consum',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: RetroColors.ink,
                    size: 22,
                  ),
                  onTap: () {
                    if (hapticEnabled) HapticFeedback.selectionClick();
                    context.push('/disclaimer');
                  },
                ),
                Container(height: 1, color: RetroColors.ink.withOpacity(0.12)),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.mintWash,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      size: 18,
                      color: RetroColors.forestGreen,
                    ),
                  ),
                  title: const Text(
                    'Filtre de certesa IA (70%)',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: const Text(
                    'Qualsevol coincidència amb certesa inferior al 70% o amb risc de confusió tòxica activa l\'alerta vermella.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Section: Dades i Motor IA Local
          _buildSectionHeader('DADES I MOTOR IA LOCAL'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 2.5,
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: const PixelBoletIcon(size: 20),
                  title: 'Xarxa Neuronal On-Device',
                  description:
                      'Model INT8 quantitzat (~2.5 MB) integrat a l\'app. Execució 100% autònoma sense connexió a internet.',
                ),
                const Divider(height: 18, color: RetroColors.progressBarEmpty),
                _buildInfoRow(
                  icon: const PixelArbreIcon(size: 20),
                  title: 'Catàleg Relacional SQLite',
                  description:
                      '20 bolets i 5 arbres indicadors de Catalunya amb claus morfològiques i xarxa micorrízica.',
                ),
                const Divider(height: 18, color: RetroColors.progressBarEmpty),
                _buildInfoRow(
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: RetroColors.goldLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1),
                    ),
                    child: const Icon(
                      Icons.folder_special_rounded,
                      size: 16,
                      color: RetroColors.questAmber,
                    ),
                  ),
                  title: 'Estat de la Teva Expedició',
                  description:
                      '$discoveryCount / ${AppConstants.maxDexEntries} bolets catalogats • $avistamentCount fotos personals al diari.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 5. Section: Sobre Boscdex
          _buildSectionHeader('SOBRE BOSCDEX'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 2.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.forest_rounded,
                      size: 20,
                      color: RetroColors.forestGreen,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Compromís de Privacitat',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Boscdex està dissenyada per funcionar a les profunditats del bosc sense cobertura. Totes les fotografies, dades GPS i anàlisis d\'imatge es queden estrictament al teu dispositiu.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: RetroColors.inkSoft,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Fet amb 🌲 per als boletaires de Catalunya',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.inkSoft.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          color: RetroColors.forestGreen,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required Widget icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: icon,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: RetroColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: RetroColors.inkSoft,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
