import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';

final avistamentsProvider = StreamProvider<List<Avistament>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.avistamentDao.getAllAvistaments();
});

/// Provides a map of bolet ID -> catalanName for resolving sightings in the journal.
final allBoletsMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final bolets = await db.boletDao.getAllBolets();
  return {for (final b in bolets) b.id: b.catalanName};
});
