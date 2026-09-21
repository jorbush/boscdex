import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/retro_decorations.dart';
import 'boscdex_provider.dart';
import 'arbre_card.dart';

/// Grid widget displaying indicator trees in the Arbres Boscdex sub-catalog.
class ArbreGrid extends ConsumerWidget {
  const ArbreGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredArbresBoscdexProvider);
    final asyncEntries = ref.watch(arbresBoscdexProvider);

    return asyncEntries.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: RetroColors.forestGreen),
      ),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: RetroColors.arcadeRed,
          ),
        ),
      ),
      data: (_) {
        if (entries.isEmpty) {
          return const Center(
            child: Text(
              'Cap arbre trobat.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: RetroColors.inkSoft,
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.88,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return ArbreCard(entry: entries[index]);
          },
        );
      },
    );
  }
}
