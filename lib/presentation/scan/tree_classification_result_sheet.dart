import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/services/badge_progression_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';

/// Modal bottom sheet displaying the ML classification results for indicator trees,
/// their morphological traits, and the prized edible/symbiotic mushrooms found beneath them.
class TreeClassificationResultSheet extends ConsumerStatefulWidget {
  final List<ArbreClassificacioResult> results;
  final Uint8List? imageBytes;
  final VoidCallback? onInspected;

  const TreeClassificationResultSheet({
    super.key,
    required this.results,
    this.imageBytes,
    this.onInspected,
  });

  @override
  ConsumerState<TreeClassificationResultSheet> createState() =>
      _TreeClassificationResultSheetState();
}

class _TreeClassificationResultSheetState
    extends ConsumerState<TreeClassificationResultSheet> {
  Arbre? _arbre;
  List<Bolet> _bolets = [];
  bool _loadingDetails = true;

  @override
  void initState() {
    super.initState();
    _loadTreeDetails();
  }

  Future<void> _loadTreeDetails() async {
    if (widget.results.isEmpty) {
      setState(() => _loadingDetails = false);
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final topCandidate = widget.results.first;

      final arbre = await db.arbreDao.getArbreById(topCandidate.arbreId);
      final bolets = await db.boletDao.getBoletsByArbreId(topCandidate.arbreId);

      // Track visited tree for indicator tree alliances
      ref
          .read(visitedArbresProvider.notifier)
          .markVisited(topCandidate.arbreId);

      // Check and evaluate badges (e.g. Aliança Silvestre)
      await _evaluateBadges(topCandidate.arbreId);

      if (mounted) {
        setState(() {
          _arbre = arbre;
          _bolets = bolets;
          _loadingDetails = false;
        });
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error loading tree classification details: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'TreeClassificationResultSheet',
      );
      if (mounted) {
        setState(() => _loadingDetails = false);
      }
    }
  }

  Future<void> _evaluateBadges(String treeId) async {
    final db = ref.read(appDatabaseProvider);
    final toxicViews = ref.read(toxicComparisonViewCountProvider);
    await BadgeProgressionService().syncBadgeProgression(
      db: db,
      toxicComparisonViewCount: toxicViews,
      currentTreeId: treeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: const Text('No s\'han obtingut resultats d\'arbre.'),
      );
    }

    final top = widget.results.first;
    final isLowConfidence = top.confidence < 0.70;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RetroColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: RetroColors.ink, width: 2.5),
      ),
      child: _loadingDetails
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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

                  // Header with confidence chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Resultat d\'arbre indicador',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLowConfidence
                              ? RetroColors.questAmber
                              : RetroColors.goldCoin,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: RetroColors.ink, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.ink,
                              offset: Offset(1.5, 1.5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          '${(top.confidence * 100).toInt()}% coincidència',
                          style: const TextStyle(
                            color: RetroColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Top Matched Tree Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: RetroDecorations.card(
                      backgroundColor: RetroColors.surface,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: RetroColors.mintWash,
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              _arbre?.imageAssetPath ??
                                  'assets/images/trees/${_arbre?.id ?? top.arbreId}.png',
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.none,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildTreeIconPlaceholder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _arbre?.catalanName ?? top.displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: RetroColors.ink,
                                ),
                              ),
                              if (_arbre != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  _arbre!.scientificName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: RetroColors.inkSoft,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botanical traits
                  if (_arbre != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTraitChip(
                            context,
                            icon: Icons.eco_rounded,
                            label: 'Fulla',
                            value: _arbre!.leafType,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTraitChip(
                            context,
                            icon: Icons.texture_rounded,
                            label: 'Escorça',
                            value: _arbre!.barkDescription,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTraitChip(
                      context,
                      icon: Icons.landscape_rounded,
                      label: 'Sòl típic',
                      value: _arbre!.typicalSoil,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Associated mushrooms section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: RetroDecorations.card(
                      backgroundColor: const Color(0xFFF0F5ED),
                      shadowOffset: 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: RetroColors.forestGreen,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Bolets que pots cercar sota aquest arbre:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: RetroColors.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_bolets.isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 6.0,
                            children: _bolets.map((bolet) {
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.of(context).pop();
                                  try {
                                    GoRouter.of(context).push('/boscdex/${bolet.id}');
                                  } catch (_) {
                                    // Non-fatal if rendered without GoRouter in tests
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: RetroColors.ink, width: 1.8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: RetroColors.ink,
                                        offset: Offset(1.5, 1.5),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.grass_rounded,
                                          size: 14,
                                          color: RetroColors.forestGreen),
                                      const SizedBox(width: 4),
                                      Text(
                                        bolet.catalanName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: RetroColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        else
                          const Text(
                            'Sense bolets associats catalogats.',
                            style: TextStyle(
                              fontSize: 12,
                              color: RetroColors.inkSoft,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Candidate list (secondary matches)
                  if (widget.results.length > 1) ...[
                    const Text(
                      'Altres possibles espècies:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (int i = 1; i < widget.results.length; i++) ...[
                      _buildCandidateRow(widget.results[i]),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 16),
                  ],

                  // Action Button: View Tree Details
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.forestGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                              color: RetroColors.ink, width: 2.5),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      icon: const Icon(Icons.park_rounded),
                      label: const Text(
                        'Veure fitxa completa de l\'arbre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        widget.onInspected?.call();
                        Navigator.of(context).pop();
                        try {
                          GoRouter.of(context).push('/arbre/${top.arbreId}');
                        } catch (_) {
                          // Non-fatal if rendered without GoRouter in tests
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Tancar',
                        style: TextStyle(
                          color: RetroColors.inkSoft,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTraitChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: RetroColors.ink, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: RetroColors.forestGreen),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: RetroColors.inkSoft,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: RetroColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateRow(ArbreClassificacioResult candidate) {
    final pct = (candidate.confidence * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              candidate.displayName,
              style: const TextStyle(
                fontSize: 13,
                color: RetroColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '$pct%',
              style: const TextStyle(
                fontSize: 12,
                color: RetroColors.inkSoft,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        RetroProgressBar(
          progress: candidate.confidence,
          height: 10,
          fillColor: RetroColors.forestGreen,
        ),
      ],
    );
  }

  Widget _buildTreeIconPlaceholder() {
    return Container(
      color: RetroColors.forestGreen,
      child: const Center(
        child: Icon(
          Icons.park_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
