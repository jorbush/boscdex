import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/retro_decorations.dart';
import '../../domain/models/culinary_recipe.dart';

class TraditionalRecipeCard extends StatefulWidget {
  final CulinaryRecipe recipe;

  const TraditionalRecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  State<TraditionalRecipeCard> createState() => _TraditionalRecipeCardState();
}

class _TraditionalRecipeCardState extends State<TraditionalRecipeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.languageCode;
    final recipe = widget.recipe;

    return Container(
      width: double.infinity,
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RetroColors.goldCoin,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RetroColors.ink, width: 2),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 20,
                      color: RetroColors.ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.traditionalRecipes,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: RetroColors.ink,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          recipe.getDishName(lang),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: RetroColors.forestGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: RetroColors.ink,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Container(
                height: 1.5,
                color: RetroColors.ink.withOpacity(0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish description
                  Text(
                    recipe.getDescription(lang),
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: RetroColors.inkSoft,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Preparation
                  Row(
                    children: [
                      const Icon(Icons.soup_kitchen_rounded,
                          size: 16, color: RetroColors.ink),
                      const SizedBox(width: 6),
                      Text(
                        l10n.culinaryPreparation,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: RetroColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: RetroColors.sectionBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: RetroColors.ink.withOpacity(0.3), width: 1.5),
                    ),
                    child: Text(
                      recipe.getMethod(lang),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: RetroColors.ink,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Culinary Tip & Safety
                  Builder(
                    builder: (context) {
                      final tip = recipe.getTip(lang);
                      final isWarning = tip.contains('⚠️') ||
                          tip.toLowerCase().contains('tòxic') ||
                          tip.toLowerCase().contains('toxic') ||
                          tip.toLowerCase().contains('tóxico');
                      final boxColor = isWarning
                          ? RetroColors.arcadeRed.withOpacity(0.12)
                          : RetroColors.questAmber.withOpacity(0.15);
                      final borderColor = isWarning
                          ? RetroColors.arcadeRed
                          : RetroColors.questAmber;
                      final iconData = isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.lightbulb_rounded;
                      final iconColor = isWarning
                          ? RetroColors.arcadeRed
                          : RetroColors.questAmber;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              iconData,
                              size: 18,
                              color: iconColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: RetroColors.ink,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Wine pairing
                  Row(
                    children: [
                      const Icon(
                        Icons.wine_bar_rounded,
                        size: 16,
                        color: RetroColors.arcadeRed,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n.winePairing}: ',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: RetroColors.ink,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          recipe.getWinePairing(lang),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RetroColors.arcadeRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
