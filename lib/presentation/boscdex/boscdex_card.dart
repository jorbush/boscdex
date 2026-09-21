import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'boscdex_provider.dart';
import '../shared/rarity_border.dart';
import '../shared/edibility_badge.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';

class BoscdexCard extends StatelessWidget {
  final BoscdexEntry entry;

  const BoscdexCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dexNum = entry.bolet.dexNumber.toString().padLeft(3, '0');

    if (!entry.isDiscovered) {
      return GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Encara no has descobert aquest bolet!')),
          );
        },
        child: Card(
          color: theme.colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.help_outline, size: 40, color: Colors.white30),
              const SizedBox(height: 8),
              Text(
                '#$dexNum',
                style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final rarity = RaritatTierExtension.fromString(entry.bolet.rarityTier);
    final edibility = EdibilitatExtension.fromString(entry.bolet.edibility);

    return GestureDetector(
      onTap: () {
        context.push('/boscdex/${entry.bolet.id}');
      },
      child: RarityBorder(
        tier: rarity,
        borderRadius: BorderRadius.circular(12),
        borderWidth: 3,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white10,
                      child: Center(
                        child: Text(
                          entry.bolet.catalanName[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#$dexNum',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          entry.bolet.catalanName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 6,
                right: 6,
                child: EdibilityBadge(
                  edibilitat: edibility,
                  iconOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
