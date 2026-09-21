import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/bolet_dao.dart';
import '../../providers/database_provider.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';
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

    final bolet = await dao.getBoletById(widget.id);
    if (!mounted) return;

    if (bolet != null) {
      final arbres = await arbreDao.getArbresByBoletId(widget.id);
      final toxicLookalikes = await dao.getToxicLookalikesWithNotes(widget.id);
      if (!mounted) return;

      setState(() {
        _bolet = bolet;
        _arbres = arbres;
        _toxicLookalikes = toxicLookalikes;
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
                  color: edibilitat.color.withOpacity(0.18),
                  border: const Border(
                    bottom: BorderSide(color: RetroColors.ink, width: 3),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      child: Image.asset(
                        bolet.imageAssetPath ??
                            'assets/images/mushrooms/${bolet.id}.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                        errorBuilder: (context, error, stackTrace) => Text(
                          bolet.catalanName.isNotEmpty
                              ? bolet.catalanName.substring(0, 1).toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 76,
                            fontWeight: FontWeight.w900,
                            color: edibilitat.color,
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
                  const SizedBox(height: 16),

                  // Badges Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: edibilitat.color,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: RetroColors.ink, width: 2),
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
                          border: Border.all(color: RetroColors.ink, width: 2),
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
                  const SizedBox(height: 24),

                  // Lookalikes Alert
                  if (_toxicLookalikes.isNotEmpty) ...[
                    for (final twin in _toxicLookalikes)
                      ToxicTwinAlert(
                        lookalikeName: twin.lookalike.catalanName,
                        comparisonNotes: twin.comparisonNotes,
                      ),
                    const SizedBox(height: 20),
                  ],

                  // Season Indicator
                  SeasonIndicator(fruitingMonths: fruitingMonths),
                  const SizedBox(height: 24),

                  // Altitude Range
                  if (bolet.altitudeMin != null &&
                      bolet.altitudeMax != null) ...[
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
                                'Altitud',
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
                    const SizedBox(height: 24),
                  ],

                  // Morphology Section
                  MorphologySection(
                    cap: bolet.capDescription,
                    gills: bolet.gillsDescription,
                    stem: bolet.stemDescription,
                    latex: bolet.latexDescription,
                  ),
                  const SizedBox(height: 24),

                  // Associated Trees
                  if (_arbres.isNotEmpty) ...[
                    Row(
                      children: const [
                        Icon(Icons.park_rounded,
                            size: 18, color: RetroColors.forestGreen),
                        SizedBox(width: 6),
                        Text(
                          'Arbres associats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: RetroColors.ink,
                          ),
                        ),
                      ],
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                    const SizedBox(height: 24),
                  ],

                  // Safety Notes
                  if (bolet.safetyNotes != null &&
                      bolet.safetyNotes!.isNotEmpty) ...[
                    Container(
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
                              Icon(Icons.lightbulb_rounded,
                                  color: Color(0xFFB8860B), size: 18),
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
                            bolet.safetyNotes!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: RetroColors.inkSoft,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
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
}
