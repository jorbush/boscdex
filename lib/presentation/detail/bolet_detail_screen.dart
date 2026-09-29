import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/bolet_dao.dart';
import '../../providers/database_provider.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';
import '../../domain/services/photo_export_service.dart';
import '../../domain/services/species_distribution_service.dart';
import '../journal/avistament_detail_sheet.dart';
import 'catalonia_pixel_map.dart';
import 'morphology_section.dart';
import 'season_indicator.dart';
import 'toxic_twin_alert.dart';

class BoletDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const BoletDetailScreen({super.key, required this.id});

  @override
  ConsumerState<BoletDetailScreen> createState() => _BoletDetailScreenState();
}

class _BoletDetailScreenState extends ConsumerState<BoletDetailScreen> {
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

    final bolet = _bolet;
    if (bolet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No trobat')),
        body: const Center(
          child: Text(
            'Aquest bolet no existeix.',
            style: TextStyle(
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

    final dexNum = bolet.dexNumber.toString().padLeft(3, '0');

    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            backgroundColor: RetroColors.creamBg,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Semantics(
                button: true,
                label: 'Enrere',
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
              background: Container(
                decoration: BoxDecoration(
                  color: _isDiscovered
                      ? edibilitat.color.withOpacity(0.18)
                      : RetroColors.screenOverlay,
                  border: const Border(
                    bottom: BorderSide(color: RetroColors.ink, width: 3),
                  ),
                ),
                child: Center(
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
                  if (!_isDiscovered) ...[
                    Text(
                      '#$dexNum ???',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Espècie per catalogar',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: RetroColors.inkSoft,
                      ),
                    ),
                  ] else ...[
                    Text(
                      bolet.catalanName,
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
                  if (!_isDiscovered) ...[
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
                            children: const [
                              Icon(Icons.lock_outline_rounded,
                                  size: 14, color: RetroColors.ink),
                              SizedBox(width: 6),
                              Text(
                                'No descobert',
                                style: TextStyle(
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
                          child: const Text(
                            'Comestibilitat: ???',
                            style: TextStyle(
                              color: RetroColors.inkSoft,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
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
                            edibilitat.label,
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
                            raritatTier.label,
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

                  // For discovered species: user captures & toxic lookalikes
                  if (_isDiscovered) ...[
                    _buildUserCapturesSection(context),
                    const SizedBox(height: 24),
                    if (_toxicLookalikes.isNotEmpty) ...[
                      for (final twin in _toxicLookalikes)
                        ToxicTwinAlert(
                          lookalikeName: twin.lookalike.catalanName,
                          comparisonNotes: twin.comparisonNotes,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ],

                  // HABITAT & DISTRIBUTION (Location - Pokémon Pokédex feature)
                  _buildHabitatAndDistributionSection(
                      context, bolet, fruitingMonths),
                  const SizedBox(height: 24),

                  // Locked vs Revealed Morphology & Exploration actions
                  if (!_isDiscovered) ...[
                    _buildLockedMorphologyCard(),
                    const SizedBox(height: 24),
                    _buildSearchInForestCta(context),
                  ] else ...[
                    MorphologySection(
                      cap: bolet.capDescription,
                      gills: bolet.gillsDescription,
                      stem: bolet.stemDescription,
                      latex: bolet.latexDescription,
                    ),
                    if (bolet.safetyNotes != null &&
                        bolet.safetyNotes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSafetyNotesCard(bolet.safetyNotes!),
                    ],
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
          children: const [
            Icon(Icons.explore_rounded,
                size: 22, color: RetroColors.forestGreen),
            SizedBox(width: 8),
            Text(
              'Hàbitat i Distribució',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: RetroColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Pistes d\'exploració per localitzar aquest bolet al bosc',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: RetroColors.inkSoft,
          ),
        ),
        const SizedBox(height: 16),

        // 1. Regional Pixel Art Map of Catalonia (Pokédex Area Map)
        CataloniaPixelMap(
          activeZones: zones,
          speciesName: _isDiscovered ? bolet.catalanName : null,
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
                  children: const [
                    Icon(Icons.park_rounded,
                        size: 18, color: RetroColors.forestGreen),
                    SizedBox(width: 6),
                    Text(
                      'Arbres associats',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Forma micorrizes amb aquestes espècies. Cerca boscos on abundin:',
                  style: TextStyle(
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
                            arbre.catalanName,
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
                  children: const [
                    Icon(Icons.terrain_rounded,
                        size: 18, color: RetroColors.forestGreen),
                    SizedBox(width: 6),
                    Text(
                      'Altitud de fructificació',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: RetroColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${bolet.altitudeMin}m - ${bolet.altitudeMax}m sobre el nivell del mar',
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
            children: const [
              Icon(Icons.lock_rounded, size: 20, color: RetroColors.arcadeRed),
              SizedBox(width: 8),
              Text(
                'Claus Morfològiques Bloquejades',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Les característiques anatòmiques detallades (barret, làmines, peu i làtex) estan protegides. Escaneja un exemplar viu al bosc per desvelar les claus d\'identificació botànica.',
            style: TextStyle(
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

  Widget _buildSearchInForestCta(BuildContext context) {
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
            children: const [
              Icon(Icons.travel_explore_rounded,
                  size: 20, color: RetroColors.forestGreen),
              SizedBox(width: 8),
              Text(
                'A punt per a l\'expedició?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Visita els boscos i altituds indicats durant la temporada per trobar-lo i catalogar-lo a la teva Boscdex.',
            style: TextStyle(
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
              label: const Text(
                'Cercar amb la càmera',
                style: TextStyle(
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

  Widget _buildSafetyNotesCard(String safetyNotes) {
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
            children: const [
              Icon(Icons.lightbulb_rounded, color: Color(0xFFB8860B), size: 18),
              SizedBox(width: 8),
              Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: RetroColors.ink,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            safetyNotes,
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
    final hasCaptures = _avistaments.isNotEmpty;
    final shortDateFormat = DateFormat('d MMM');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.camera_alt_rounded,
                    size: 20, color: RetroColors.forestGreen),
                const SizedBox(width: 8),
                Text(
                  'Les Teves Captures (${_avistaments.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: RetroColors.ink,
                  ),
                ),
              ],
            ),
            if (hasCaptures)
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: RetroColors.forestGreen,
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                label: const Text(
                  'Nova foto',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go('/scan');
                },
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
                    children: const [
                      Text(
                        'Cap captura registrada',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Troba aquest bolet al bosc i escaneja\'l per afegir la teva foto!',
                        style: TextStyle(
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
                  child: const Text(
                    'Escanejar',
                    style: TextStyle(
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
