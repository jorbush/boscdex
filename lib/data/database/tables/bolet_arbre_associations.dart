import 'package:drift/drift.dart';
import 'bolets.dart';
import 'arbres.dart';

class BoletArbreAssociations extends Table {
  TextColumn get boletId => text().references(Bolets, #id)();
  TextColumn get arbreId => text().references(Arbres, #id)();

  @override
  Set<Column> get primaryKey => {boletId, arbreId};
}
