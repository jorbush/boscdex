import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
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

      // Labels from assets/models/labels.txt should be parsed
      expect(service.labels.length, equals(20));
      expect(service.labels, contains('lactarius_deliciosus'));
      expect(service.labels, contains('amanita_caesarea'));
      expect(service.labels, contains('boletus_edulis'));
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

    test('Disposing service cleans up resources safely', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
