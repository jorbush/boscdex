import 'dart:io';
import 'dart:developer' as developer;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

import 'tables/bolets.dart';
import 'tables/arbres.dart';
import 'tables/bolet_arbre_associations.dart';
import 'tables/toxic_lookalikes.dart';
import 'tables/avistaments.dart';
import 'tables/descobriments.dart';
import 'tables/insignies.dart';

import 'daos/bolet_dao.dart';
import 'daos/arbre_dao.dart';
import 'daos/avistament_dao.dart';
import 'daos/descobriment_dao.dart';
import 'daos/insignia_dao.dart';

import 'seed/seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Bolets,
    Arbres,
    BoletArbreAssociations,
    ToxicLookalikes,
    Avistaments,
    Descobriments,
    Insignies,
  ],
  daos: [
    BoletDao,
    ArbreDao,
    AvistamentDao,
    DescobrimentDao,
    InsigniaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await batch((b) {
            b.insertAll(bolets, SeedData.bolets);
            b.insertAll(arbres, SeedData.arbres);
            b.insertAll(boletArbreAssociations, SeedData.associations);
            b.insertAll(toxicLookalikes, SeedData.toxicLookalikes);
            b.insertAll(insignies, SeedData.insignies);
          });
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');

          // Backfill imageAssetPath only for pre-existing databases
          if (!details.wasCreated) {
            await customStatement(
              "UPDATE bolets SET image_asset_path = 'assets/images/mushrooms/' || id || '.png' WHERE image_asset_path IS NULL OR image_asset_path = '';",
            );
            await customStatement(
              "UPDATE arbres SET image_asset_path = 'assets/images/trees/' || id || '.png' WHERE image_asset_path IS NULL OR image_asset_path = '';",
            );
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'boscdex.sqlite'));
    if (!await file.exists()) {
      try {
        final blob = await rootBundle.load('assets/database/boscdex_seed.db');
        await file.writeAsBytes(
          blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
          flush: true,
        );
      } catch (e) {
        // If the seed file is not available in assets, continue and initialize via SeedData
        developer.log(
          'Seed asset not found, initializing fresh database: $e',
          name: 'AppDatabase',
        );
      }
    }
    return NativeDatabase(file);
  });
}
