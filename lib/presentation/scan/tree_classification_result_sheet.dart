import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/models/insignia.dart' as domain;
import '../../domain/services/badge_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';

/// Modal bottom sheet displaying the ML classification results for indicator trees,
/// their morphological traits, and the prized edible/symbiotic mushrooms found beneath them.
class TreeClassificationResultSheet extends ConsumerStatefulWidget {
  final List<ArbreClassificacioResult> results;
  final Uint8List? imageBytes;
  final VoidCallback? onInspected;

  const TreeClassificationResultSheet({
    Key? key,
    required this.results,
    this.imageBytes,
    this.onInspected,
  }) : super(key: key);

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
    try {
      final db = ref.read(appDatabaseProvider);
      final allDiscoveries = await db.descobrimentDao.getAllDiscoveries();
      final allInsignies = await db.insigniaDao.getAllInsignies();
      final toxicViews = ref.read(toxicComparisonViewCountProvider);

      final hasRovello =
          allDiscoveries.any((d) => d.boletId == 'lactarius_deliciosus');
      final hasPinetell =
          allDiscoveries.any((d) => d.boletId == 'lactarius_sanguifluus');

      // Check if user has discovered a mushroom associated with this tree
      final associatedMushrooms = await db.boletDao.getBoletsByArbreId(treeId);
      final discoveredIds = allDiscoveries.map((d) => d.boletId).toSet();
      final hasTreeAlliance =
          associatedMushrooms.any((b) => discoveredIds.contains(b.id));

      final badgeService = BadgeService();
      final currentDomainBadges = allInsignies.map((dbBadge) {
        return domain.Insignia(
          id: dbBadge.id,
          nom: dbBadge.id,
          descripcio: '',
          iconPath: '',
          progressCount: dbBadge.progressCount,
          targetCount: _getTargetCountForBadge(dbBadge.id),
          awardedAt: dbBadge.awardedAt,
        );
      }).toList();

      final updatedBadges = await badgeService.evaluateBadges(
        discoveryCount: allDiscoveries.length,
        hasRovello: hasRovello,
        hasPinetell: hasPinetell,
        toxicComparisonViewCount: toxicViews,
        hasTreeAlliance: hasTreeAlliance,
        currentBadges: currentDomainBadges,
      );

      for (final b in updatedBadges) {
        await db.insigniaDao.updateProgress(b.id, b.progressCount);
        if (b.isAwarded && b.awardedAt != null) {
          await db.insigniaDao.awardInsignia(b.id, b.awardedAt!);
        }
      }
    } catch (e) {
      // Non-critical background badge evaluation
    }
  }

  int _getTargetCountForBadge(String id) {
    switch (id) {
      case 'primer_pas':
      case 'primer_pas_al_bosc':
      case 'alianca_silvestre':
        return 1;
      case 'cacador_rovellons':
      case 'cacador_de_rovellons':
        return 2;
      case 'micoleg_prudent':
        return 5;
      case 'cistell_tardor':
      case 'cistell_de_tardor':
        return 15;
      case 'mestre_boletaire':
        return 50;
      default:
        return 1;
    }
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header with confidence chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resultat d\'arbre indicador',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLowConfidence
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isLowConfidence ? Colors.orange : Colors.green,
                          ),
                        ),
                        child: Text(
                          '${(top.confidence * 100).toInt()}% coincidència',
                          style: TextStyle(
                            color:
                                isLowConfidence ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.bold,
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.park,
                              size: 32,
                              color: Colors.white,
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_arbre != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  _arbre!.scientificName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white60,
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
                            icon: Icons.eco,
                            label: 'Fulla',
                            value: _arbre!.leafType,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTraitChip(
                            context,
                            icon: Icons.texture,
                            label: 'Escorça',
                            value: _arbre!.barkDescription,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTraitChip(
                      context,
                      icon: Icons.landscape,
                      label: 'Sòl típic',
                      value: _arbre!.typicalSoil,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Associated mushrooms section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color ??
                          const Color(0xFF1E2D22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Bolets que pots cercar sota aquest arbre:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                              return ActionChip(
                                avatar: const Icon(Icons.grass, size: 16),
                                label: Text(
                                  bolet.catalanName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.white10,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  try {
                                    context.push('/boscdex/${bolet.id}');
                                  } catch (_) {
                                    // Non-fatal if rendered without GoRouter in tests
                                  }
                                },
                              );
                            }).toList(),
                          )
                        else
                          const Text(
                            'Sense bolets associats catalogats.',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white54),
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
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
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
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.park),
                      label: const Text(
                        'Veure fitxa completa de l\'arbre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onInspected?.call();
                        try {
                          context.push('/arbre/${top.arbreId}');
                        } catch (_) {
                          // Non-fatal if rendered without GoRouter in tests
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Tancar',
                        style: TextStyle(color: Colors.white54),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.tertiary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            Text(
              '$pct%',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: candidate.confidence,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
