import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';

final avistamentsProvider = StreamProvider<List<Avistament>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.avistamentDao.getAllAvistaments();
});
