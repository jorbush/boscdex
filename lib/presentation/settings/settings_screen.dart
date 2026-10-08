import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
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
    final currentLocale = ref.watch(appLocaleProvider);
    final discoveryCountAsync = ref.watch(discoveryCountProvider);
    final avistamentsAsync = ref.watch(avistamentsProvider);
    final totalBolets = ref.watch(totalBoletsCountProvider);
    final foragerLevel = ref.watch(foragerLevelProvider);

    final l10n = AppLocalizations.of(context);
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
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
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
                Text(
                  l10n.appTagline,
                  style: const TextStyle(
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
          _buildSectionHeader(l10n.settingsAppPreferences),
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
                // Language selection tile
                ListTile(
                  key: const Key('settings_language_tile'),
                  title: Text(
                    l10n.settingsLanguage,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    _getLocaleDisplayName(currentLocale.languageCode, l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.mintWash,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      size: 18,
                      color: RetroColors.forestGreen,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: RetroColors.ink,
                    size: 22,
                  ),
                  onTap: () {
                    if (hapticEnabled) HapticFeedback.selectionClick();
                    _showLanguageDialog(
                      context,
                      ref,
                      currentLocale,
                      hapticEnabled,
                    );
                  },
                ),
                Container(height: 1, color: RetroColors.ink.withOpacity(0.12)),
                SwitchListTile.adaptive(
                  value: soundEnabled,
                  activeColor: RetroColors.forestGreen,
                  title: Text(
                    l10n.settingsSoundTitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsSoundSubtitle,
                    style: const TextStyle(
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
                  title: Text(
                    l10n.settingsHapticTitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsHapticSubtitle,
                    style: const TextStyle(
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
          _buildSectionHeader(l10n.settingsSafetySection),
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
                  title: Text(
                    l10n.settingsLegalDisclaimerTitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsLegalDisclaimerSubtitle,
                    style: const TextStyle(
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
                  title: Text(
                    l10n.settingsAiCertaintyFilterTitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsAiCertaintyFilterSubtitle,
                    style: const TextStyle(
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
          _buildSectionHeader(l10n.settingsDataAndAiEngine),
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
                  title: l10n.settingsOnDeviceNeuralNetwork,
                  description: l10n.settingsOnDeviceNeuralNetworkDesc,
                ),
                const Divider(height: 18, color: RetroColors.progressBarEmpty),
                _buildInfoRow(
                  icon: const PixelArbreIcon(size: 20),
                  title: l10n.settingsSqliteDatabase,
                  description: l10n.databaseDescription,
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
                  title: l10n.settingsExpeditionStatus,
                  description:
                      'LVL ${foragerLevel.level}: ${foragerLevel.title(l10n.languageCode)} (${foragerLevel.totalXp} XP)\n${l10n.speciesCatalogedStats(
                    discoveryCount,
                    totalBolets > 0 ? totalBolets : AppConstants.maxDexEntries,
                    avistamentCount,
                  )}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 5. Section: Sobre Boscdex
          _buildSectionHeader(l10n.settingsAboutBoscdex),
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
                  children: [
                    const Icon(
                      Icons.forest_rounded,
                      size: 20,
                      color: RetroColors.forestGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.settingsPrivacyCommitment,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.settingsPrivacyCommitmentDesc,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: RetroColors.inkSoft,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.madeWithLoveForForagers,
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

  String _getLocaleDisplayName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'es':
        return l10n.languageNameSpanish;
      case 'en':
        return l10n.languageNameEnglish;
      case 'ca':
      default:
        return l10n.languageNameCatalan;
    }
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
    bool hapticEnabled,
  ) {
    final l10n = AppLocalizations.of(context);
    final options = [
      {'code': 'ca', 'label': '🌲 ${l10n.languageNameCatalan}'},
      {'code': 'es', 'label': '🇪🇸 ${l10n.languageNameSpanish}'},
      {'code': 'en', 'label': '🇬🇧 ${l10n.languageNameEnglish}'},
    ];

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: RetroColors.ink, width: 2.5),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: RetroColors.goldLight,
                shape: BoxShape.circle,
                border: Border.all(color: RetroColors.ink, width: 1.5),
              ),
              child: const Icon(
                Icons.translate_rounded,
                size: 20,
                color: RetroColors.ink,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.settingsSelectLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final opt in options)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: currentLocale.languageCode == opt['code']
                      ? RetroColors.mintWash
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: currentLocale.languageCode == opt['code']
                        ? RetroColors.forestGreen
                        : RetroColors.ink.withOpacity(0.2),
                    width:
                        currentLocale.languageCode == opt['code'] ? 2.0 : 1.2,
                  ),
                ),
                child: ListTile(
                  key: Key('language_option_${opt['code']}'),
                  title: Text(
                    opt['label']!,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: RetroColors.ink,
                    ),
                  ),
                  trailing: currentLocale.languageCode == opt['code']
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: RetroColors.forestGreen,
                          size: 22,
                        )
                      : null,
                  onTap: () {
                    if (hapticEnabled) HapticFeedback.selectionClick();
                    try {
                      ref.read(soundEffectServiceProvider).playBlip();
                    } catch (_) {}
                    ref
                        .read(appLocaleProvider.notifier)
                        .setLocale(Locale(opt['code']!));
                    Navigator.of(dialogCtx).pop();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
