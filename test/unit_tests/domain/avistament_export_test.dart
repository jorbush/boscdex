import 'dart:io';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/photo_export_service.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('boscdex_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('AvistamentDao stores photoPath, confidenceScore and orders descending',
      () async {
    final now = DateTime.now();
    final older = now.subtract(const Duration(hours: 2));

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('scan-old'),
        boletId: const Value('boletus_edulis'),
        timestamp: Value(older),
        photoPath: const Value('/path/to/old.jpg'),
        confidenceScore: const Value(0.75),
        notes: const Value('Older scan'),
      ),
    );

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('scan-new'),
        boletId: const Value('boletus_edulis'),
        timestamp: Value(now),
        photoPath: const Value('/path/to/new.jpg'),
        confidenceScore: const Value(0.94),
        notes: const Value('Newer scan'),
      ),
    );

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('scan-rovello'),
        boletId: const Value('lactarius_deliciosus'),
        timestamp: Value(now),
        photoPath: const Value('/path/to/rovello.jpg'),
        confidenceScore: const Value(0.89),
      ),
    );

    final all = await db.avistamentDao.getAllAvistaments().first;
    expect(all.length, equals(3));
    // Most recent must come first
    expect(all.first.timestamp.isAfter(all.last.timestamp), isTrue);

    // Query by species
    final cepScans =
        await db.avistamentDao.getAvistamentsByBolet('boletus_edulis');
    expect(cepScans.length, equals(2));
    expect(cepScans.first.photoPath, equals('/path/to/new.jpg'));
    expect(cepScans.first.confidenceScore, equals(0.94));

    final single = await db.avistamentDao.getAvistamentById('scan-new');
    expect(single, isNotNull);
    expect(single!.id, equals('scan-new'));
  });

  test('PhotoExportService deletes sighting and removes local file from disk',
      () async {
    const service = PhotoExportService();

    // Create a dummy photo file
    final testFile = File('${tempDir.path}/test_mushroom.jpg');
    await testFile.writeAsString('fake_image_bytes');
    expect(await testFile.exists(), isTrue);

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('scan-to-delete'),
        boletId: const Value('lactarius_deliciosus'),
        timestamp: Value(DateTime.now()),
        photoPath: Value(testFile.path),
        confidenceScore: const Value(0.92),
      ),
    );

    expect(
        await db.avistamentDao.getAvistamentById('scan-to-delete'), isNotNull);

    final deleted = await service.deleteSighting(db, 'scan-to-delete');
    expect(deleted, isTrue);

    // Database record must be gone
    expect(await db.avistamentDao.getAvistamentById('scan-to-delete'), isNull);

    // File on disk must be removed
    expect(await testFile.exists(), isFalse);
  });

  test(
      'AvistamentDao.deleteSighting unlinks discovery reference and removes file',
      () async {
    final testFile = File('${tempDir.path}/test_discovery.jpg');
    await testFile.writeAsString('bytes');

    const sightingId = 'scan-discovery-sighting';
    const boletId = 'lactarius_deliciosus';
    final now = DateTime.now();

    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value(sightingId),
        boletId: const Value(boletId),
        timestamp: Value(now),
        photoPath: Value(testFile.path),
      ),
    );

    await db.descobrimentDao.markDiscovered(boletId, now, sightingId);
    final discoveryBefore = await (db.select(db.descobriments)
          ..where((t) => t.boletId.equals(boletId)))
        .getSingle();
    expect(discoveryBefore.firstAvistamentId, equals(sightingId));

    final deleted = await db.avistamentDao.deleteSighting(sightingId);
    expect(deleted, isTrue);

    expect(await db.avistamentDao.getAvistamentById(sightingId), isNull);
    expect(await testFile.exists(), isFalse);

    final discoveryAfter = await (db.select(db.descobriments)
          ..where((t) => t.boletId.equals(boletId)))
        .getSingle();
    expect(discoveryAfter.firstAvistamentId, isNull);
  });
}
