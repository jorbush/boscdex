import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';

class SeasonIndicator extends StatelessWidget {
  const SeasonIndicator({
    super.key,
    required this.fruitingMonths,
  });

  /// List of integers from 1 to 12 representing the months the mushroom fruits
  final List<int> fruitingMonths;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final monthNames = l10n.monthNames;
    final activeSet = fruitingMonths.toSet();
    final activeMonthNames = fruitingMonths
        .where((m) => m >= 1 && m <= 12)
        .map((m) => monthNames[m - 1])
        .toList();

    return Semantics(
      label: activeMonthNames.isEmpty
          ? l10n.noSeasonDefined
          : l10n.fruitingSeasonSemantics(activeMonthNames.join(', ')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded,
                  size: 18, color: RetroColors.forestGreen),
              const SizedBox(width: 6),
              Text(
                l10n.season,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 360,
              child: Row(
                children: List.generate(12, (index) {
                  final monthNumber = index + 1;
                  final isActive = activeSet.contains(monthNumber);

                  return Expanded(
                    child: ExcludeSemantics(
                      child: Container(
                        margin: EdgeInsets.only(right: index < 11 ? 3.0 : 0.0),
                        height: 36,
                        decoration: BoxDecoration(
                          color: isActive
                              ? RetroColors.forestGreen
                              : RetroColors.screenOverlay,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isActive
                                ? RetroColors.ink
                                : RetroColors.inkFaint,
                            width: isActive ? 2.0 : 1.2,
                          ),
                          boxShadow: isActive
                              ? const [
                                  BoxShadow(
                                    color: RetroColors.ink,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            monthNames[index],
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight:
                                  isActive ? FontWeight.w900 : FontWeight.w600,
                              color:
                                  isActive ? Colors.white : RetroColors.inkSoft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
