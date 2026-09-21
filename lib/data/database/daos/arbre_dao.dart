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
}
