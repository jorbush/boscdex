import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/avistaments.dart';

part 'avistament_dao.g.dart';

@DriftAccessor(tables: [Avistaments])
class AvistamentDao extends DatabaseAccessor<AppDatabase>
    with _$AvistamentDaoMixin {
  AvistamentDao(AppDatabase db) : super(db);

  Future<void> insertAvistament(AvistamentsCompanion avistament) async {
    await into(avistaments).insert(avistament);
  }

  Stream<List<Avistament>> getAllAvistaments() {
    return select(avistaments).watch();
  }

  Future<List<Avistament>> getAvistamentsByBolet(String boletId) {
    return (select(avistaments)..where((t) => t.boletId.equals(boletId))).get();
  }

  Future<void> deleteAvistament(String id) async {
    await (delete(avistaments)..where((t) => t.id.equals(id))).go();
  }
}
