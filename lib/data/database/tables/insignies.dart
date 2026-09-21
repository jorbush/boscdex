import 'package:drift/drift.dart';

@DataClassName('Insignia')
class Insignies extends Table {
  TextColumn get id => text()();
  DateTimeColumn get awardedAt => dateTime().nullable()();
  IntColumn get progressCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
