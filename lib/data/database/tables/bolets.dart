import 'package:drift/drift.dart';

class Bolets extends Table {
  TextColumn get id => text()();
  TextColumn get catalanName => text()();
  TextColumn get scientificName => text()();
  TextColumn get family => text()();
  TextColumn get rarityTier => text()();
  TextColumn get edibility => text()();
  TextColumn get fruitingSeason =>
      text()(); // JSON array of month numbers e.g. '[9,10,11,12]'
  IntColumn get altitudeMin => integer().nullable()();
  IntColumn get altitudeMax => integer().nullable()();
  TextColumn get capDescription => text()();
  TextColumn get gillsDescription => text()();
  TextColumn get stemDescription => text()();
  TextColumn get latexDescription => text().nullable()();
  TextColumn get safetyNotes => text().nullable()();
  TextColumn get imageAssetPath => text().nullable()();
  TextColumn get silhouetteAssetPath => text().nullable()();
  IntColumn get dexNumber => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
