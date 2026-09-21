import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  const BoletDetailScreen({Key? key, required this.id}) : super(key: key);

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
        body: const Center(child: Text('Aquest bolet no existeix.')),
      );
    }

    final fruitingMonths = _parseMonths(bolet.fruitingSeason);

    final edibilitat = EdibilitatExtension.fromString(bolet.edibility);
    final raritatTier = RaritatTierExtension.fromString(bolet.rarityTier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _getEdibilityColor(edibilitat),
                child: Center(
                  child: Text(
                    bolet.catalanName.substring(0, 1).toUpperCase(),
                    style:
                        const TextStyle(fontSize: 100, color: Colors.white54),
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
                  Text(
                    bolet.catalanName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bolet.scientificName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Badges Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: edibilitat.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          edibilitat.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(color: raritatTier.color),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          raritatTier.label,
                          style: TextStyle(
                            color: raritatTier.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Lookalikes
                  if (_toxicLookalikes.isNotEmpty) ...[
                    for (final twin in _toxicLookalikes)
                      ToxicTwinAlert(
                        lookalikeName: twin.lookalike.catalanName,
                        comparisonNotes: twin.comparisonNotes,
                      ),
                    const SizedBox(height: 24),
                  ],

                  // Season
                  SeasonIndicator(fruitingMonths: fruitingMonths),
                  const SizedBox(height: 24),

                  // Altitude Range
                  if (bolet.altitudeMin != null &&
                      bolet.altitudeMax != null) ...[
                    const Text(
                      'Altitud',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '${bolet.altitudeMin}m - ${bolet.altitudeMax}m sobre el nivell del mar'),
                    const SizedBox(height: 24),
                  ],

                  // Morphology
                  MorphologySection(
                    cap: bolet.capDescription,
                    gills: bolet.gillsDescription,
                    stem: bolet.stemDescription,
                    latex: bolet.latexDescription,
                  ),
                  const SizedBox(height: 24),

                  // Trees
                  if (_arbres.isNotEmpty) ...[
                    const Text(
                      'Arbres associats',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _arbres
                          .map((arbre) => ActionChip(
                                label: Text(arbre.catalanName),
                                onPressed: () {
                                  context.push('/arbre/${arbre.id}');
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Safety Notes
                  if (bolet.safetyNotes != null &&
                      bolet.safetyNotes!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              const SizedBox(width: 8),
                              const Text(
                                'Notes',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(bolet.safetyNotes!),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEdibilityColor(Edibilitat edibilitat) {
    return edibilitat.color;
  }
}
