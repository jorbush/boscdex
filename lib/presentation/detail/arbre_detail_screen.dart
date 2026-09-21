import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';

class ArbreDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const ArbreDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ArbreDetailScreen> createState() => _ArbreDetailScreenState();
}

class _ArbreDetailScreenState extends ConsumerState<ArbreDetailScreen> {
  Arbre? _arbre;
  List<Bolet> _bolets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(appDatabaseProvider);
    final arbreDao = db.arbreDao;
    final boletDao = db.boletDao;

    final arbre = await arbreDao.getArbreById(widget.id);
    if (!mounted) return;

    if (arbre != null) {
      ref.read(visitedArbresProvider.notifier).markVisited(arbre.id);
      final bolets = await boletDao.getBoletsByArbreId(widget.id);
      if (!mounted) return;

      setState(() {
        _arbre = arbre;
        _bolets = bolets;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final arbre = _arbre;
    if (arbre == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No trobat')),
        body: const Center(
          child: Text(
            'Aquest arbre no existeix.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: RetroColors.inkSoft,
            ),
          ),
        ),
      );
    }

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
                  color: RetroColors.forestGreen.withOpacity(0.18),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Image.asset(
                        arbre.imageAssetPath ??
                            'assets/images/trees/${arbre.id}.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(
                            Icons.park_rounded,
                            size: 76,
                            color: RetroColors.forestGreen,
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
                  Text(
                    arbre.catalanName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: RetroColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arbre.scientificName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: RetroColors.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description fields
                  _buildInfoCard(context, 'Escorça', arbre.barkDescription,
                      Icons.texture_rounded),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, 'Fulla', arbre.leafType,
                      Icons.energy_savings_leaf_rounded),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, 'Sòl Típic', arbre.typicalSoil,
                      Icons.terrain_rounded),
                  const SizedBox(height: 24),

                  // Bolets
                  if (_bolets.isNotEmpty) ...[
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/silhouettes/generic_mushroom.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('🍄', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Bolets associats',
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
                      children: _bolets
                          .map(
                            (bolet) => ActionChip(
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
                                    bolet.imageAssetPath ??
                                        'assets/images/mushrooms/${bolet.id}.png',
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.none,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/silhouettes/generic_mushroom.png',
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.none,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Text('🍄',
                                              style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                ),
                              ),
                              label: Text(
                                bolet.catalanName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: RetroColors.ink,
                                ),
                              ),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                context.push('/boscdex/${bolet.id}');
                              },
                            ),
                          )
                          .toList(),
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

  Widget _buildInfoCard(
      BuildContext context, String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: RetroColors.forestGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: RetroColors.forestGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: RetroColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: RetroColors.inkSoft,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
