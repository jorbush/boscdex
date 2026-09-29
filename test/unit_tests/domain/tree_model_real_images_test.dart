// ignore_for_file: avoid_print
@Tags(['ml_benchmark'])
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/services/tflite_classifier_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final treesDir = Directory('test/assets/trees');
  final bool hasTreeAssets = treesDir.existsSync() &&
      treesDir.listSync(recursive: true).whereType<File>().any((f) {
        final lower = f.path.toLowerCase();
        return lower.endsWith('.png') ||
            lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg');
      });

  group('Tree Golden Set Empirical Evaluation (test/assets/trees/)', () {
    late TfliteClassifierService service;

    setUp(() {
      service = TfliteClassifierService();
    });

    tearDown(() {
      service.dispose();
    });

    test(
      'Evaluates all real field indicator tree images in test/assets/trees/',
      timeout: const Timeout(Duration(minutes: 3)),
      skip: !hasTreeAssets
          ? 'test/assets/trees/ not found (local ML benchmark only)'
          : false,
      () async {
        await service.initialize();

        final files =
            treesDir.listSync(recursive: true).whereType<File>().where((f) {
          final lower = f.path.toLowerCase();
          return lower.endsWith('.png') ||
              lower.endsWith('.jpg') ||
              lower.endsWith('.jpeg');
        }).toList()
              ..sort((a, b) => a.path.compareTo(b.path));

        expect(files, isNotEmpty,
            reason: 'Expected test/assets/trees/ to contain field photos');

        print(
            '\n════════════════════════════════════════════════════════════════');
        print(
            '🌲 EMPIRICAL TREE MODEL BENCHMARK ON REAL FIELD IMAGES (${files.length} photos)');
        print(
            '════════════════════════════════════════════════════════════════');

        int totalImages = 0;
        int top1Matches = 0;
        int top2Matches = 0;
        final Map<String, List<bool>> speciesTop1 = {};
        final Map<String, List<bool>> speciesTop2 = {};

        for (final file in files) {
          final segments =
              file.uri.pathSegments.where((s) => s.isNotEmpty).toList();
          final filename = segments.last;
          // Parent directory is the tree taxon id
          final expectedTaxon =
              segments.length >= 2 ? segments[segments.length - 2] : 'unknown';

          final bytes = file.readAsBytesSync();
          final results = await service.classifyTree(bytes);

          expect(results, isNotEmpty);
          expect(results.length, greaterThanOrEqualTo(2));
          expect(results.first.confidence, greaterThan(0.0),
              reason: 'Confidence should be positive');

          totalImages++;
          final isTop1 = results.first.arbreId == expectedTaxon;
          final isTop2 = results.any((r) => r.arbreId == expectedTaxon);

          if (isTop1) top1Matches++;
          if (isTop2) top2Matches++;

          speciesTop1.putIfAbsent(expectedTaxon, () => []).add(isTop1);
          speciesTop2.putIfAbsent(expectedTaxon, () => []).add(isTop2);

          final symbol = isTop1 ? '✅' : (isTop2 ? '🟡' : '❌');
          print(
            '$symbol [${expectedTaxon.padRight(20)}] $filename -> '
            '${results.first.displayName} (${(results.first.confidence * 100).toStringAsFixed(0)}%)'
            '${!isTop1 && isTop2 ? ' [Top-2: ${results[1].displayName}]' : ''}',
          );
        }

        final top1Pct = (top1Matches / totalImages) * 100;
        final top2Pct = (top2Matches / totalImages) * 100;

        print(
            '\n────────────────────────────────────────────────────────────────');
        print('📊 EMPIRICAL TREE EVALUATION SUMMARY ACROSS ALL SPECIES:');
        print(
            '────────────────────────────────────────────────────────────────');
        print('  Total test images: $totalImages');
        print(
            '  Top-1 Accuracy:    $top1Matches / $totalImages (${top1Pct.toStringAsFixed(1)}%)');
        print(
            '  Top-2 Accuracy:    $top2Matches / $totalImages (${top2Pct.toStringAsFixed(1)}%)');
        print('\n  Per-Species Breakdown (Top-1 / Top-2):');

        final sortedSpecies = speciesTop1.keys.toList()..sort();
        for (final sp in sortedSpecies) {
          final t1List = speciesTop1[sp]!;
          final t2List = speciesTop2[sp]!;
          final t1Count = t1List.where((b) => b).length;
          final t2Count = t2List.where((b) => b).length;
          final t1Perc = (t1Count / t1List.length * 100).round();
          final t2Perc = (t2Count / t2List.length * 100).round();
          print(
              '    • ${sp.padRight(22)}: Top-1 $t1Count/${t1List.length} ($t1Perc%) | Top-2 $t2Count/${t2List.length} ($t2Perc%)');
        }
        print(
            '════════════════════════════════════════════════════════════════\n');

        expect(service.isTreeTfliteReady, isTrue);
        expect(top1Pct, greaterThanOrEqualTo(80.0),
            reason: 'Top-1 accuracy should be at least 80%');
        expect(top2Pct, greaterThanOrEqualTo(90.0),
            reason: 'Top-2 accuracy should be at least 90%');
      },
    );
  });
}
