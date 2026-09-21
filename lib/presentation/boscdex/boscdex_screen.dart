import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'boscdex_provider.dart';
import 'boscdex_grid.dart';
import '../shared/offline_indicator.dart';
import '../../core/constants/app_constants.dart';

import 'insignies_dialog.dart';

class BoscdexScreen extends ConsumerWidget {
  const BoscdexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(boscdexFilterProvider);
    final discoveryCountAsync = ref.watch(discoveryCountProvider);

    final count = discoveryCountAsync.value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Boscdex'),
            Text(
              '$count/${AppConstants.maxDexEntries} descoberts',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Color(0xFFE9C46A)),
            tooltip: 'Les Meves Insígnies',
            onPressed: () => InsigniesDialog.show(context),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: OfflineIndicator()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context, ref, filter),
          const Expanded(
            child: BoscdexGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
      BuildContext context, WidgetRef ref, String currentFilter) {
    final filters = ['tots', 'comestibles', 'tòxics/mortals', 'arbres socis'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                f[0].toUpperCase() + f.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.tertiary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onSelected: (selected) {
                if (selected) {
                  ref.read(boscdexFilterProvider.notifier).state = f;
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
