import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';

class ArbreDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ArbreDetailScreen({Key? key, required this.id}) : super(key: key);

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
        body: const Center(child: Text('Aquest arbre no existeix.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Icon(
                    Icons.park,
                    size: 100,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arbre.scientificName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Description fields
                  _buildInfoCard(context, 'Escorça', arbre.barkDescription),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, 'Fulla', arbre.leafType),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, 'Sòl Típic', arbre.typicalSoil),
                  const SizedBox(height: 24),

                  // Bolets
                  if (_bolets.isNotEmpty) ...[
                    const Text(
                      'Bolets associats',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _bolets
                          .map((bolet) => ActionChip(
                                label: Text(bolet.catalanName),
                                onPressed: () {
                                  context.push('/boscdex/${bolet.id}');
                                },
                              ))
                          .toList(),
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

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
