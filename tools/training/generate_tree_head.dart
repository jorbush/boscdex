// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Extracts GAP features and generates tree_classifier_head.bin',
      () async {
    const inputSize = 224;
    const featureDim = 1280;

    final treeLabels = [
      'pinus_sylvestris',
      'pinus_halepensis',
      'quercus_ilex',
      'fagus_sylvatica',
      'castanea_sativa',
    ];
    final numClasses = treeLabels.length;

    final modelFile = File('assets/models/tree_classifier.tflite');
    expect(modelFile.existsSync(), isTrue);

    final interpreter = Interpreter.fromFile(modelFile);
    expect(interpreter, isNotNull);

    Future<List<double>> extractFeatures(Uint8List imageBytes) async {
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: inputSize,
        targetHeight: inputSize,
      );
      final frame = await codec.getNextFrame();
      final byteData =
          await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final pixels = byteData!.buffer.asUint8List();

      final floatList = Float32List(inputSize * inputSize * 3);
      int pIdx = 0;
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final offset = (y * inputSize + x) * 4;
          floatList[pIdx++] = pixels[offset].toDouble();
          floatList[pIdx++] = pixels[offset + 1].toDouble();
          floatList[pIdx++] = pixels[offset + 2].toDouble();
        }
      }

      final gapOutput = List.filled(featureDim, 0.0).reshape([1, featureDim]);
      interpreter.run(floatList.buffer, gapOutput);
      return (gapOutput[0] as List).cast<double>();
    }

    final classFeatures = <String, List<List<double>>>{};

    for (final treeId in treeLabels) {
      classFeatures[treeId] = [];

      // 1. Botanical high-res illustration
      final botanicalFile = File('assets/images/trees/$treeId.png');
      if (botanicalFile.existsSync()) {
        final feats = await extractFeatures(botanicalFile.readAsBytesSync());
        classFeatures[treeId]!.add(feats);
      }

      // 2. Real field photos from test/assets/trees/<treeId>/
      final dir = Directory('test/assets/trees/$treeId');
      if (dir.existsSync()) {
        final photos = dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.png'));
        for (final photo in photos) {
          final feats = await extractFeatures(photo.readAsBytesSync());
          classFeatures[treeId]!.add(feats);
        }
      }

      print(
          '🌲 $treeId: Extracted features from ${classFeatures[treeId]!.length} images');
      expect(classFeatures[treeId]!, isNotEmpty);
    }

    // Compute normalized class prototype centroids
    final centroids = <List<double>>[];
    for (int i = 0; i < numClasses; i++) {
      final treeId = treeLabels[i];
      final samples = classFeatures[treeId]!;

      final sumVector = List.filled(featureDim, 0.0);
      for (final s in samples) {
        // L2 normalize sample vector
        double norm = 0.0;
        for (final v in s) norm += v * v;
        norm = math.sqrt(norm);
        if (norm > 0) {
          for (int j = 0; j < featureDim; j++) {
            sumVector[j] += s[j] / norm;
          }
        }
      }

      // Normalize centroid
      double cNorm = 0.0;
      for (final v in sumVector) cNorm += v * v;
      cNorm = math.sqrt(cNorm);

      final centroid = List.filled(featureDim, 0.0);
      for (int j = 0; j < featureDim; j++) {
        centroid[j] = cNorm > 0 ? (sumVector[j] / cNorm) : 0.0;
      }
      centroids.add(centroid);
    }

    // Temperature scaling factor to calibrate confidence logits (typical ~14.0 for cosine classifiers)
    const double temperature = 14.0;

    // Pack into classifier head binary format:
    // Biases: Float32List(numClasses) -> all 0.0 (or calibrated prior)
    // Weights: Float32List(numClasses * featureDim) -> temperature * centroid
    final headBytes = BytesBuilder();

    // 1. Biases (numClasses * 4 bytes)
    final biasesByteData = ByteData(numClasses * 4);
    for (int i = 0; i < numClasses; i++) {
      biasesByteData.setFloat32(i * 4, 0.0, Endian.little);
    }
    headBytes.add(biasesByteData.buffer.asUint8List());

    // 2. Weights (numClasses * featureDim * 4 bytes)
    final weightsByteData = ByteData(numClasses * featureDim * 4);
    int wOffset = 0;
    for (int i = 0; i < numClasses; i++) {
      for (int j = 0; j < featureDim; j++) {
        final w = centroids[i][j] * temperature;
        weightsByteData.setFloat32(wOffset, w, Endian.little);
        wOffset += 4;
      }
    }
    headBytes.add(weightsByteData.buffer.asUint8List());

    final headFile = File('assets/models/tree_classifier_head.bin');
    headFile.writeAsBytesSync(headBytes.toBytes(), flush: true);

    print(
        '📦 Successfully generated ${headFile.path} (${headFile.lengthSync()} bytes)');
    expect(headFile.lengthSync(),
        equals(numClasses * 4 + numClasses * featureDim * 4));

    // Verify self-accuracy against all samples
    int totalEvaluated = 0;
    int top1Correct = 0;

    for (int i = 0; i < numClasses; i++) {
      final treeId = treeLabels[i];
      final samples = classFeatures[treeId]!;

      for (final s in samples) {
        totalEvaluated++;

        // Compute logits
        final logits = List.generate(numClasses, (c) {
          double dot = 0.0;
          for (int j = 0; j < featureDim; j++) {
            dot += centroids[c][j] * temperature * s[j];
          }
          return dot;
        });

        // Find max
        int bestClass = 0;
        double bestLogit = logits[0];
        for (int c = 1; c < numClasses; c++) {
          if (logits[c] > bestLogit) {
            bestLogit = logits[c];
            bestClass = c;
          }
        }

        if (bestClass == i) top1Correct++;
      }
    }

    final accuracy = (top1Correct / totalEvaluated) * 100;
    print(
        '📊 Tree Prototype Classifier Accuracy: $top1Correct/$totalEvaluated (${accuracy.toStringAsFixed(1)}%)');
    expect(accuracy, greaterThan(80.0));

    interpreter.close();
  });
}
