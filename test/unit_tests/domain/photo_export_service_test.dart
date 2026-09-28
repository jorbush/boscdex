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
  const service = PhotoExportService();

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('boscdex_export_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveToGallery returns failure result when file does not exist',
      () async {
    final result = await service.saveToGallery('/non/existent/path/image.jpg');
    expect(result.success, isFalse);
    expect(result.message, contains('no existeix'));
  });

  test('sharePhoto handles non-existent file gracefully without throwing',
      () async {
    expect(
      () async => await service.sharePhoto('/non/existent/photo.jpg'),
      returnsNormally,
    );
  });

  test('deleteSighting deletes DB record and removes physical file', () async {
    final photo = File('${tempDir.path}/test_sighting.jpg');
    await photo.writeAsString('sample_bytes');
    expect(await photo.exists(), isTrue);

    const sightingId = 'sighting-123';
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value(sightingId),
        boletId: const Value('lactarius_deliciosus'),
        timestamp: Value(DateTime.now()),
        photoPath: Value(photo.path),
        confidenceScore: const Value(0.88),
      ),
    );

    final before = await db.avistamentDao.getAvistamentById(sightingId);
    expect(before, isNotNull);

    final success = await service.deleteSighting(db, sightingId);
    expect(success, isTrue);

    final after = await db.avistamentDao.getAvistamentById(sightingId);
    expect(after, isNull);
    expect(await photo.exists(), isFalse);
  });

  test('deleteSighting succeeds even if physical file is already missing',
      () async {
    const sightingId = 'sighting-no-file';
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value(sightingId),
        boletId: const Value('boletus_edulis'),
        timestamp: Value(DateTime.now()),
        photoPath: const Value('/missing/path.jpg'),
        confidenceScore: const Value(0.95),
      ),
    );

    final success = await service.deleteSighting(db, sightingId);
    expect(success, isTrue);
    expect(await db.avistamentDao.getAvistamentById(sightingId), isNull);
  });
}
