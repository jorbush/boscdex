import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'boscdex_provider.dart';
import 'boscdex_card.dart';

class BoscdexGrid extends ConsumerWidget {
  const BoscdexGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredBoscdexEntriesProvider);
    final asyncEntries = ref.watch(boscdexEntriesProvider);

    return asyncEntries.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (_) {
        if (entries.isEmpty) {
          return const Center(child: Text('Cap bolet trobat.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return BoscdexCard(entry: entries[index]);
          },
        );
      },
    );
  }
}
