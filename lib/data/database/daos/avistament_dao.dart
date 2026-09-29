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
    return (select(avistaments)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<Avistament?> getAvistamentById(String id) {
    return (select(avistaments)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Avistament>> getAvistamentsByBolet(String boletId) {
    return (select(avistaments)
          ..where((t) => t.boletId.equals(boletId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Stream<List<Avistament>> watchAvistamentsByBolet(String boletId) {
    return (select(avistaments)
          ..where((t) => t.boletId.equals(boletId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<List<Avistament>> getAvistamentsByArbre(String arbreId) {
    return (select(avistaments)
          ..where((t) => t.arbreId.equals(arbreId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Stream<List<Avistament>> watchAvistamentsByArbre(String arbreId) {
    return (select(avistaments)
          ..where((t) => t.arbreId.equals(arbreId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<void> deleteAvistament(String id) async {
    await (delete(avistaments)..where((t) => t.id.equals(id))).go();
  }

  Future<Set<String>> getIdentifiedArbreIds() async {
    final query = selectOnly(avistaments, distinct: true)
      ..addColumns([avistaments.arbreId])
      ..where(avistaments.arbreId.isNotNull());
    final rows = await query.get();
    return rows
        .map((r) => r.read(avistaments.arbreId))
        .whereType<String>()
        .toSet();
  }

  Stream<Set<String>> watchIdentifiedArbreIds() {
    final query = selectOnly(avistaments, distinct: true)
      ..addColumns([avistaments.arbreId])
      ..where(avistaments.arbreId.isNotNull());
    return query.watch().map((rows) => rows
        .map((r) => r.read(avistaments.arbreId))
        .whereType<String>()
        .toSet());
  }
}
