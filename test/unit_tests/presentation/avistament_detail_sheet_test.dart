import 'dart:io';
import 'package:boscdex/data/database/app_database.dart';
import 'package:boscdex/domain/services/photo_export_service.dart';
import 'package:boscdex/presentation/journal/avistament_detail_sheet.dart';
import 'package:boscdex/providers/database_provider.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePhotoExportService extends PhotoExportService {
  Rect? lastOrigin;
  String? lastPath;
  String? lastText;

  @override
  Future<bool> sharePhoto(
    String filePath, {
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    lastPath = filePath;
    lastText = text;
    lastOrigin = sharePositionOrigin;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Directory tempDir;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('boscdex_sheet_test_');
    PhotoExportService.initDocumentsDirectory(tempDir.path);
  });

  tearDown(() {
    // In-memory sqlite is automatically cleaned up with the test process
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  Widget createWidgetUnderTest(
    Avistament avistament, {
    VoidCallback? onDeleted,
    PhotoExportService? photoExportService,
  }) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: AvistamentDetailSheet(
            avistament: avistament,
            onDeleted: onDeleted,
            photoExportService:
                photoExportService ?? const PhotoExportService(),
          ),
        ),
      ),
    );
  }

  testWidgets('Renders AvistamentDetailSheet with high confidence score',
      (tester) async {
    final avistament = Avistament(
      id: 'test-1',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 9, 25, 10, 30),
      confidenceScore: 0.89,
      notes: 'Trobat sota un pi roig',
      altitude: 1250,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
    expect(find.text('Coincidència Neural AI'), findsOneWidget);
    expect(find.text('89%'), findsOneWidget);

    // Scroll down to reveal species card and bottom action buttons
    await tester.scrollUntilVisible(find.textContaining('Rovelló'), 200);
    await tester.pumpAndSettle();
    expect(find.textContaining('Rovelló'), findsOneWidget);

    await tester.scrollUntilVisible(find.byTooltip('Eliminar avistament'), 200);
    await tester.pumpAndSettle();

    expect(find.byTooltip('Compartir'), findsOneWidget);
    expect(find.byTooltip('Eliminar avistament'), findsOneWidget);
    expect(find.text('Descarregar Foto'), findsOneWidget);
    expect(find.text('Veure fitxa completa a la Boscdex'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Renders AvistamentDetailSheet with low confidence alert',
      (tester) async {
    final avistament = Avistament(
      id: 'test-low',
      boletId: 'tricholoma_terreum',
      timestamp: DateTime(2026, 9, 25, 11, 0),
      confidenceScore: 0.45,
      notes: null,
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    expect(find.text('45%'), findsOneWidget);
    expect(find.textContaining('Coincidència moderada'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Delete button triggers confirmation dialog', (tester) async {
    final avistament = Avistament(
      id: 'test-delete',
      boletId: 'boletus_edulis',
      timestamp: DateTime(2026, 9, 25, 12, 0),
      confidenceScore: 0.95,
      notes: null,
      altitude: null,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    final deleteBtn = find.byTooltip('Eliminar avistament');
    await tester.scrollUntilVisible(deleteBtn, 200);
    await tester.pumpAndSettle();

    expect(deleteBtn, findsOneWidget);

    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    expect(find.text('Eliminar avistament?'), findsOneWidget);
    expect(find.text('Cancel·lar'), findsOneWidget);

    await tester.tap(find.text('Cancel·lar'));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'Renders AvistamentDetailSheet for tree sighting with leaf type tag and tree button',
      (tester) async {
    final avistament = Avistament(
      id: 'test-tree-sighting',
      arbreId: 'pinus_sylvestris',
      timestamp: DateTime(2026, 9, 28, 14, 0),
      confidenceScore: 0.94,
      notes: 'Gran pi roig al vessant nord',
      altitude: 1400,
      photoPath: null,
      latitude: null,
      longitude: null,
    );

    await tester.pumpWidget(createWidgetUnderTest(avistament));
    await tester.pumpAndSettle();

    expect(find.text('DETALL DE L\'AVISTAMENT'), findsOneWidget);
    expect(find.text('Coincidència Neural AI'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);

    // Scroll to reveal tree identification details
    await tester.scrollUntilVisible(find.textContaining('Pi roig'), 200);
    await tester.pumpAndSettle();
    expect(find.textContaining('Pi roig'), findsOneWidget);
    expect(find.text('Pinus sylvestris'), findsOneWidget);
    expect(find.text('Agulla'), findsOneWidget);

    await tester.scrollUntilVisible(
        find.text('Veure fitxa completa de l\'arbre'), 200);
    await tester.pumpAndSettle();
    expect(find.text('Veure fitxa completa de l\'arbre'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'Share button is enabled when sighting has photo and tapping calculates anchor correctly',
      (tester) async {
    final transparent1x1Png = [
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82
    ];
    final photo = File('${tempDir.path}/test_mushroom.png');
    photo.writeAsBytesSync(transparent1x1Png);
    final fakeExportService = FakePhotoExportService();

    final avistament = Avistament(
      id: 'test-share-sighting',
      boletId: 'lactarius_deliciosus',
      timestamp: DateTime(2026, 9, 25, 10, 30),
      confidenceScore: 0.91,
      notes: 'Foto presa al bosc',
      altitude: 1200,
      photoPath: photo.path,
      latitude: null,
      longitude: null,
    );

    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetUnderTest(
        avistament,
        photoExportService: fakeExportService,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final shareBtn = find.widgetWithIcon(IconButton, Icons.share_rounded);
      await tester.scrollUntilVisible(shareBtn, 100);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(shareBtn, findsOneWidget);

      final iconButton = tester.widget<IconButton>(shareBtn);
      expect(iconButton.onPressed, isNotNull);

      await tester.tap(shareBtn);
      await Future.delayed(const Duration(milliseconds: 300));
      await tester.pump();

      expect(fakeExportService.lastPath, photo.path);
      expect(fakeExportService.lastOrigin, isNotNull);
      expect(fakeExportService.lastOrigin!.width, greaterThan(0));
      expect(fakeExportService.lastOrigin!.height, greaterThan(0));

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}
