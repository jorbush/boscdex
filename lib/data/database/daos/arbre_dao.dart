import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/arbres.dart';
import '../tables/bolet_arbre_associations.dart';

part 'arbre_dao.g.dart';

@DriftAccessor(tables: [Arbres, BoletArbreAssociations])
class ArbreDao extends DatabaseAccessor<AppDatabase> with _$ArbreDaoMixin {
  ArbreDao(AppDatabase db) : super(db);

  Future<List<Arbre>> getAllArbres() => select(arbres).get();

  Future<Arbre?> getArbreById(String id) {
    return (select(arbres)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Arbre>> getArbresByBoletId(String boletId) async {
    final query = select(arbres).join([
      innerJoin(boletArbreAssociations,
          boletArbreAssociations.arbreId.equalsExp(arbres.id)),
    ])
      ..where(boletArbreAssociations.boletId.equals(boletId));

    final result = await query.get();
    return result.map((row) => row.readTable(arbres)).toList();
  }

  /// Aggregates count of associated mushrooms for each tree in a single query.
  Future<Map<String, int>> getAssociatedBoletCounts() async {
    final countExp = boletArbreAssociations.boletId.count();
    final query = selectOnly(boletArbreAssociations)
      ..addColumns([boletArbreAssociations.arbreId, countExp])
      ..groupBy([boletArbreAssociations.arbreId]);

    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(boletArbreAssociations.arbreId)!: row.read(countExp) ?? 0,
    };
  }
}
