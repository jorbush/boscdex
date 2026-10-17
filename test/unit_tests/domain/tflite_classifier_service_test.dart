import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/localization/species_localizer.dart';
import 'package:boscdex/domain/services/tflite_classifier_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TfliteClassifierService Unit Tests', () {
    late TfliteClassifierService service;

    setUp(() {
      service = TfliteClassifierService();
    });

    tearDown(() {
      service.dispose();
    });

    test(
        'Initializes labels and classification head safely in test environment',
        () async {
      await service.initialize();

      // Labels from assets/models/mushroom_labels.txt should be parsed
      expect(service.labels.length, equals(47));
      expect(service.labels, contains('lactarius_deliciosus'));
      expect(service.labels, contains('amanita_caesarea'));
      expect(service.labels, contains('boletus_edulis'));
      expect(service.labels, contains('chroogomphus_rutilus'));
    });

    test('Classifying real mushroom specimen yields non-flat confidence',
        () async {
      await service.initialize();

      final sampleFile = File('assets/images/mushrooms/amanita_muscaria.png');
      if (sampleFile.existsSync()) {
        final sampleBytes = sampleFile.readAsBytesSync();
        final results = await service.classify(sampleBytes);

        expect(results, isNotEmpty);
        expect(results.length, equals(3));
        expect(results.first.confidence, greaterThan(0.20),
            reason:
                'Confidence should be significantly above flat 5% distribution');
        expect(results.first.boletId, isNotEmpty);
        expect(results.first.displayName, isNotEmpty);
      }
    });

    test('Empty bytes gracefully delegates to fallback classifier', () async {
      await service.initialize();
      final results = await service.classify(Uint8List(0));

      expect(results, isNotEmpty);
      expect(results.first.boletId, isNotEmpty);
      expect(results.first.displayName, isNotEmpty);
      expect(results.first.confidence, greaterThan(0.0));
    });

    test('Tree classification delegates to indicator tree analyzer', () async {
      await service.initialize();
      final treeResults = await service.classifyTree(Uint8List(0));

      expect(treeResults, isNotEmpty);
      expect(treeResults.first.arbreId, isNotEmpty);
      expect(treeResults.first.confidence, greaterThan(0.0));
    });

    test('Initializes tree labels and classification head on demand', () async {
      await service.initialize();

      // Tree model is lazy-loaded upon first tree classification
      final results = await service.classifyTree(Uint8List(0));
      expect(results, isNotEmpty);

      expect(service.treeLabels.length, equals(5));
      expect(service.treeLabels, contains('pinus_sylvestris'));
      expect(service.treeLabels, contains('quercus_ilex'));
      expect(service.treeLabels, contains('fagus_sylvatica'));
      expect(service.treeLabels, contains('castanea_sativa'));
      expect(service.treeLabels, contains('pinus_halepensis'));
    });

    test('Classifying real tree specimen yields valid tree prediction',
        () async {
      await service.initialize();

      final sampleFile =
          File('test/assets/trees/quercus_ilex/quercus_ilex_1.jpg');
      if (sampleFile.existsSync()) {
        final sampleBytes = sampleFile.readAsBytesSync();
        final results = await service.classifyTree(sampleBytes);

        expect(results, isNotEmpty);
        expect(results.first.arbreId, isNotEmpty);
        expect(results.first.displayName, isNotEmpty);
        expect(results.first.confidence, greaterThan(0.0));
      }
    });

    test(
        'All 47 model labels resolve non-empty Catalan names via SpeciesLocalizer',
        () async {
      await service.initialize();

      expect(service.labels.length, equals(47));
      for (final label in service.labels) {
        final caName =
            SpeciesLocalizer.getMushroomName(label, languageCode: 'ca');
        expect(
          caName,
          isNotEmpty,
          reason: 'Expected non-empty Catalan name for $label',
        );
        expect(
          caName,
          isNot(equals(label)),
          reason:
              'Expected localized Catalan display name rather than raw ID for $label',
        );
      }
    });

    test('3-view TTA classifies newly added 47-catalog species sprite cleanly',
        () async {
      await service.initialize();

      final sampleFile = File('assets/images/mushrooms/amanita_virosa.png');
      if (sampleFile.existsSync()) {
        final sampleBytes = sampleFile.readAsBytesSync();
        final results = await service.classify(sampleBytes);

        expect(results, isNotEmpty);
        expect(results.length, equals(3));
        expect(results.first.confidence, greaterThan(0.0));
        expect(results.first.displayName, isNot(equals(results.first.boletId)));
      }
    });

    test('Disposing service cleans up resources safely', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
