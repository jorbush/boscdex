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

import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/nivell_seguretat.dart';
import '../../domain/services/badge_progression_service.dart';
import '../../domain/services/safety_gate_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/sound_provider.dart';
import '../journal/journal_map_projection.dart';
import '../shared/edibility_badge.dart';
import '../shared/safety_alert_box.dart';
import '../boscdex/boscdex_provider.dart';
import 'botanical_safety_check_dialog.dart';

/// Modal bottom sheet displaying the top-3 ML mushroom classification candidates,
/// confidence bars, safety gate alerts, and the registration CTA.
class MushroomClassificationResultSheet extends ConsumerStatefulWidget {
  final List<MushroomClassificationResult> results;
  final Uint8List? imageBytes;
  final Position? initialLocation;
  final VoidCallback? onRegistered;

  const MushroomClassificationResultSheet({
    super.key,
    required this.results,
    this.imageBytes,
    this.initialLocation,
    this.onRegistered,
  });

  @override
  ConsumerState<MushroomClassificationResultSheet> createState() =>
      _MushroomClassificationResultSheetState();
}

/// Backwards-compatible alias for [MushroomClassificationResultSheet].
typedef ClassificationResultSheet = MushroomClassificationResultSheet;

class _SafetyEvaluation {
  final SafetyGateService service;
  final NivellSeguretat level;
  final ClassificacioResult? lethalCandidate;
  final bool isLethalRisk;
  final bool isToxic;
  final bool requiresSafetyCheck;

  const _SafetyEvaluation({
    required this.service,
    required this.level,
    this.lethalCandidate,
    required this.isLethalRisk,
    required this.isToxic,
    required this.requiresSafetyCheck,
  });
}

class _MushroomClassificationResultSheetState
    extends ConsumerState<MushroomClassificationResultSheet> {
  bool _isSaving = false;
  Bolet? _topBolet;
  List<Bolet> _lookalikes = [];
  Map<String, Edibilitat> _candidateEdibilities = {};
  bool _loadingDetails = true;
  Position? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.initialLocation;
    _loadBoletDetails();
    if (_location == null) {
      _fetchLocation();
    }
  }

  Future<void> _fetchLocation() async {
    try {
      final loc = await ref.read(locationServiceProvider).getCurrentPosition();
      if (mounted && loc != null) {
        setState(() => _location = loc);
      }
    } catch (_) {}
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

      final candidateEdibilities = <String, Edibilitat>{};
      for (final candidate in widget.results.take(3)) {
        final b = await db.boletDao.getBoletById(candidate.boletId);
        if (b != null) {
          candidateEdibilities[candidate.boletId] =
              EdibilitatExtension.fromString(b.edibility);
        }
      }

      if (mounted) {
        setState(() {
          _topBolet = bolet;
          _lookalikes = lookalikes;
          _candidateEdibilities = candidateEdibilities;
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

  _SafetyEvaluation _evaluateCurrentSafety() {
    if (widget.results.isEmpty) {
      final dummyService = SafetyGateService(toxicLookalikesData: const {});
      return _SafetyEvaluation(
        service: dummyService,
        level: NivellSeguretat.incert,
        lethalCandidate: null,
        isLethalRisk: false,
        isToxic: false,
        requiresSafetyCheck: true,
      );
    }

    final topCandidate = widget.results.first;
    final topEdibility = _topBolet != null
        ? EdibilitatExtension.fromString(_topBolet!.edibility)
        : null;

    final service = SafetyGateService(
      toxicLookalikesData: {
        topCandidate.boletId: _lookalikes.map((l) => l.id).toList(),
      },
      confidenceThreshold: AppConstants.confidenceThreshold,
    );

    final level = service.evaluateSafety(
      widget.results,
      edibility: topEdibility,
      candidatesEdibility: _candidateEdibilities,
    );

    final lethalCandidate = service.findLethalCandidate(
      widget.results,
      candidatesEdibility: _candidateEdibilities,
    );

    final isLethalRisk =
        lethalCandidate != null || topEdibility == Edibilitat.mortal;
    final isToxic = topEdibility == Edibilitat.toxic;

    final requiresSafetyCheck = level != NivellSeguretat.segur ||
        _lookalikes.isNotEmpty ||
        isLethalRisk ||
        isToxic;

    return _SafetyEvaluation(
      service: service,
      level: level,
      lethalCandidate: lethalCandidate,
      isLethalRisk: isLethalRisk,
      isToxic: isToxic,
      requiresSafetyCheck: requiresSafetyCheck,
    );
  }

  Future<void> _registerSighting() async {
    if (widget.results.isEmpty || _isSaving) return;

    final safety = _evaluateCurrentSafety();
    final topCandidate = widget.results.first;

    if (safety.requiresSafetyCheck) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await BotanicalSafetyCheckDialog.show(
        context,
        speciesId: topCandidate.boletId,
        speciesName: SpeciesLocalizer.getMushroomName(
          topCandidate.boletId,
          languageCode: l10n.languageCode,
          fallbackName: topCandidate.displayName,
        ),
        isLethalRisk: safety.isLethalRisk,
        isToxic: safety.isToxic,
      );
      if (!mounted) return;
      if (!confirmed) {
        return;
      }
    }

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

      // 1. Insert avistament in journal with GPS coordinates
      Position? loc = _location;
      if (loc == null) {
        try {
          loc = await ref.read(locationServiceProvider).getCurrentPosition();
        } catch (_) {}
      }

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          boletId: drift.Value(topCandidate.boletId),
          timestamp: drift.Value(now),
          latitude: drift.Value(loc?.latitude),
          longitude: drift.Value(loc?.longitude),
          altitude: drift.Value(
              loc != null && loc.altitude != 0.0 ? loc.altitude : null),
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
        final l10n = AppLocalizations.of(context);
        Navigator.of(context).pop();

        final msg =
            wasDiscovered ? l10n.newSightingSaved : l10n.newBoletUnlocked;

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
    final l10n = AppLocalizations.of(context);
    if (widget.results.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.noClassificationResults),
      );
    }

    final top = widget.results.first;
    final Edibilitat? edibilitat = _topBolet != null
        ? EdibilitatExtension.fromString(_topBolet!.edibility)
        : null;

    final safety = _evaluateCurrentSafety();
    final safetyService = safety.service;
    final safetyLevel = safety.level;
    final lethalCandidate = safety.lethalCandidate;
    final isLethalRisk = safety.isLethalRisk;
    final isLowConfidence = top.confidence < AppConstants.confidenceThreshold;
    final isDanger = safetyLevel == NivellSeguretat.perill || isLethalRisk;

    // Collect secondary toxic candidate names for the alert box
    final secondaryToxicNames = <String>[];
    if (_candidateEdibilities.isNotEmpty &&
        top.confidence < safetyService.overwhelmingConfidenceThreshold) {
      for (final c in widget.results.skip(1).take(2)) {
        final ed = _candidateEdibilities[c.boletId];
        if ((ed == Edibilitat.toxic || ed == Edibilitat.mortal) &&
            c.confidence >= safetyService.secondaryToxicConfidenceThreshold) {
          secondaryToxicNames.add(SpeciesLocalizer.getMushroomName(
            c.boletId,
            languageCode: l10n.languageCode,
            fallbackName: c.displayName,
          ));
        }
      }
    }

    final lookalikeNames = _lookalikes
        .map((l) => SpeciesLocalizer.getMushroomName(
              l.id,
              languageCode: l10n.languageCode,
              fallbackName: l.catalanName,
            ))
        .toList();
    final allConfusionNames =
        {...lookalikeNames, ...secondaryToxicNames}.join(', ');
    final hasToxicLookalike = safetyLevel == NivellSeguretat.confusioPossible ||
        _lookalikes.isNotEmpty;

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
                        Expanded(
                          child: Text(
                            l10n.analysisResult,
                            style: const TextStyle(
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
                            l10n.matchConfidence(
                                (top.confidence * 100).toInt()),
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
                                  SpeciesLocalizer.getMushroomName(
                                    top.boletId,
                                    languageCode: AppLocalizations.of(context)
                                        .languageCode,
                                    fallbackName: _topBolet?.catalanName ??
                                        top.displayName,
                                  ),
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
                                    isLethalRisk
                                        ? l10n.dangerMortalAlertTitle
                                        : l10n.dangerToxicAlertTitle,
                                    style: const TextStyle(
                                      color: RetroColors.arcadeRed,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lethalCandidate != null &&
                                            lethalCandidate.boletId !=
                                                top.boletId
                                        ? l10n
                                            .dangerLethalCandidateAlertDescription(
                                            speciesName: SpeciesLocalizer
                                                .getMushroomName(
                                              lethalCandidate.boletId,
                                              languageCode: l10n.languageCode,
                                            ),
                                            confidencePercent:
                                                (lethalCandidate.confidence *
                                                        100)
                                                    .toInt(),
                                          )
                                        : l10n.dangerAlertDescription,
                                    style: const TextStyle(
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
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: RetroColors.questAmber, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.lowConfidenceWarning,
                                style: const TextStyle(
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
                    if (hasToxicLookalike && allConfusionNames.isNotEmpty) ...[
                      SafetyAlertBox(
                        confusionSpecies: allConfusionNames,
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
                      Text(
                        l10n.otherPossibleSpecies,
                        style: const TextStyle(
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

                    // GPS Coordinates indicator
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _location != null
                            ? RetroColors.mintWash
                            : RetroColors.sectionBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: RetroColors.ink, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _location != null
                                ? Icons.location_on_rounded
                                : Icons.location_searching_rounded,
                            size: 14,
                            color: _location != null
                                ? RetroColors.forestGreen
                                : RetroColors.inkSoft,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _location != null
                                ? '${JournalMapProjection.format(_location!.latitude, _location!.longitude)}${_location!.altitude != 0.0 ? " • ${_location!.altitude.round()} m" : ""}'
                                : l10n.searchingGpsSignal,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: _location != null
                                  ? RetroColors.forestGreen
                                  : RetroColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),

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
                              ? l10n.savingProgress
                              : l10n.registerToBoscdex,
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
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        l10n.educationalDisclaimerBanner,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: RetroColors.inkSoft,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          l10n.settingsClose,
                          style: const TextStyle(
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
              SpeciesLocalizer.getMushroomName(
                candidate.boletId,
                languageCode: AppLocalizations.of(context).languageCode,
                fallbackName: candidate.displayName,
              ),
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
