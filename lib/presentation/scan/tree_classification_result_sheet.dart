import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/classificacio_result.dart';
import '../../domain/services/badge_progression_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/reference_photo_provider.dart';
import '../../providers/sound_provider.dart';
import '../journal/journal_map_projection.dart';
import '../shared/tree_comparison_card.dart';

/// Modal bottom sheet displaying the ML classification results for indicator trees,
/// their morphological traits, and the prized edible/symbiotic mushrooms found beneath them.
class TreeClassificationResultSheet extends ConsumerStatefulWidget {
  final List<TreeClassificationResult> results;
  final Uint8List? imageBytes;
  final Position? initialLocation;
  final VoidCallback? onInspected;
  final VoidCallback? onRegistered;

  const TreeClassificationResultSheet({
    super.key,
    required this.results,
    this.imageBytes,
    this.initialLocation,
    this.onInspected,
    this.onRegistered,
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
  Position? _location;

  @override
  void initState() {
    super.initState();
    _location = widget.initialLocation;
    _loadTreeDetails();
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

  Future<bool> _evaluateBadges(String treeId) async {
    final db = ref.read(appDatabaseProvider);
    final toxicViews = ref.read(toxicComparisonViewCountProvider);
    final previousBadges = await db.insigniaDao.getAllInsignies();
    final prevAwardedIds = previousBadges
        .where((b) => b.awardedAt != null)
        .map((b) => b.id)
        .toSet();
    final updatedBadges = await BadgeProgressionService().syncBadgeProgression(
      db: db,
      toxicComparisonViewCount: toxicViews,
      currentTreeId: treeId,
    );
    return updatedBadges
        .any((b) => b.isAwarded && !prevAwardedIds.contains(b.id));
  }

  bool _isSaving = false;

  Future<void> _registerTreeSighting() async {
    if (widget.results.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    unawaited(HapticFeedback.mediumImpact());

    try {
      final db = ref.read(appDatabaseProvider);
      final top = widget.results.first;
      final avistamentId = const Uuid().v4();
      final now = DateTime.now();

      final wasVisitedBefore =
          ref.read(visitedArbresProvider).contains(top.arbreId);

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
          developer.log('Error saving tree scan photo: $e',
              name: 'TreeClassificationResultSheet');
        }
      }

      // Insert avistament in journal with GPS coordinates
      Position? loc = _location;
      if (loc == null) {
        try {
          loc = await ref.read(locationServiceProvider).getCurrentPosition();
        } catch (_) {}
      }

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: drift.Value(avistamentId),
          arbreId: drift.Value(top.arbreId),
          timestamp: drift.Value(now),
          latitude: drift.Value(loc?.latitude),
          longitude: drift.Value(loc?.longitude),
          altitude: drift.Value(
              loc != null && loc.altitude != 0.0 ? loc.altitude : null),
          photoPath: drift.Value(savedPhotoPath),
          confidenceScore: drift.Value(top.confidence),
          notes: const drift.Value(null),
        ),
      );

      // Mark tree as visited in preferences and sync badge progression
      ref.read(visitedArbresProvider.notifier).markVisited(top.arbreId);
      final hasNewBadge = await _evaluateBadges(top.arbreId);

      if (mounted) {
        final soundService = ref.read(soundEffectServiceProvider);
        if (hasNewBadge) {
          unawaited(soundService.playBadgeAward());
        } else if (!wasVisitedBefore) {
          unawaited(soundService.playDiscovery());
        }

        setState(() => _isSaving = false);
        final messenger = ScaffoldMessenger.of(context);
        final l10n = AppLocalizations.of(context);
        Navigator.of(context).pop();
        widget.onRegistered?.call();
        final treeDisplayName = SpeciesLocalizer.getTreeName(
          top.arbreId,
          languageCode: l10n.languageCode,
          fallbackName: _arbre?.catalanName ?? top.displayName,
        );
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              hasNewBadge
                  ? l10n.newBadgeUnlockedBanner
                  : l10n.treeSightingSaved(treeDisplayName),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: RetroColors.forestGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error registering tree sighting: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'TreeClassificationResultSheet',
      );
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en desar l\'avistament d\'arbre: $e'),
            backgroundColor: RetroColors.arcadeRed,
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
        child: Text(l10n.noTreeClassificationResults),
      );
    }

    final top = widget.results.first;
    final isLowConfidence = top.confidence < 0.70;

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
                            l10n.treeAnalysisResult,
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
                                  SpeciesLocalizer.getTreeName(
                                    top.arbreId,
                                    languageCode: AppLocalizations.of(context)
                                        .languageCode,
                                    fallbackName:
                                        _arbre?.catalanName ?? top.displayName,
                                  ),
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

                    // Botanical Reference & Live Comparison Card
                    if (_arbre != null) ...[
                      TreeComparisonCard(
                        userImageBytes: widget.imageBytes,
                        tree: _arbre!,
                        referencePhotoService:
                            ref.watch(referencePhotoServiceProvider),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botanical traits
                    if (_arbre != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildTraitChip(
                              context,
                              icon: Icons.eco_rounded,
                              label: l10n.leafTrait,
                              value: SpeciesLocalizer.getTreeLeafType(
                                _arbre!.id,
                                languageCode: l10n.languageCode,
                                fallback: _arbre!.leafType,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTraitChip(
                              context,
                              icon: Icons.texture_rounded,
                              label: l10n.barkTrait,
                              value: SpeciesLocalizer.getTreeBark(
                                _arbre!.id,
                                languageCode: l10n.languageCode,
                                fallback: _arbre!.barkDescription,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildTraitChip(
                        context,
                        icon: Icons.landscape_rounded,
                        label: l10n.soilTrait,
                        value: SpeciesLocalizer.getTreeSoil(
                          _arbre!.id,
                          languageCode: l10n.languageCode,
                          fallback: _arbre!.typicalSoil,
                        ),
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
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: RetroColors.forestGreen,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.searchMushroomsUnderTree,
                                style: const TextStyle(
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
                                      GoRouter.of(context)
                                          .push('/boscdex/${bolet.id}');
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
                                          SpeciesLocalizer.getMushroomName(
                                            bolet.id,
                                            languageCode: l10n.languageCode,
                                            fallbackName: bolet.catalanName,
                                          ),
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
                            Text(
                              l10n.noAssociatedBolets,
                              style: const TextStyle(
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

                    // Action Button: Register Tree Sighting
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        key: const Key('register_tree_sighting_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RetroColors.questAmber,
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
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation(RetroColors.ink),
                                ),
                              )
                            : const Icon(Icons.bookmark_add_rounded),
                        label: Text(
                          _isSaving
                              ? l10n.savingTreeProgress
                              : l10n.registerToJournal,
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
                                _registerTreeSighting();
                              },
                      ),
                    ),
                    const SizedBox(height: 12),

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
                        label: Text(
                          l10n.viewFullTreeCard,
                          style: const TextStyle(
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
              SpeciesLocalizer.getTreeName(
                candidate.arbreId,
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
