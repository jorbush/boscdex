import 'package:drift/drift.dart';
import 'bolets.dart';
import 'avistaments.dart';

class Descobriments extends Table {
  TextColumn get boletId => text().references(Bolets, #id)();
  DateTimeColumn get discoveredAt => dateTime()();
  TextColumn get firstAvistamentId =>
      text().nullable().references(Avistaments, #id)();

  @override
  Set<Column> get primaryKey => {boletId};
}
