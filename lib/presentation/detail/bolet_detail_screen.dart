import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/species_localizer.dart';
import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/bolet_dao.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/reference_photo_provider.dart';
import '../../domain/models/culinary_recipe.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';
import '../../domain/services/photo_export_service.dart';
import '../../domain/services/species_distribution_service.dart';
import '../journal/avistament_detail_sheet.dart';
import '../shared/photo_zoom_dialog.dart';
import 'catalonia_pixel_map.dart';
import 'morphology_section.dart';
import 'season_indicator.dart';
import 'toxic_twin_alert.dart';
import 'traditional_recipe_card.dart';

class BoletDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const BoletDetailScreen({super.key, required this.id});

  @override
  ConsumerState<BoletDetailScreen> createState() => _BoletDetailScreenState();
}

class _BoletDetailScreenState extends ConsumerState<BoletDetailScreen> {
  AppLocalizations get l10n => AppLocalizations.of(context);

  Bolet? _bolet;
  List<Arbre> _arbres = [];
  List<ToxicLookalikeWithNotes> _toxicLookalikes = [];
  List<Avistament> _avistaments = [];
  bool _isDiscovered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(BoletDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _isLoading = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final db = ref.read(appDatabaseProvider);
    final dao = db.boletDao;
    final arbreDao = db.arbreDao;
    final avistamentDao = db.avistamentDao;

    final bolet = await dao.getBoletById(widget.id);
    if (!mounted) return;

    if (bolet != null) {
      final arbres = await arbreDao.getArbresByBoletId(widget.id);
      final toxicLookalikes = await dao.getToxicLookalikesWithNotes(widget.id);
      final avistaments = await avistamentDao.getAvistamentsByBolet(widget.id);
      final isDiscoveredInDb = await db.descobrimentDao.isDiscovered(widget.id);
      final isDiscovered = isDiscoveredInDb || avistaments.isNotEmpty;
      if (!mounted) return;

      setState(() {
        _bolet = bolet;
        _arbres = arbres;
        _toxicLookalikes = toxicLookalikes;
        _avistaments = avistaments;
        _isDiscovered = isDiscovered;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<int> _parseMonths(String fruitingSeason) {
    try {
      final List<dynamic> parsed = jsonDecode(fruitingSeason);
      return parsed.map((e) => (e as num).toInt()).toList();
    } catch (_) {
      try {
        final clean = fruitingSeason.replaceAll(RegExp(r'[\[\]\s]'), '');
        if (clean.isEmpty) return [];
        return clean.split(',').map(int.parse).toList();
      } catch (e) {
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = AppLocalizations.of(context);
    final bolet = _bolet;
    if (bolet == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notFoundTitle)),
        body: Center(
          child: Text(
            l10n.boletNotFoundMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: RetroColors.inkSoft,
            ),
          ),
        ),
      );
    }

    final fruitingMonths = _parseMonths(bolet.fruitingSeason);
    final edibilitat = EdibilitatExtension.fromString(bolet.edibility);
    final raritatTier = RaritatTierExtension.fromString(bolet.rarityTier);
    final isInfoUnlocked = _isDiscovered || edibilitat.isToxic;

    final dexNum = bolet.dexNumber.toString().padLeft(3, '0');

    final refPhotoService = ref.watch(referencePhotoServiceProvider);
    final refAssetPath = refPhotoService.getReferenceAssetPath(bolet.id);
    final photoAttr = refPhotoService.getAttribution(bolet.id);

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230.0,
            pinned: true,
            backgroundColor: RetroColors.creamBg,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Semantics(
                button: true,
                label: l10n.back,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/boscdex');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: RetroColors.ink, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: RetroColors.ink,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: RetroColors.ink,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Cover Image (Discovered or Toxic) or Mystery Overlay
                  if (isInfoUnlocked && refAssetPath.isNotEmpty) ...[
                    Image.asset(
                      refAssetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: edibilitat.color.withOpacity(0.18),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.16),
                    ),
                  ] else
                    Container(
                      color: RetroColors.screenOverlay,
                    ),

                  // 2. Retro Bottom Border
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 3,
                      color: RetroColors.ink,
                    ),
                  ),

                  // 3. Central Pixel-Art Card
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: _isDiscovered
                            ? Colors.white
                            : RetroColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: RetroColors.ink, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: RetroColors.ink,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: _isDiscovered
                            ? Image.asset(
                                bolet.imageAssetPath ??
                                    'assets/images/mushrooms/${bolet.id}.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                  bolet.catalanName.isNotEmpty
                                      ? bolet.catalanName
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 76,
                                    fontWeight: FontWeight.w900,
                                    color: edibilitat.color,
                                  ),
                                ),
                              )
                            : ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  RetroColors.ink,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  bolet.imageAssetPath ??
                                      'assets/images/mushrooms/${bolet.id}.png',
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text(
                                    '🍄',
                                    style: TextStyle(fontSize: 64),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  // 4. Magnifying Glass Button at Bottom Right (Discovered or Toxic)
                  if (isInfoUnlocked && refAssetPath.isNotEmpty)
                    Positioned(
                      right: 14,
                      bottom: 14,
                      child: Semantics(
                        button: true,
                        label: l10n.zoomPhoto,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            PhotoZoomDialog.show(
                              context: context,
                              assetPath: refAssetPath,
                              title: SpeciesLocalizer.getMushroomName(
                                bolet.id,
                                languageCode: l10n.languageCode,
                                fallbackName: bolet.catalanName,
                              ),
                              subtitle: bolet.scientificName,
                              attribution: photoAttr != null
                                  ? '${photoAttr.author} (${photoAttr.licenseName})'
                                  : null,
                            );
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: RetroColors.ink, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: RetroColors.ink,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.zoom_in_rounded,
                              color: RetroColors.ink,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Scientific Name
                  if (!isInfoUnlocked) ...[
                    Text(
                      '#$dexNum ???',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.unregisteredSpecies,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ] else ...[
                    Text(
                      SpeciesLocalizer.getMushroomName(
                        bolet.id,
                        languageCode: AppLocalizations.of(context).languageCode,
                        fallbackName: bolet.catalanName,
                      ),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolet.scientificName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Badges Row
                  if (!_isDiscovered && !edibilitat.isToxic) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: RetroColors.mintMuted,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_outline_rounded,
                                  size: 14, color: RetroColors.ink),
                              const SizedBox(width: 6),
                              Text(
                                l10n.notDiscoveredBadge,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: RetroColors.ink,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            l10n.edibilityUnknown,
                            style: const TextStyle(
                              color: RetroColors.inkSoft,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (!_isDiscovered && edibilitat.isToxic) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: RetroColors.mintMuted,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_outline_rounded,
                                  size: 14, color: RetroColors.ink),
                              const SizedBox(width: 6),
                              Text(
                                l10n.notDiscoveredBadge,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: RetroColors.ink,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: edibilitat.badgeBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(edibilitat.icon,
                                  size: 14, color: edibilitat.badgeIconColor),
                              const SizedBox(width: 6),
                              Text(
                                edibilitat.localizedLabel(context),
                                style: TextStyle(
                                  color: edibilitat.badgeIconColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: edibilitat.color,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            l10n.edibilityLabel(edibilitat),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: RetroColors.ink,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            l10n.rarityLabel(raritatTier),
                            style: TextStyle(
                              color: raritatTier.color,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Critical Safety Alerts: Toxic Lookalike Warnings (Always visible for safety)
                  if (_toxicLookalikes.isNotEmpty) ...[
                    for (final twin in _toxicLookalikes)
                      ToxicTwinAlert(
                        lookalikeId: twin.lookalike.id,
                        lookalikeName: SpeciesLocalizer.getMushroomName(
                          twin.lookalike.id,
                          languageCode: l10n.languageCode,
                          fallbackName: twin.lookalike.catalanName,
                        ),
                        comparisonNotes: SpeciesLocalizer.getComparisonNotes(
                          bolet.id,
                          twin.lookalike.id,
                          languageCode: l10n.languageCode,
                          fallback: twin.comparisonNotes,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(toxicComparisonViewCountProvider.notifier)
                              .increment();
                          context.push('/boscdex/${twin.lookalike.id}');
                        },
                      ),
                    const SizedBox(height: 20),
                  ],

                  // For discovered species: user captures
                  if (_isDiscovered) ...[
                    _buildUserCapturesSection(context),
                    const SizedBox(height: 24),
                  ],

                  // HABITAT & DISTRIBUTION (Location - Pokémon Pokédex feature)
                  _buildHabitatAndDistributionSection(
                      context, bolet, fruitingMonths),
                  const SizedBox(height: 24),

                  // Locked vs Revealed Morphology & Exploration actions
                  if (!isInfoUnlocked) ...[
                    _buildLockedMorphologyCard(),
                    const SizedBox(height: 24),
                    _buildSearchInForestCta(context),
                  ] else ...[
                    MorphologySection(
                      cap: SpeciesLocalizer.getCapDescription(
                        bolet.id,
                        languageCode: l10n.languageCode,
                        fallback: bolet.capDescription,
                      ),
                      gills: SpeciesLocalizer.getGillsDescription(
                        bolet.id,
                        languageCode: l10n.languageCode,
                        fallback: bolet.gillsDescription,
                      ),
                      stem: SpeciesLocalizer.getStemDescription(
                        bolet.id,
                        languageCode: l10n.languageCode,
                        fallback: bolet.stemDescription,
                      ),
                      latex: SpeciesLocalizer.getLatexDescription(
                        bolet.id,
                        languageCode: l10n.languageCode,
                        fallback: bolet.latexDescription,
                      ),
                    ),
                    if (bolet.safetyNotes != null &&
                        bolet.safetyNotes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSafetyNotesCard(bolet.id, bolet.safetyNotes!),
                    ],
                    if (!_isDiscovered && edibilitat.isToxic) ...[
                      const SizedBox(height: 24),
                      _buildToxicSafetyAdvisoryCard(context),
                    ] else if (!_isDiscovered) ...[
                      const SizedBox(height: 24),
                      _buildSearchInForestCta(context),
                    ],
                    () {
                      final culinaryRecipe =
                          CulinaryRecipe.forSpecies(bolet.id);
                      if (culinaryRecipe != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TraditionalRecipeCard(recipe: culinaryRecipe),
                        );
                      }
                      return const SizedBox.shrink();
                    }(),
                  ],
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitatAndDistributionSection(
      BuildContext context, Bolet bolet, List<int> fruitingMonths) {
    final zones = SpeciesDistributionService.getZonesForSpecies(bolet.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.explore_rounded,
                size: 22, color: RetroColors.forestGreen),
            const SizedBox(width: 8),
            Text(
              l10n.habitatAndDistribution,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: RetroColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.explorationClues,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: RetroColors.inkSoft,
          ),
        ),
        const SizedBox(height: 16),

        // 1. Regional Pixel Art Map of Catalonia (Pokédex Area Map)
        CataloniaPixelMap(
          activeZones: zones,
          speciesName: _isDiscovered
              ? SpeciesLocalizer.getMushroomName(
                  bolet.id,
                  languageCode: l10n.languageCode,
                  fallbackName: bolet.catalanName,
                )
              : null,
        ),
        const SizedBox(height: 18),

        // 2. Associated Trees (Indicator Forest Partners)
        if (_arbres.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.park_rounded,
                        size: 18, color: RetroColors.forestGreen),
                    const SizedBox(width: 6),
                    Text(
                      l10n.associatedTrees,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.mycorrhizalNotice,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: RetroColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _arbres
                      .map(
                        (arbre) => ActionChip(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                              color: RetroColors.ink, width: 2),
                          elevation: 0,
                          pressElevation: 0,
                          shadowColor: Colors.transparent,
                          avatar: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: Image.asset(
                                arbre.imageAssetPath ??
                                    'assets/images/trees/${arbre.id}.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.park_rounded,
                                  size: 16,
                                  color: RetroColors.forestGreen,
                                ),
                              ),
                            ),
                          ),
                          label: Text(
                            SpeciesLocalizer.getTreeName(
                              arbre.id,
                              languageCode: l10n.languageCode,
                              fallbackName: arbre.catalanName,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: RetroColors.ink,
                            ),
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            context.push('/arbre/${arbre.id}');
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 2. Seasonality Strip
        SeasonIndicator(fruitingMonths: fruitingMonths),
        const SizedBox(height: 16),

        // 3. Elevation Range
        if (bolet.altitudeMin != null && bolet.altitudeMax != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terrain_rounded,
                        size: 18, color: RetroColors.forestGreen),
                    const SizedBox(width: 6),
                    Text(
                      l10n.fruitingAltitude,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.elevationRange(bolet.altitudeMin!, bolet.altitudeMax!),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: RetroColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLockedMorphologyCard() {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_rounded,
                  size: 20, color: RetroColors.arcadeRed),
              const SizedBox(width: 8),
              Text(
                l10n.lockedMorphologyTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.lockedMorphologyDescription,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: RetroColors.inkSoft,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToxicSafetyAdvisoryCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: RetroDecorations.card(
        backgroundColor: const Color(0xFFFCE8E7),
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_rounded,
                size: 20,
                color: RetroColors.arcadeRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.toxicSafetyAdvisoryTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: RetroColors.arcadeRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.toxicSafetyAdvisoryBody,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: RetroColors.ink,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInForestCta(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: RetroDecorations.card(
        backgroundColor: RetroColors.mintMuted,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.travel_explore_rounded,
                  size: 20, color: RetroColors.forestGreen),
              const SizedBox(width: 8),
              Text(
                l10n.readyForExpedition,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.expeditionPrompt,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: RetroColors.inkSoft,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: RetroColors.forestGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: RetroColors.ink, width: 2),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.go('/scan');
              },
              icon: const Icon(Icons.camera_alt_rounded, size: 18),
              label: Text(
                l10n.searchWithCamera,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyNotesCard(String boletId, String safetyNotes) {
    final l10n = AppLocalizations.of(context);
    final localizedNotes = SpeciesLocalizer.getSafetyNotes(
          boletId,
          languageCode: l10n.languageCode,
          fallback: safetyNotes,
        ) ??
        safetyNotes;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RetroDecorations.card(
        backgroundColor: const Color(0xFFFFFBEA),
        borderColor: RetroColors.goldCoin,
        borderWidth: 2,
        shadowOffset: 3,
        shadowColor: RetroColors.ink,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: Color(0xFFB8860B), size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.notes,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            localizedNotes,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: RetroColors.inkSoft,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCapturesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasCaptures = _avistaments.isNotEmpty;
    final shortDateFormat = DateFormat('d MMM');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.camera_alt_rounded,
                size: 20, color: RetroColors.forestGreen),
            const SizedBox(width: 8),
            Text(
              l10n.yourCaptures(_avistaments.length),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: RetroColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (hasCaptures)
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _avistaments.length,
              itemBuilder: (context, index) {
                final avistament = _avistaments[index];
                final photoPath = avistament.photoPath;
                final confidence = avistament.confidenceScore ?? 0.0;
                final confidencePct = (confidence * 100).toInt();

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    AvistamentDetailSheet.show(
                      context,
                      avistament,
                      onDeleted: _loadData,
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12, bottom: 4),
                    decoration: RetroDecorations.card(
                      backgroundColor: Colors.black,
                      borderColor: RetroColors.ink,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (photoPath != null)
                          Image.file(
                            PhotoExportService.resolveFile(photoPath),
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Center(
                              child: Image.asset(
                                'assets/images/mushrooms/${avistament.boletId}.png',
                                width: 50,
                                height: 50,
                                filterQuality: FilterQuality.none,
                                errorBuilder: (ctx, err, st) => const Text('🍄',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Image.asset(
                              'assets/images/mushrooms/${avistament.boletId}.png',
                              width: 50,
                              height: 50,
                              filterQuality: FilterQuality.none,
                              errorBuilder: (ctx, err, st) => const Text('🍄',
                                  style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        // Bottom overlay gradient + tags
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.85),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  shortDateFormat.format(avistament.timestamp),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: confidence >= 0.70
                                        ? RetroColors.forestGreen
                                        : RetroColors.goldCoin,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$confidencePct%',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      color: confidence >= 0.70
                                          ? Colors.white
                                          : RetroColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: RetroDecorations.card(
              backgroundColor: Colors.white,
              borderColor: RetroColors.ink,
              borderWidth: 2,
              shadowOffset: 3,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: RetroColors.sectionBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: RetroColors.ink, width: 1.5),
                  ),
                  child: const Center(
                    child: Text('📷', style: TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.noCapturesYet,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.noCapturesPrompt,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: RetroColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroColors.forestGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side:
                          const BorderSide(color: RetroColors.ink, width: 1.5),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    context.go('/scan');
                  },
                  child: Text(
                    l10n.tabScan,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
