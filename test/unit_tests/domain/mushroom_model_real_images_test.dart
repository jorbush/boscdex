// ignore_for_file: avoid_print
@Tags(['ml_benchmark'])
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/services/tflite_classifier_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assetsDir = Directory('test/assets/mushrooms');
  final bool hasTestAssets = assetsDir.existsSync() &&
      assetsDir.listSync(recursive: true).whereType<File>().any((f) {
        final lower = f.path.toLowerCase();
        return lower.endsWith('.png') ||
            lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg');
      });

  group('Golden Set Empirical Model Evaluation (test/assets/mushrooms/)', () {
    late TfliteClassifierService service;

    setUp(() {
      service = TfliteClassifierService();
    });

    tearDown(() {
      service.dispose();
    });

    test(
        'Evaluates all user-provided real field images in test/assets/mushrooms/',
        timeout: const Timeout(Duration(minutes: 3)),
        skip: !hasTestAssets
            ? 'test/assets/mushrooms/ not found (local ML benchmark only - see Google Drive boscdex_dataset.zip)'
            : false, () async {
      await service.initialize();
      expect(service.isTfliteReady, isTrue,
          reason: 'TFLite should be initialized and ready for inference');

      final files =
          assetsDir.listSync(recursive: true).whereType<File>().where((f) {
        final lower = f.path.toLowerCase();
        return lower.endsWith('.png') ||
            lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg');
      }).toList()
            ..sort((a, b) => a.path.compareTo(b.path));

      expect(files, isNotEmpty,
          reason: 'Expected test/assets/mushrooms/ to contain test images');

      print(
          '\n════════════════════════════════════════════════════════════════');
      print(
          '🔬 EMPIRICAL MODEL BENCHMARK ON REAL FIELD IMAGES (${files.length} photos)');
      print('════════════════════════════════════════════════════════════════');

      int totalImages = 0;
      int top1Matches = 0;
      int top3Matches = 0;
      final Map<String, List<bool>> speciesTop1 = {};
      final Map<String, List<bool>> speciesTop3 = {};

      for (final file in files) {
        final segments =
            file.uri.pathSegments.where((s) => s.isNotEmpty).toList();
        final filename = segments.last;
        // The parent directory name is the species taxon id
        final expectedTaxon =
            segments.length >= 2 ? segments[segments.length - 2] : 'unknown';

        final bytes = file.readAsBytesSync();
        final results = await service.classify(bytes);

        expect(results, isNotEmpty);
        expect(results.length, equals(3));
        expect(results.first.confidence, greaterThan(0.0),
            reason: 'Confidence should be positive');

        totalImages++;
        final isTop1 = results.first.boletId == expectedTaxon;
        final isTop3 = results.any((r) => r.boletId == expectedTaxon);

        if (isTop1) top1Matches++;
        if (isTop3) top3Matches++;

        speciesTop1.putIfAbsent(expectedTaxon, () => []).add(isTop1);
        speciesTop3.putIfAbsent(expectedTaxon, () => []).add(isTop3);

        final icon = isTop1 ? '✅' : (isTop3 ? '🟡' : '❌');
        final topMatch = results.first;
        final topPercent = (topMatch.confidence * 100).toStringAsFixed(1);
        print(
            '$icon [${expectedTaxon.padRight(26)}] $filename -> ${topMatch.displayName} ($topPercent%)');
      }

      print(
          '\n────────────────────────────────────────────────────────────────');
      print('📊 EMPIRICAL EVALUATION SUMMARY ACROSS ALL SPECIES:');
      print('────────────────────────────────────────────────────────────────');
      final top1Acc = (top1Matches / totalImages * 100).toStringAsFixed(1);
      final top3Acc = (top3Matches / totalImages * 100).toStringAsFixed(1);
      print('  Total test images: $totalImages');
      print('  Top-1 Accuracy:    $top1Matches / $totalImages ($top1Acc%)');
      print('  Top-3 Accuracy:    $top3Matches / $totalImages ($top3Acc%)');
      print('\n  Per-Species Breakdown (Top-1 / Top-3):');

      final sortedSpecies = speciesTop1.keys.toList()..sort();
      for (final sp in sortedSpecies) {
        final s1 = speciesTop1[sp]!;
        final s3 = speciesTop3[sp]!;
        final count = s1.length;
        final c1 = s1.where((x) => x).length;
        final c3 = s3.where((x) => x).length;
        final p1 = (c1 / count * 100).toStringAsFixed(0);
        final p3 = (c3 / count * 100).toStringAsFixed(0);
        print(
            '    • ${sp.padRight(28)}: Top-1 $c1/$count ($p1%) | Top-3 $c3/$count ($p3%)');
      }
      print(
          '════════════════════════════════════════════════════════════════\n');
    });
  });
}
