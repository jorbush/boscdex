import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/retro_decorations.dart';
import 'avistament_detail_sheet.dart';
import 'journal_provider.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avistamentsAsync = ref.watch(avistamentsProvider);
    final boletsMap = ref.watch(allBoletsMapProvider).value ?? {};

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      appBar: AppBar(
        backgroundColor: RetroColors.creamBg,
        elevation: 0,
        title: const Text(
          'El Meu Diari',
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
      body: avistamentsAsync.when(
        data: (avistaments) {
          if (avistaments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: RetroDecorations.card(
                    backgroundColor: Colors.white,
                    borderColor: RetroColors.ink,
                    borderWidth: 2.5,
                    shadowOffset: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '📜',
                        style: TextStyle(fontSize: 54),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'DIARI D\'AVENTURES',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.forestGreen,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Encara no tens cap avistament. Escaneja el teu primer bolet!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: RetroColors.ink,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: avistaments.length,
            itemBuilder: (context, index) {
              final avistament = avistaments[index];
              final displayName =
                  boletsMap[avistament.boletId] ?? avistament.boletId;

              final hasRealPhoto = avistament.photoPath != null &&
                  File(avistament.photoPath!).existsSync();
              final confidencePct = avistament.confidenceScore != null
                  ? (avistament.confidenceScore! * 100).toInt()
                  : null;
              final isHighConfidence =
                  (avistament.confidenceScore ?? 0.0) >= 0.70;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: RetroDecorations.card(
                  backgroundColor: Colors.white,
                  borderColor: RetroColors.ink,
                  borderWidth: 2,
                  shadowOffset: 3,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: hasRealPhoto
                          ? Colors.black
                          : RetroColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: RetroColors.ink, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasRealPhoto
                        ? Image.file(
                            File(avistament.photoPath!),
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => const Center(
                              child: Text('🍄', style: TextStyle(fontSize: 24)),
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/images/mushrooms/${avistament.boletId}.png',
                                cacheWidth: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/silhouettes/generic_mushroom.png',
                                  cacheWidth: 150,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('🍄',
                                          style: TextStyle(fontSize: 22)),
                                ),
                              ),
                            ),
                          ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: RetroColors.ink,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (confidencePct != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isHighConfidence
                                ? RetroColors.forestGreen.withOpacity(0.12)
                                : RetroColors.goldCoin.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isHighConfidence
                                  ? RetroColors.forestGreen
                                  : RetroColors.ink,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            '$confidencePct%',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              color: isHighConfidence
                                  ? RetroColors.forestGreen
                                  : RetroColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 13, color: RetroColors.inkSoft),
                          const SizedBox(width: 4),
                          Text(
                            _dateFormat.format(avistament.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: RetroColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                      if (avistament.notes != null &&
                          avistament.notes!.isNotEmpty &&
                          !avistament.notes!.startsWith(
                              'Avistament identificat amb Boscdex AI')) ...[
                        const SizedBox(height: 4),
                        Text(
                          avistament.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: RetroColors.inkSoft,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: RetroColors.sectionBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: RetroColors.ink,
                      size: 18,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    AvistamentDetailSheet.show(context, avistament);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: RetroColors.forestGreen),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
