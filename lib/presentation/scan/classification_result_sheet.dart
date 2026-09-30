import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../core/theme/retro_decorations.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/constants/app_constants.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/nivell_seguretat.dart';
import '../../domain/services/badge_progression_service.dart';
import '../../domain/services/safety_gate_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/sound_provider.dart';
import '../shared/edibility_badge.dart';
import '../shared/safety_alert_box.dart';
import '../boscdex/boscdex_provider.dart';

/// Modal bottom sheet displaying the top-3 ML mushroom classification candidates,
/// confidence bars, safety gate alerts, and the registration CTA.
class MushroomClassificationResultSheet extends ConsumerStatefulWidget {
  final List<MushroomClassificationResult> results;
  final Uint8List? imageBytes;
  final VoidCallback? onRegistered;

  const MushroomClassificationResultSheet({
    super.key,
    required this.results,
    this.imageBytes,
    this.onRegistered,
  });

  @override
  ConsumerState<MushroomClassificationResultSheet> createState() =>
      _MushroomClassificationResultSheetState();
}

/// Backwards-compatible alias for [MushroomClassificationResultSheet].
typedef ClassificationResultSheet = MushroomClassificationResultSheet;

class _MushroomClassificationResultSheetState
    extends ConsumerState<MushroomClassificationResultSheet> {
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
      if (mounted) setState(() => _loadingDetails = false);
      return;
    }

    try {
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
    } catch (e, stackTrace) {
      developer.log(
        'Error loading bolet details: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'ClassificationResultSheet',
      );
      if (mounted) {
        setState(() => _loadingDetails = false);
      }
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

      // Save scanned photo to persistent storage
      String? savedPhotoPath;
      if (widget.imageBytes != null && widget.imageBytes!.isNotEmpty) {
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final scansDir = Directory(p.join(appDir.path, 'scans'));
          if (!await scansDir.exists()) {
            await scansDir.create(recursive: true);
          }
          final fileName = 'scan_$avistamentId.jpg';
          final filePath = p.join(scansDir.path, fileName);
          final file = File(filePath);
          await file.writeAsBytes(widget.imageBytes!, flush: true);
          savedPhotoPath = 'scans/$fileName';
        } catch (e) {
          developer.log('Error saving scan image to disk: $e',
              name: 'ClassificationResultSheet');
        }
      }

      // 1. Insert avistament in journal
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          boletId: drift.Value(topCandidate.boletId),
          timestamp: drift.Value(now),
          photoPath: drift.Value(savedPhotoPath),
          confidenceScore: drift.Value(topCandidate.confidence),
          notes: const drift.Value(null),
        ),
      );

      // 2. Mark as discovered in Boscdex album
      final wasDiscovered =
          await db.descobrimentDao.isDiscovered(topCandidate.boletId);
      await db.descobrimentDao
          .markDiscovered(topCandidate.boletId, now, avistamentId);

      // 3. Evaluate and update badges via service
      final visitedTrees = ref.read(visitedArbresProvider);
      final toxicViews = ref.read(toxicComparisonViewCountProvider);
      final previousBadges = await db.insigniaDao.getAllInsignies();
      final updatedBadges =
          await BadgeProgressionService().syncBadgeProgression(
        db: db,
        toxicComparisonViewCount: toxicViews,
        visitedTreeIds: visitedTrees,
      );
      final prevAwardedIds = previousBadges
          .where((b) => b.awardedAt != null)
          .map((b) => b.id)
          .toSet();
      final hasNewBadge = updatedBadges
          .any((b) => b.isAwarded && !prevAwardedIds.contains(b.id));

      ref.invalidate(boscdexEntriesProvider);

      if (mounted) {
        final soundService = ref.read(soundEffectServiceProvider);
        if (hasNewBadge) {
          unawaited(soundService.playBadgeAward());
        } else if (!wasDiscovered) {
          unawaited(soundService.playDiscovery());
        }

        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final primaryColor = Theme.of(context).colorScheme.primary;
        Navigator.of(context).pop();

        final msg = wasDiscovered
            ? 'Nou avistament registrat al teu diari!'
            : '🎉 Nou bolet desbloquejat a la teva Boscdex!';

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: primaryColor,
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

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: const Text('No s\'han obtingut resultats d\'identificació.'),
      );
    }

    final top = widget.results.first;
    final Edibilitat? edibilitat = _topBolet != null
        ? EdibilitatExtension.fromString(_topBolet!.edibility)
        : null;

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

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
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
                        const Expanded(
                          child: Text(
                            'Resultat de l\'anàlisi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: RetroColors.ink,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLowConfidence
                                ? RetroColors.questAmber
                                : RetroColors.goldCoin,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
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

                    // Top Match Card
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
                              color: RetroColors.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: RetroColors.ink, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                _topBolet?.imageAssetPath ??
                                    'assets/images/mushrooms/${_topBolet?.id ?? top.boletId}.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildInitialPlaceholder(top.displayName),
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: RetroColors.ink,
                                  ),
                                ),
                                if (_topBolet != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _topBolet!.scientificName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: RetroColors.inkSoft,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                if (edibilitat != null) ...[
                                  const SizedBox(height: 6),
                                  EdibilityBadge(edibilitat: edibilitat),
                                ],
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
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: RetroColors.alertDangerLight,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: RetroColors.ink, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.arcadeRed,
                              offset: Offset(3, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: RetroColors.arcadeRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: RetroColors.ink, width: 2),
                              ),
                              child: const Icon(
                                Icons.dangerous_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    edibilitat == Edibilitat.mortal
                                        ? 'ATENCIÓ: ESPÈCIE MORTAL'
                                        : 'ATENCIÓ: ESPÈCIE TÒXICA',
                                    style: const TextStyle(
                                      color: RetroColors.arcadeRed,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Aquest bolet és verinós o mortal. No el consumeixis mai.',
                                    style: TextStyle(
                                      color: RetroColors.ink,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: RetroColors.alertWarningLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: RetroColors.ink, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.ink,
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.info_outline_rounded,
                                color: RetroColors.questAmber, size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'No es pot identificar amb certesa. Consulta un micòleg humà abans de consumir.',
                                style: TextStyle(
                                  color: RetroColors.ink,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          HapticFeedback.lightImpact();
                          // Increase comparison count for the badge
                          ref
                              .read(toxicComparisonViewCountProvider.notifier)
                              .increment();
                          Navigator.of(context).pop();
                          try {
                            GoRouter.of(context)
                                .push('/boscdex/${top.boletId}');
                          } catch (_) {
                            // Non-fatal if rendered without GoRouter in tests
                          }
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

                    // Action Buttons
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
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.bookmark_add_rounded),
                        label: Text(
                          _isSaving
                              ? 'Registrant...'
                              : 'Registrar a la meva Boscdex',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                        onPressed: _isSaving
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                _registerSighting();
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

  Widget _buildInitialPlaceholder(String defaultName) {
    final name = _topBolet?.catalanName ?? defaultName;
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return Container(
      color: RetroColors.forestGreen,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
