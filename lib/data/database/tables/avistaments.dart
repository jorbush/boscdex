import 'package:drift/drift.dart';
import 'bolets.dart';

class Avistaments extends Table {
  TextColumn get id => text()();
  TextColumn get boletId => text().references(Bolets, #id)();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get altitude => real().nullable()();
  TextColumn get photoPath => text().nullable()();
  RealColumn get confidenceScore => real().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
