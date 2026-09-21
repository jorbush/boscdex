import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/constants/app_constants.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/insignia.dart' as domain;
import '../../domain/models/nivell_seguretat.dart';
import '../../domain/services/badge_service.dart';
import '../../domain/services/safety_gate_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';
import '../shared/edibility_badge.dart';
import '../shared/safety_alert_box.dart';
import '../boscdex/boscdex_provider.dart';

/// Modal bottom sheet displaying the top-3 ML classification candidates,
/// confidence bars, safety gate alerts, and the registration CTA.
class ClassificationResultSheet extends ConsumerStatefulWidget {
  final List<ClassificacioResult> results;
  final Uint8List? imageBytes;
  final VoidCallback? onRegistered;

  const ClassificationResultSheet({
    Key? key,
    required this.results,
    this.imageBytes,
    this.onRegistered,
  }) : super(key: key);

  @override
  ConsumerState<ClassificationResultSheet> createState() =>
      _ClassificationResultSheetState();
}

class _ClassificationResultSheetState
    extends ConsumerState<ClassificationResultSheet> {
  bool _isSaving = false;
  Bolet? _topBolet;
  List<Bolet> _lookalikes = [];
  bool _loadingDetails = true;

  @override
  void initState() {
    super.initState();
    _loadBoletDetails();
  }

  Future<void> _loadBoletDetails() async {
    if (widget.results.isEmpty) {
      setState(() => _loadingDetails = false);
      return;
    }

    final db = ref.read(appDatabaseProvider);
    final topCandidate = widget.results.first;

    final bolet = await db.boletDao.getBoletById(topCandidate.boletId);
    final lookalikes =
        await db.boletDao.getToxicLookalikes(topCandidate.boletId);

    if (mounted) {
      setState(() {
        _topBolet = bolet;
        _lookalikes = lookalikes;
        _loadingDetails = false;
      });
    }
  }

  Future<void> _registerSighting() async {
    if (widget.results.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(appDatabaseProvider);
      final topCandidate = widget.results.first;
      final avistamentId = const Uuid().v4();
      final now = DateTime.now();

      // 1. Insert avistament in journal
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          boletId: drift.Value(topCandidate.boletId),
          timestamp: drift.Value(now),
          confidenceScore: drift.Value(topCandidate.confidence),
          notes: drift.Value(
              'Avistament identificat amb Boscdex AI (${(topCandidate.confidence * 100).toInt()}% certesa)'),
        ),
      );

      // 2. Mark as discovered in Boscdex album
      final wasDiscovered =
          await db.descobrimentDao.isDiscovered(topCandidate.boletId);
      await db.descobrimentDao
          .markDiscovered(topCandidate.boletId, now, avistamentId);

      // 3. Evaluate and update badges
      final allDiscoveries = await db.descobrimentDao.getAllDiscoveries();
      final allInsignies = await db.insigniaDao.getAllInsignies();
      final toxicViews = ref.read(toxicComparisonViewCountProvider);

      final hasRovello =
          allDiscoveries.any((d) => d.boletId == 'lactarius_deliciosus');
      final hasPinetell =
          allDiscoveries.any((d) => d.boletId == 'lactarius_sanguifluus');

      // Check if user has both a mushroom and its indicator tree discovered/visited
      final associatedTrees =
          await db.boletDao.getAssociatedArbres(topCandidate.boletId);
      final visitedTrees = ref.read(visitedArbresProvider);
      final hasTreeAlliance =
          associatedTrees.any((a) => visitedTrees.contains(a.id));

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

      ref.invalidate(boscdexEntriesProvider);

      if (mounted) {
        Navigator.of(context).pop();

        final msg = wasDiscovered
            ? 'Nou avistament registrat al teu diari!'
            : '🎉 Nou bolet desbloquejat a la teva Boscdex!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 3),
          ),
        );

        widget.onRegistered?.call();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error saving sighting: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'ClassificationResultSheet',
      );
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en guardar l\'avistament: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
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
        child: const Text('No s\'han obtingut resultats d\'identificació.'),
      );
    }

    final top = widget.results.first;
    Edibilitat edibilitat = Edibilitat.senseValor;
    if (_topBolet != null) {
      edibilitat = EdibilitatExtension.fromString(_topBolet!.edibility);
    }

    final safetyService = SafetyGateService(
      toxicLookalikesData: {
        top.boletId: _lookalikes.map((l) => l.id).toList(),
      },
      confidenceThreshold: AppConstants.confidenceThreshold,
    );
    final safetyLevel = safetyService.evaluateSafety(
      widget.results,
      edibility: edibilitat,
    );

    final isLowConfidence = top.confidence < AppConstants.confidenceThreshold;
    final isDanger = safetyLevel == NivellSeguretat.perill;
    final hasToxicLookalike = _lookalikes.isNotEmpty;

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
                        'Resultat de l\'anàlisi',
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

                  // Top Match Card
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
                          child: Center(
                            child: Text(
                              _topBolet?.catalanName
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  top.displayName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _topBolet?.catalanName ?? top.displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_topBolet != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  _topBolet!.scientificName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              EdibilityBadge(edibilitat: edibilitat),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Safety Gate: High danger alert (toxic or mortal species)
                  if (isDanger) ...[
                    Container(
                      key: const Key('danger_alert_banner'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.dangerous,
                              color: Colors.redAccent, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  edibilitat == Edibilitat.mortal
                                      ? 'ATENCIÓ: ESPÈCIE MORTAL'
                                      : 'ATENCIÓ: ESPÈCIE TÒXICA',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Aquest bolet és verinós o mortal. No el consumeixis mai.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Safety Gate: Low confidence alert
                  if (isLowConfidence) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline,
                              color: Colors.amber, size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No es pot identificar amb certesa. Consulta un micòleg humà abans de consumir.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Safety Gate: Toxic Lookalike warning
                  if (hasToxicLookalike) ...[
                    SafetyAlertBox(
                      confusionSpecies:
                          _lookalikes.map((l) => l.catalanName).join(', '),
                      onTap: () {
                        // Increase comparison count for the badge
                        ref
                            .read(toxicComparisonViewCountProvider.notifier)
                            .increment();
                        Navigator.of(context).pop();
                        context.push('/boscdex/${top.boletId}');
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Candidate list (positions 2 & 3)
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

                  // Action Buttons
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
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.bookmark_add),
                      label: Text(
                        _isSaving
                            ? 'Registrant...'
                            : 'Registrar a la meva Boscdex',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _isSaving ? null : _registerSighting,
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

  Widget _buildCandidateRow(ClassificacioResult candidate) {
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
