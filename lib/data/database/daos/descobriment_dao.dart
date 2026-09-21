import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/descobriments.dart';

part 'descobriment_dao.g.dart';

@DriftAccessor(tables: [Descobriments])
class DescobrimentDao extends DatabaseAccessor<AppDatabase>
    with _$DescobrimentDaoMixin {
  DescobrimentDao(AppDatabase db) : super(db);

  Future<void> markDiscovered(
      String boletId, DateTime at, String? avistamentId) async {
    await into(descobriments).insert(
      DescobrimentsCompanion.insert(
        boletId: boletId,
        discoveredAt: at,
        firstAvistamentId: Value(avistamentId),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<bool> isDiscovered(String boletId) async {
    final record = await (select(descobriments)
          ..where((t) => t.boletId.equals(boletId)))
        .getSingleOrNull();
    return record != null;
  }

  Future<int> getDiscoveryCount() async {
    final countExp = descobriments.boletId.count();
    final query = selectOnly(descobriments)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Stream<int> watchDiscoveryCount() {
    final countExp = descobriments.boletId.count();
    final query = selectOnly(descobriments)..addColumns([countExp]);
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  Future<List<Descobriment>> getAllDiscoveries() => select(descobriments).get();

  Stream<List<Descobriment>> watchAllDiscoveries() =>
      select(descobriments).watch();
}
