import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/insignies.dart';

part 'insignia_dao.g.dart';

@DriftAccessor(tables: [Insignies])
class InsigniaDao extends DatabaseAccessor<AppDatabase>
    with _$InsigniaDaoMixin {
  InsigniaDao(AppDatabase db) : super(db);

  Future<Insignia?> getInsignia(String id) {
    return (select(insignies)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Insignia>> getAllInsignies() => select(insignies).get();

  Future<void> awardInsignia(String id, DateTime at) async {
    await (update(insignies)..where((t) => t.id.equals(id))).write(
      InsigniesCompanion(awardedAt: Value(at)),
    );
  }

  Future<void> updateProgress(String id, int count) async {
    await (update(insignies)..where((t) => t.id.equals(id))).write(
      InsigniesCompanion(progressCount: Value(count)),
    );
  }

  Stream<List<Insignia>> watchAwardedInsignies() {
    return (select(insignies)..where((t) => t.awardedAt.isNotNull())).watch();
  }
}
