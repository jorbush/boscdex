import 'package:drift/drift.dart';

class Arbres extends Table {
  TextColumn get id => text()();
  TextColumn get catalanName => text()();
  TextColumn get scientificName => text()();
  TextColumn get leafType => text()();
  TextColumn get barkDescription => text()();
  TextColumn get typicalSoil => text()();
  TextColumn get imageAssetPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
