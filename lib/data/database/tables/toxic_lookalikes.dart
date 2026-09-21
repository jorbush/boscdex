import 'package:drift/drift.dart';
import 'bolets.dart';

class ToxicLookalikes extends Table {
  TextColumn get boletId => text().references(Bolets, #id)();
  TextColumn get lookalikeBoletId => text().references(Bolets, #id)();
  TextColumn get comparisonNotes => text()();

  @override
  Set<Column> get primaryKey => {boletId, lookalikeBoletId};
}
