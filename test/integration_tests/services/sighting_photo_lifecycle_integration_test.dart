import 'dart:io';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/photo_export_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late Directory tempDir;
  const photoService = PhotoExportService();

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('boscdex_lifecycle_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Complete Sighting & Field Photo Lifecycle Integration', () async {
    const boletId = 'boletus_edulis';
    const sightingId = 'lifecycle-sighting-1';

    // 1. Simulate saving a field scan photograph to disk
    final photoFile = File('${tempDir.path}/scan_$sightingId.jpg');
    await photoFile.writeAsString('fake_jpeg_header_and_pixels');
    expect(await photoFile.exists(), isTrue);

    // 2. Register sighting in SQLite database
    final now = DateTime.now();
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const drift.Value(sightingId),
        boletId: const drift.Value(boletId),
        timestamp: drift.Value(now),
        photoPath: drift.Value(photoFile.path),
        confidenceScore: const drift.Value(0.96),
        notes:
            const drift.Value('Cep magnificent trobat a la fageda d\'en Jordà'),
      ),
    );

    // Mark as discovered in Boscdex
    await db.descobrimentDao.markDiscovered(boletId, now, sightingId);
    expect(await db.descobrimentDao.isDiscovered(boletId), isTrue);

    // 3. Verify it appears in Journal feed (ordered descending)
    final allJournalSightings =
        await db.avistamentDao.getAllAvistaments().first;
    expect(allJournalSightings.length, equals(1));
    expect(allJournalSightings.first.id, equals(sightingId));
    expect(allJournalSightings.first.photoPath, equals(photoFile.path));
    expect(allJournalSightings.first.confidenceScore, equals(0.96));

    // 4. Verify it appears in the species-specific captures gallery
    final speciesSightings =
        await db.avistamentDao.getAvistamentsByBolet(boletId);
    expect(speciesSightings.length, equals(1));
    expect(speciesSightings.first.id, equals(sightingId));

    // 5. Inspect sighting by ID
    final retrieved = await db.avistamentDao.getAvistamentById(sightingId);
    expect(retrieved, isNotNull);
    expect(retrieved!.notes, contains('fageda d\'en Jordà'));

    // 6. Delete sighting using PhotoExportService (cascading removal)
    final deleted = await photoService.deleteSighting(db, sightingId);
    expect(deleted, isTrue);

    // Verify DB record is removed
    expect(await db.avistamentDao.getAvistamentById(sightingId), isNull);
    final remainingSpeciesSightings =
        await db.avistamentDao.getAvistamentsByBolet(boletId);
    expect(remainingSpeciesSightings, isEmpty);

    // Verify local disk file is cleaned up
    expect(await photoFile.exists(), isFalse);
  });
}
