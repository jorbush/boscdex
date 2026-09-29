import 'dart:io';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/photo_export_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Directory newContainerDir;
  late Directory scansDir;
  late AppDatabase db;

  setUp(() async {
    newContainerDir =
        await Directory.systemTemp.createTemp('boscdex_new_container_');
    scansDir = Directory(p.join(newContainerDir.path, 'scans'));
    await scansDir.create(recursive: true);

    PhotoExportService.initDocumentsDirectory(newContainerDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
    if (await newContainerDir.exists()) {
      await newContainerDir.delete(recursive: true);
    }
  });

  group('Photo Persistence & iOS Container UUID Migration Tests', () {
    test('Resolves relative photo path correctly against new container',
        () async {
      const fileName = 'scan_test_relative.jpg';
      final physicalFile = File(p.join(scansDir.path, fileName));
      await physicalFile.writeAsString('test_bytes');

      final resolved = PhotoExportService.resolveFile('scans/$fileName');
      expect(resolved.existsSync(), isTrue);
      expect(resolved.path, equals(physicalFile.path));
    });

    test(
        'Simulates iOS App Update: Recovers legacy absolute path with old container UUID',
        () async {
      const fileName = 'scan_recovered_from_old_uuid.jpg';
      // The file was moved by iOS to the new container's scans directory:
      final physicalFile = File(p.join(scansDir.path, fileName));
      await physicalFile.writeAsString('preserved_photo_content');

      // The database still had the old container UUID from a previous app build:
      const legacyPath =
          '/var/mobile/Containers/Data/Application/11111111-2222-3333-4444-555555555555/Documents/scans/$fileName';

      // Verify direct access to legacy path fails (it belongs to the old container):
      expect(File(legacyPath).existsSync(), isFalse);

      // Verify PhotoExportService.resolveFile successfully recovers the file in the new container:
      final recoveredFile = PhotoExportService.resolveFile(legacyPath);
      expect(recoveredFile.existsSync(), isTrue);
      expect(recoveredFile.path, equals(physicalFile.path));
      expect(await recoveredFile.readAsString(),
          equals('preserved_photo_content'));
    });

    test('SQLite migration normalizes legacy absolute paths to relative paths',
        () async {
      const sightingId = 'sighting-migration-test';
      const fileName = 'scan_migrated.jpg';
      const legacyPath =
          '/var/mobile/Containers/Data/Application/AAAA-BBBB-CCCC/Documents/scans/$fileName';

      // Insert sighting with legacy absolute path
      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: const Value(sightingId),
          boletId: const Value('boletus_edulis'),
          timestamp: Value(DateTime.now()),
          photoPath: const Value(legacyPath),
        ),
      );

      // Execute migration query (as run in AppDatabase.beforeOpen)
      await db.customStatement(
        "UPDATE avistaments SET photo_path = substr(photo_path, instr(photo_path, 'scans/')) WHERE photo_path LIKE '%scans/%' AND photo_path NOT LIKE 'scans/%';",
      );

      // Verify the path in database is now clean relative format
      final updated = await db.avistamentDao.getAvistamentById(sightingId);
      expect(updated, isNotNull);
      expect(updated!.photoPath, equals('scans/$fileName'));
    });

    test('AvistamentDao.deleteAvistament deletes relative photo file on disk',
        () async {
      const sightingId = 'delete-relative-test';
      const fileName = 'scan_to_delete.jpg';
      final fileOnDisk = File(p.join(scansDir.path, fileName));
      await fileOnDisk.writeAsString('bytes_to_delete');
      expect(fileOnDisk.existsSync(), isTrue);

      await db.avistamentDao.insertAvistament(
        AvistamentsCompanion(
          id: const Value(sightingId),
          boletId: const Value('lactarius_deliciosus'),
          timestamp: Value(DateTime.now()),
          photoPath: const Value('scans/$fileName'),
        ),
      );

      // Delete sighting
      await db.avistamentDao.deleteAvistament(sightingId);

      // Verify DB record is removed and relative file is deleted on disk
      expect(await db.avistamentDao.getAvistamentById(sightingId), isNull);
      expect(fileOnDisk.existsSync(), isFalse);
    });
  });
}
