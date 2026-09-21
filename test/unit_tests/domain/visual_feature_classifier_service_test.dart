import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/services/visual_feature_classifier_service.dart';

Future<Uint8List> createSolidImageBytes(Color color, {int size = 32}) async {
  final recorder = ui.PictureRecorder();
  final canvas =
      Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    Paint()..color = color,
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VisualFeatureClassifierService Tests', () {
    late VisualFeatureClassifierService classifier;

    setUp(() {
      classifier = VisualFeatureClassifierService();
    });

    tearDown(() {
      classifier.dispose();
    });

    test('Empty bytes fallback gracefully returns scenario results', () async {
      final results = await classifier.classify(Uint8List(0));
      expect(results, isNotEmpty);
      expect(results.first.boletId, isNotEmpty);
      expect(results.first.confidence, greaterThan(0.0));
    });

    test('Empty bytes tree fallback returns tree results', () async {
      final results = await classifier.classifyTree(Uint8List(0));
      expect(results, isNotEmpty);
      expect(results.first.arbreId, isNotEmpty);
    });

    test(
        'Vibrant orange image correctly identifies Rovelló (Lactarius deliciosus)',
        () async {
      // Classic carrot-orange / terracotta hue of Rovelló (#D96924)
      final orangeBytes = await createSolidImageBytes(const Color(0xFFD96924));
      final results = await classifier.classify(orangeBytes);

      expect(results, isNotEmpty);
      expect(results.first.boletId, equals('lactarius_deliciosus'));
      expect(results.first.displayName, equals('Rovelló / Pinetell'));
      expect(results.first.confidence, greaterThanOrEqualTo(0.80));
    });

    test(
        'Dark charcoal / olive-brown image identifies Llenega negra (Hygrophorus latitabundus)',
        () async {
      // Dark slimy charcoal/olive-brown cap of Llenega negra (#2E2A24)
      final darkBytes = await createSolidImageBytes(const Color(0xFF2E2A24));
      final results = await classifier.classify(darkBytes);

      expect(results, isNotEmpty);
      final topIds = results.map((r) => r.boletId).toList();
      expect(
        topIds.contains('hygrophorus_latitabundus') ||
            topIds.contains('craterellus_cornucopioides'),
        isTrue,
      );
    });

    test(
        'Scanning orange mushroom in Arbres tab rejects with low confidence (<0.60)',
        () async {
      final orangeBytes = await createSolidImageBytes(const Color(0xFFD96924));
      final treeResults = await classifier.classifyTree(orangeBytes);

      expect(treeResults, isNotEmpty);
      // Must trigger Safety Gate: confidence strictly below 0.60
      expect(treeResults.first.confidence, lessThan(0.60));
    });

    test(
        'Forest foliage and pine green image identifies Pinus tree with high confidence',
        () async {
      // Pine needle green (#2E5935)
      final pineBytes = await createSolidImageBytes(const Color(0xFF2E5935));
      final treeResults = await classifier.classifyTree(pineBytes);

      expect(treeResults, isNotEmpty);
      expect(treeResults.first.confidence, greaterThanOrEqualTo(0.80));
    });
  });
}
