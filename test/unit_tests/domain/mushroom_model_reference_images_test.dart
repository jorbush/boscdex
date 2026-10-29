// ignore_for_file: avoid_print
@Tags(['ml_benchmark'])
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/services/tflite_classifier_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final refDir = Directory('assets/images/reference');
  final bool hasReferenceAssets = refDir.existsSync() &&
      refDir.listSync().whereType<File>().any((f) {
        final lower = f.path.toLowerCase();
        return lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png');
      });

  group(
      'Botanical Reference Images Model Evaluation (assets/images/reference/)',
      () {
    late TfliteClassifierService service;

    setUp(() {
      service = TfliteClassifierService();
    });

    tearDown(() {
      service.dispose();
    });

    test(
        'Evaluates all 75 curated botanical reference images against the on-device ML model',
        timeout: const Timeout(Duration(minutes: 5)),
        skip: !hasReferenceAssets
            ? 'assets/images/reference/ not found'
            : false, () async {
      await service.initialize();
      expect(service.isTfliteReady, isTrue,
          reason: 'TFLite should be initialized and ready for inference');

      // Load attributions to map Catalan names and metadata
      final attrFile = File('assets/images/reference/attributions.json');
      final Map<String, String> catalanNames = {};
      if (attrFile.existsSync()) {
        try {
          final List<dynamic> decoded = jsonDecode(attrFile.readAsStringSync());
          for (final item in decoded) {
            final m = item as Map<String, dynamic>;
            catalanNames[m['species_id'] as String] =
                m['catalan_name'] as String? ?? '';
          }
        } catch (_) {}
      }

      final files = refDir.listSync().whereType<File>().where((f) {
        final lower = f.path.toLowerCase();
        final isImage = lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png');
        if (!isImage) return false;
        final baseTaxon = f.uri.pathSegments.last.split('.').first;
        return !const {
          'castanea_sativa',
          'fagus_sylvatica',
          'pinus_halepensis',
          'pinus_sylvestris',
          'quercus_ilex',
        }.contains(baseTaxon);
      }).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      expect(files.length, equals(75),
          reason: 'Expected exactly 75 botanical reference images');

      print(
          '\n════════════════════════════════════════════════════════════════');
      print(
          '🔬 BOTANICAL REFERENCE IMAGES MODEL BENCHMARK (${files.length} species)');
      print('════════════════════════════════════════════════════════════════');

      int totalImages = 0;
      int top1Matches = 0;
      int top3Matches = 0;

      final List<Map<String, dynamic>> resultsLog = [];

      for (final file in files) {
        final filename = file.uri.pathSegments.last;
        // filename is <species_id>.jpg
        final expectedTaxon = filename.replaceAll(
            RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '');
        final catName = catalanNames[expectedTaxon] ?? expectedTaxon;

        final bytes = file.readAsBytesSync();
        final results = await service.classify(bytes);

        expect(results, isNotEmpty);
        expect(results.length, equals(3));
        expect(results.first.confidence, greaterThan(0.0),
            reason: 'Confidence should be positive');

        totalImages++;
        final isTop1 = results.first.boletId == expectedTaxon;
        final rankIndex = results.indexWhere((r) => r.boletId == expectedTaxon);
        final isTop3 = rankIndex >= 0;

        if (isTop1) top1Matches++;
        if (isTop3) top3Matches++;

        final icon = isTop1
            ? '✅ Top-1'
            : (isTop3 ? '🟡 Top-${rankIndex + 1}' : '❌ Miss ');
        final topMatch = results.first;
        final topPercent = (topMatch.confidence * 100).toStringAsFixed(1);

        resultsLog.add({
          'species_id': expectedTaxon,
          'catalan_name': catName,
          'is_top1': isTop1,
          'is_top3': isTop3,
          'rank': rankIndex >= 0 ? rankIndex + 1 : -1,
          'top_match': topMatch.boletId,
          'top_confidence': topMatch.confidence,
          'expected_confidence': isTop3 ? results[rankIndex].confidence : 0.0,
        });

        if (isTop1) {
          print(
              '$icon [${expectedTaxon.padRight(28)}] -> $topPercent% ($catName)');
        } else if (isTop3) {
          final expPercent =
              (results[rankIndex].confidence * 100).toStringAsFixed(1);
          print(
              '$icon [${expectedTaxon.padRight(28)}] Top-1: ${topMatch.boletId} ($topPercent%) | Rank ${rankIndex + 1}: $expPercent%');
        } else {
          print(
              '$icon [${expectedTaxon.padRight(28)}] Pred: ${topMatch.boletId} ($topPercent%)');
        }
      }

      print(
          '\n────────────────────────────────────────────────────────────────');
      print('📊 BOTANICAL REFERENCE EVALUATION SUMMARY:');
      print('────────────────────────────────────────────────────────────────');
      final top1Acc = (top1Matches / totalImages * 100).toStringAsFixed(1);
      final top3Acc = (top3Matches / totalImages * 100).toStringAsFixed(1);
      print('  Total reference images: $totalImages');
      print(
          '  Top-1 Accuracy:         $top1Matches / $totalImages ($top1Acc%)');
      print(
          '  Top-3 Accuracy:         $top3Matches / $totalImages ($top3Acc%)');

      final misses = resultsLog.where((r) => !(r['is_top3'] as bool)).toList();
      final top2or3 = resultsLog
          .where((r) => !(r['is_top1'] as bool) && (r['is_top3'] as bool))
          .toList();

      if (top2or3.isNotEmpty) {
        print('\n  🟡 Top 2-3 Matches (${top2or3.length}):');
        for (final m in top2or3) {
          final p =
              ((m['expected_confidence'] as double) * 100).toStringAsFixed(1);
          print(
              '    • ${m['species_id']} (Rank ${m['rank']}, $p%) - Top-1 was ${m['top_match']}');
        }
      }

      if (misses.isNotEmpty) {
        print('\n  ❌ Outside Top-3 (${misses.length}):');
        for (final m in misses) {
          final topP =
              ((m['top_confidence'] as double) * 100).toStringAsFixed(1);
          print(
              '    • ${m['species_id']} -> Predicted ${m['top_match']} ($topP%)');
        }
      }

      print(
          '════════════════════════════════════════════════════════════════\n');

      expect(totalImages, equals(75));
      expect(top1Matches, equals(75),
          reason:
              'All 75 canonical botanical reference images displayed in the app must be identified as the Top-1 match');
      expect(top3Matches, equals(75),
          reason:
              'All 75 canonical botanical reference images must rank in Top-3');
    });
  });
}
