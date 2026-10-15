import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/safety_verification_checklist.dart';

/// Interactive modal dialog prompting foragers with essential botanical checks
/// before confirming sightings of mushroom species that have dangerous lookalikes.
class BotanicalSafetyCheckDialog extends StatefulWidget {
  final String speciesId;
  final String speciesName;
  final bool isLethalRisk;
  final bool isToxic;

  const BotanicalSafetyCheckDialog({
    super.key,
    required this.speciesId,
    required this.speciesName,
    this.isLethalRisk = false,
    this.isToxic = false,
  });

  /// Presents the safety check dialog and returns `true` if the user confirmed all checks.
  static Future<bool> show(
    BuildContext context, {
    required String speciesId,
    required String speciesName,
    bool isLethalRisk = false,
    bool isToxic = false,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BotanicalSafetyCheckDialog(
        speciesId: speciesId,
        speciesName: speciesName,
        isLethalRisk: isLethalRisk,
        isToxic: isToxic,
      ),
    );
    return result ?? false;
  }

  @override
  State<BotanicalSafetyCheckDialog> createState() =>
      _BotanicalSafetyCheckDialogState();
}

class _BotanicalSafetyCheckDialogState
    extends State<BotanicalSafetyCheckDialog> {
  late final BotanicalSafetyChecklist _checklist;
  late final Map<String, bool> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checklist = BotanicalSafetyChecklist.getChecklist(widget.speciesId);
    _checkedItems = {for (final item in _checklist.items) item.id: false};
  }

  bool get _allChecked => _checkedItems.values.every((v) => v);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.languageCode;

    final title = widget.isLethalRisk
        ? l10n.botanicalCheckDialogLethalTitle
        : (widget.isToxic
            ? l10n.botanicalCheckDialogToxicTitle
            : l10n.botanicalCheckDialogTitle);

    final subtitle = (widget.isLethalRisk || widget.isToxic)
        ? l10n.botanicalCheckDialogDangerSubtitle(widget.speciesName)
        : l10n.botanicalCheckDialogSubtitle(widget.speciesName);

    final confirmLabel = l10n.botanicalCheckConfirmLabel;
    final cancelLabel = l10n.botanicalCheckCancelLabel;
    final disclaimer = l10n.botanicalCheckDisclaimer;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: RetroColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: RetroColors.ink, width: 2.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: RetroColors.ink,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Danger Header Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.isLethalRisk
                      ? RetroColors.alertDangerLight
                      : RetroColors.alertWarningLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isLethalRisk
                        ? RetroColors.arcadeRed
                        : RetroColors.questAmber,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.isLethalRisk
                          ? Icons.dangerous_rounded
                          : (widget.isToxic
                              ? Icons.warning_amber_rounded
                              : Icons.shield_rounded),
                      color: widget.isLethalRisk
                          ? RetroColors.arcadeRed
                          : RetroColors.questAmber,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: widget.isLethalRisk
                              ? RetroColors.arcadeRed
                              : RetroColors.ink,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: RetroColors.inkSoft,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),

              // Checklist Items
              ..._checklist.items.map((item) {
                final isChecked = _checkedItems[item.id] ?? false;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _checkedItems[item.id] = !isChecked;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isChecked
                            ? RetroColors.surfaceLight
                            : RetroColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isChecked
                              ? RetroColors.forestGreen
                              : RetroColors.ink,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: RetroColors.forestGreen,
                            checkColor: Colors.white,
                            onChanged: (val) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _checkedItems[item.id] = val ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.getQuestion(lang),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: RetroColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.getDetail(lang),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: RetroColors.inkSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 8),
              Center(
                child: Text(
                  disclaimer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.arcadeRed,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allChecked
                        ? RetroColors.forestGreen
                        : RetroColors.inkSoft,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side:
                          const BorderSide(color: RetroColors.ink, width: 2.5),
                    ),
                  ),
                  onPressed: _allChecked
                      ? () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop(true);
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded),
                      const SizedBox(width: 8),
                      Text(
                        confirmLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    cancelLabel,
                    style: const TextStyle(
                      color: RetroColors.inkSoft,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
