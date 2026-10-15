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
import '../../domain/services/photo_export_service.dart';

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
  int get schemaVersion => 3;

  Future<void> _migrateAvistamentsTable() async {
    final tables = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='avistaments';",
    ).get();
    if (tables.isEmpty) return;

    final columns = await customSelect('PRAGMA table_info(avistaments);').get();
    QueryRow? boletIdCol;
    bool hasArbreId = false;
    for (final col in columns) {
      final name = col.read<String>('name');
      if (name == 'bolet_id') {
        boletIdCol = col;
      } else if (name == 'arbre_id') {
        hasArbreId = true;
      }
    }

    final isBoletIdNotNull =
        boletIdCol != null && boletIdCol.read<int>('notnull') == 1;

    if (isBoletIdNotNull || !hasArbreId) {
      developer.log(
        'Migrating avistaments table to allow nullable bolet_id and support tree sightings...',
        name: 'AppDatabase',
      );
      await customStatement('PRAGMA foreign_keys = OFF;');
      await customStatement('DROP TABLE IF EXISTS avistaments_new;');
      await customStatement('''
        CREATE TABLE IF NOT EXISTS avistaments_new (
          id TEXT NOT NULL PRIMARY KEY,
          bolet_id TEXT REFERENCES bolets (id),
          arbre_id TEXT REFERENCES arbres (id),
          timestamp INTEGER NOT NULL,
          latitude REAL,
          longitude REAL,
          altitude REAL,
          photo_path TEXT,
          confidence_score REAL,
          notes TEXT
        );
      ''');

      if (hasArbreId) {
        await customStatement('''
          INSERT INTO avistaments_new (id, bolet_id, arbre_id, timestamp, latitude, longitude, altitude, photo_path, confidence_score, notes)
          SELECT id, bolet_id, arbre_id, timestamp, latitude, longitude, altitude, photo_path, confidence_score, notes
          FROM avistaments;
        ''');
      } else {
        await customStatement('''
          INSERT INTO avistaments_new (id, bolet_id, arbre_id, timestamp, latitude, longitude, altitude, photo_path, confidence_score, notes)
          SELECT id, bolet_id, NULL, timestamp, latitude, longitude, altitude, photo_path, confidence_score, notes
          FROM avistaments;
        ''');
      }

      await customStatement('DROP TABLE avistaments;');
      await customStatement(
          'ALTER TABLE avistaments_new RENAME TO avistaments;');
    }
  }

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
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            await _migrateAvistamentsTable();
          }
        },
        beforeOpen: (details) async {
          await _migrateAvistamentsTable();
          await customStatement('PRAGMA foreign_keys = ON;');

          // Recover legacy absolute photo paths to relative paths across iOS/Android container updates
          await customStatement(
            "UPDATE avistaments SET photo_path = substr(photo_path, instr(photo_path, 'scans/')) WHERE photo_path LIKE '%scans/%' AND photo_path NOT LIKE 'scans/%';",
          );

          // Sync newly added seed species, trees, associations, and lookalikes for pre-existing databases
          if (!details.wasCreated) {
            await batch((b) {
              b.insertAll(bolets, SeedData.bolets,
                  mode: InsertMode.insertOrIgnore);
              b.insertAll(arbres, SeedData.arbres,
                  mode: InsertMode.insertOrIgnore);
              b.insertAll(boletArbreAssociations, SeedData.associations,
                  mode: InsertMode.insertOrIgnore);
              b.insertAll(toxicLookalikes, SeedData.toxicLookalikes,
                  mode: InsertMode.insertOrReplace);
              b.insertAll(insignies, SeedData.insignies,
                  mode: InsertMode.insertOrIgnore);
            });
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
    PhotoExportService.initDocumentsDirectory(dbFolder.path);
    final file = File(p.join(dbFolder.path, 'boscdex.sqlite'));
    if (!await file.exists()) {
      try {
        final blob = await rootBundle.load('assets/database/boscdex_seed.db');
        if (blob.lengthInBytes > 0) {
          await file.writeAsBytes(
            blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
            flush: true,
          );
        }
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
