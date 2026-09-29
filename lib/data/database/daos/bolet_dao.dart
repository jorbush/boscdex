import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/bolets.dart';
import '../tables/toxic_lookalikes.dart';
import '../tables/bolet_arbre_associations.dart';
import '../tables/arbres.dart';

part 'bolet_dao.g.dart';

/// Data class holding a toxic lookalike [Bolet] along with the specific [comparisonNotes]
/// distinguishing it from the target specimen.
class ToxicLookalikeWithNotes {
  final Bolet lookalike;
  final String comparisonNotes;

  const ToxicLookalikeWithNotes({
    required this.lookalike,
    required this.comparisonNotes,
  });
}

/// Data Access Object for querying mushroom specimens, lookalikes, and tree associations.
@DriftAccessor(
    tables: [Bolets, ToxicLookalikes, BoletArbreAssociations, Arbres])
class BoletDao extends DatabaseAccessor<AppDatabase> with _$BoletDaoMixin {
  BoletDao(AppDatabase db) : super(db);

  /// Retrieves all cataloged mushroom species.
  Future<List<Bolet>> getAllBolets() => select(bolets).get();

  /// Retrieves a specific mushroom by unique identifier.
  Future<Bolet?> getBoletById(String id) {
    return (select(bolets)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Filters mushrooms by edibility status string.
  Future<List<Bolet>> getBoletsByEdibility(String edibility) {
    return (select(bolets)..where((t) => t.edibility.equals(edibility))).get();
  }

  /// Searches mushrooms by partial match against Catalan or scientific name.
  /// Normalized for case and Catalan diacritics (e.g. 'rovello' matches 'Rovelló').
  Future<List<Bolet>> searchByName(String query) async {
    final all = await getAllBolets();
    final normalizedQuery = _stripDiacritics(query.trim().toLowerCase());
    if (normalizedQuery.isEmpty) return all;

    return all.where((b) {
      final catalanNorm = _stripDiacritics(b.catalanName.toLowerCase());
      final scientificNorm = _stripDiacritics(b.scientificName.toLowerCase());
      return catalanNorm.contains(normalizedQuery) ||
          scientificNorm.contains(normalizedQuery);
    }).toList();
  }

  static String _stripDiacritics(String text) {
    const withAccents = 'àáèéíïòóúüç·ÀÁÈÉÍÏÒÓÚÜÇ';
    const withoutAccents = 'aaeeiioouuc.AAEEIIOOUUC';
    var result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return result;
  }

  /// Retrieves mushrooms associated with a specific indicator tree.
  Future<List<Bolet>> getBoletsByArbreId(String arbreId) async {
    final query = select(bolets).join([
      innerJoin(boletArbreAssociations,
          boletArbreAssociations.boletId.equalsExp(bolets.id)),
    ])
      ..where(boletArbreAssociations.arbreId.equals(arbreId));

    final result = await query.get();
    return result.map((row) => row.readTable(bolets)).toList();
  }

  /// Retrieves toxic lookalike specimens for a given mushroom.
  Future<List<Bolet>> getToxicLookalikes(String boletId) async {
    final query = select(bolets).join([
      innerJoin(toxicLookalikes,
          toxicLookalikes.lookalikeBoletId.equalsExp(bolets.id)),
    ])
      ..where(toxicLookalikes.boletId.equals(boletId));

    final result = await query.get();
    return result.map((row) => row.readTable(bolets)).toList();
  }

  /// Retrieves toxic lookalikes joined with specific morphological comparison notes.
  Future<List<ToxicLookalikeWithNotes>> getToxicLookalikesWithNotes(
      String boletId) async {
    final query = select(bolets).join([
      innerJoin(toxicLookalikes,
          toxicLookalikes.lookalikeBoletId.equalsExp(bolets.id)),
    ])
      ..where(toxicLookalikes.boletId.equals(boletId));

    final result = await query.get();
    return result
        .map((row) => ToxicLookalikeWithNotes(
              lookalike: row.readTable(bolets),
              comparisonNotes: row.readTable(toxicLookalikes).comparisonNotes,
            ))
        .toList();
  }

  /// Retrieves indicator trees associated with a specific mushroom.
  Future<List<Arbre>> getAssociatedArbres(String boletId) async {
    final query = select(arbres).join([
      innerJoin(boletArbreAssociations,
          boletArbreAssociations.arbreId.equalsExp(arbres.id)),
    ])
      ..where(boletArbreAssociations.boletId.equals(boletId));

    final result = await query.get();
    return result.map((row) => row.readTable(arbres)).toList();
  }

  /// Returns the distinct set of mushroom IDs that have indicator tree associations.
  Future<List<String>> getBoletIdsWithArbres() async {
    final query = selectOnly(boletArbreAssociations, distinct: true)
      ..addColumns([boletArbreAssociations.boletId]);
    final rows = await query.get();
    return rows.map((r) => r.read(boletArbreAssociations.boletId)!).toList();
  }
}
