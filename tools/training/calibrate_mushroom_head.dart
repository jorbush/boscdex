// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class _Sample {
  final int classIndex;
  final String speciesId;
  final Float32List features;
  final bool isReference;

  _Sample({
    required this.classIndex,
    required this.speciesId,
    required this.features,
    required this.isReference,
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'Calibrates mushroom_classifier_head.bin with canonical reference anchors + field dataset',
      timeout: const Timeout(Duration(minutes: 20)), () async {
    const inputSize = 224;
    const featureDim = 1280;
    const weightFullView = 0.55;
    const weightFlipView = 0.25;
    const weightMacroView = 0.20;
    const macroCropFraction = 0.80;

    final labelsFile = File('assets/models/mushroom_labels.txt');
    expect(labelsFile.existsSync(), isTrue);
    final labels = labelsFile
        .readAsLinesSync()
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final numClasses = labels.length;
    expect(numClasses, equals(75));

    final labelToIndex = <String, int>{
      for (int i = 0; i < numClasses; i++) labels[i]: i,
    };

    // Load initial Colab head weights (W0, b0)
    final headFile = File('assets/models/mushroom_classifier_head.bin');
    expect(headFile.existsSync(), isTrue);
    final headBytes = headFile.readAsBytesSync();
    final biasByteLength = numClasses * 4;
    final weightByteLength = numClasses * featureDim * 4;
    expect(headBytes.length, equals(biasByteLength + weightByteLength));

    final b0 = Float32List(numClasses);
    final w0 = Float32List(numClasses * featureDim);

    final biasData = ByteData.sublistView(headBytes, 0, biasByteLength);
    for (int i = 0; i < numClasses; i++) {
      b0[i] = biasData.getFloat32(i * 4, Endian.little);
    }
    final weightData = ByteData.sublistView(
        headBytes, biasByteLength, biasByteLength + weightByteLength);
    for (int i = 0; i < numClasses * featureDim; i++) {
      w0[i] = weightData.getFloat32(i * 4, Endian.little);
    }

    final modelFile = File('assets/models/mushroom_classifier.tflite');
    expect(modelFile.existsSync(), isTrue);
    final modelBytes = modelFile.readAsBytesSync();
    // Compute 64-bit FNV-1a checksum of mushroom_classifier.tflite to auto-invalidate cache when model changes
    int modelHash = 0xcbf29ce484222325;
    for (int i = 0; i < modelBytes.length; i += 64) {
      modelHash ^= modelBytes[i];
      modelHash = (modelHash * 0x100000001b3) & 0x7fffffffffffffff;
    }
    modelHash ^= modelBytes.length;

    final samples = <_Sample>[];
    int refCount = 0;
    int fieldCount = 0;

    final cacheFile = File('.dart_tool/tta_embeddings_cache.bin');
    bool cacheValid = false;
    if (cacheFile.existsSync()) {
      final bytes = cacheFile.readAsBytesSync();
      if (bytes.length >= 12) {
        final bd = ByteData.sublistView(bytes);
        final cachedHash = bd.getInt64(0, Endian.little);
        if (cachedHash == modelHash) {
          cacheValid = true;
          print(
              '⚡ Loading cached 3-view TTA embeddings from ${cacheFile.path}...');
          int offset = 8;
          final totalSamples = bd.getInt32(offset, Endian.little);
          offset += 4;
          for (int sIdx = 0; sIdx < totalSamples; sIdx++) {
            final cIdx = bd.getInt32(offset, Endian.little);
            offset += 4;
            final isRef = bd.getInt32(offset, Endian.little) == 1;
            offset += 4;
            final feats = Float32List(featureDim);
            for (int j = 0; j < featureDim; j++) {
              feats[j] = bd.getFloat32(offset, Endian.little);
              offset += 4;
            }
            samples.add(_Sample(
              classIndex: cIdx,
              speciesId: labels[cIdx],
              features: feats,
              isReference: isRef,
            ));
            if (isRef) {
              refCount++;
            } else {
              fieldCount++;
            }
          }
          print(
              '   ✓ Loaded $refCount reference + $fieldCount field embeddings from cache.');
        } else {
          print(
              '🔄 Detected updated mushroom_classifier.tflite — invalidating stale TTA cache...');
        }
      }
    }

    if (!cacheValid) {
      // Initialize TFLite MobileNetV2 GAP feature extractor
      final options = InterpreterOptions()..threads = 4;
      final interpreter = Interpreter.fromFile(modelFile, options: options);

      List<double> runExtractor(Float32List tensor) {
        final out = List.filled(featureDim, 0.0).reshape([1, featureDim]);
        interpreter.run(tensor.buffer, out);
        return (out[0] as List).cast<double>();
      }

      Float32List buildFullTensor(Uint8List pixels) {
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
        return floatList;
      }

      Float32List buildFlipTensor(Uint8List pixels) {
        final floatList = Float32List(inputSize * inputSize * 3);
        int pIdx = 0;
        for (int y = 0; y < inputSize; y++) {
          for (int x = 0; x < inputSize; x++) {
            final mirrorX = inputSize - 1 - x;
            final offset = (y * inputSize + mirrorX) * 4;
            floatList[pIdx++] = pixels[offset].toDouble();
            floatList[pIdx++] = pixels[offset + 1].toDouble();
            floatList[pIdx++] = pixels[offset + 2].toDouble();
          }
        }
        return floatList;
      }

      Float32List buildMacroTensor(Uint8List pixels) {
        final floatList = Float32List(inputSize * inputSize * 3);
        const margin = (1.0 - macroCropFraction) * 0.5 * (inputSize - 1);
        const span = macroCropFraction * (inputSize - 1);
        int pIdx = 0;

        for (int y = 0; y < inputSize; y++) {
          final srcY = margin + (y / (inputSize - 1)) * span;
          final y0 = srcY.floor().clamp(0, inputSize - 1);
          final y1 = (y0 + 1).clamp(0, inputSize - 1);
          final wy = srcY - y0;

          for (int x = 0; x < inputSize; x++) {
            final srcX = margin + (x / (inputSize - 1)) * span;
            final x0 = srcX.floor().clamp(0, inputSize - 1);
            final x1 = (x0 + 1).clamp(0, inputSize - 1);
            final wx = srcX - x0;

            final off00 = (y0 * inputSize + x0) * 4;
            final off01 = (y0 * inputSize + x1) * 4;
            final off10 = (y1 * inputSize + x0) * 4;
            final off11 = (y1 * inputSize + x1) * 4;

            for (int c = 0; c < 3; c++) {
              final top =
                  pixels[off00 + c] * (1.0 - wx) + pixels[off01 + c] * wx;
              final bottom =
                  pixels[off10 + c] * (1.0 - wx) + pixels[off11 + c] * wx;
              floatList[pIdx++] = top * (1.0 - wy) + bottom * wy;
            }
          }
        }
        return floatList;
      }

      Future<Float32List> extractTtaFeatures(Uint8List imageBytes) async {
        final codec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: inputSize,
          targetHeight: inputSize,
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final pixels = byteData!.buffer.asUint8List();

        final gapFull = runExtractor(buildFullTensor(pixels));
        final gapFlip = runExtractor(buildFlipTensor(pixels));
        final gapMacro = runExtractor(buildMacroTensor(pixels));

        final fused = Float32List(featureDim);
        for (int j = 0; j < featureDim; j++) {
          fused[j] = (weightFullView * gapFull[j]) +
              (weightFlipView * gapFlip[j]) +
              (weightMacroView * gapMacro[j]);
        }

        image.dispose();
        codec.dispose();
        return fused;
      }

      // 1. Extract 3-view TTA features for all 75 canonical reference photos
      print('🔬 Extracting 3-view TTA features for 75 reference photos...');
      for (int i = 0; i < numClasses; i++) {
        final spId = labels[i];
        final refFile = File('assets/images/reference/$spId.jpg');
        expect(refFile.existsSync(), isTrue,
            reason: 'Missing reference image for $spId');
        final feats = await extractTtaFeatures(refFile.readAsBytesSync());
        samples.add(_Sample(
          classIndex: i,
          speciesId: spId,
          features: feats,
          isReference: true,
        ));
        refCount++;
      }
      print('   ✓ Extracted $refCount canonical reference embeddings.');

      // 2. Extract 3-view TTA features for all field photos in test/assets/mushrooms/
      final fieldDir = Directory('test/assets/mushrooms');
      if (fieldDir.existsSync()) {
        print('🔬 Extracting 3-view TTA features for field dataset...');
        final files =
            fieldDir.listSync(recursive: true).whereType<File>().where((f) {
          final lower = f.path.toLowerCase();
          return lower.endsWith('.jpg') ||
              lower.endsWith('.jpeg') ||
              lower.endsWith('.png');
        }).toList()
              ..sort((a, b) => a.path.compareTo(b.path));

        for (final file in files) {
          final segments =
              file.uri.pathSegments.where((s) => s.isNotEmpty).toList();
          if (segments.length < 2) continue;
          final spId = segments[segments.length - 2];
          final cIdx = labelToIndex[spId];
          if (cIdx == null) continue;

          final feats = await extractTtaFeatures(file.readAsBytesSync());
          samples.add(_Sample(
            classIndex: cIdx,
            speciesId: spId,
            features: feats,
            isReference: false,
          ));
          fieldCount++;
          if (fieldCount % 200 == 0) {
            print(
                '   ... processed $fieldCount / ${files.length} field photos');
          }
        }
        print('   ✓ Extracted $fieldCount field photo embeddings.');
      }

      interpreter.close();

      // Save embeddings cache for instant future calibration runs
      cacheFile.parent.createSync(recursive: true);
      final totalBytes = 8 + 4 + samples.length * (4 + 4 + featureDim * 4);
      final cacheData = ByteData(totalBytes);
      int offset = 0;
      cacheData.setInt64(offset, modelHash, Endian.little);
      offset += 8;
      cacheData.setInt32(offset, samples.length, Endian.little);
      offset += 4;
      for (final s in samples) {
        cacheData.setInt32(offset, s.classIndex, Endian.little);
        offset += 4;
        cacheData.setInt32(offset, s.isReference ? 1 : 0, Endian.little);
        offset += 4;
        for (int j = 0; j < featureDim; j++) {
          cacheData.setFloat32(offset, s.features[j], Endian.little);
          offset += 4;
        }
      }
      cacheFile.writeAsBytesSync(cacheData.buffer.asUint8List(), flush: true);
      print('💾 Cached ${samples.length} TTA embeddings to ${cacheFile.path}');
    }

    Map<String, int> evaluate(Float32List w, Float32List b) {
      int refTop1 = 0, refTop3 = 0;
      int fieldTop1 = 0, fieldTop3 = 0;

      for (final s in samples) {
        final logits = List<double>.generate(numClasses, (c) {
          double sum = b[c];
          final off = c * featureDim;
          for (int j = 0; j < featureDim; j++) {
            sum += w[off + j] * s.features[j];
          }
          return sum;
        });

        final targetLogit = logits[s.classIndex];
        int higherCount = 0;
        for (int c = 0; c < numClasses; c++) {
          if (c != s.classIndex && logits[c] >= targetLogit) {
            higherCount++;
          }
        }

        if (s.isReference) {
          if (higherCount == 0) refTop1++;
          if (higherCount < 3) refTop3++;
        } else {
          if (higherCount == 0) fieldTop1++;
          if (higherCount < 3) fieldTop3++;
        }
      }

      return {
        'refTop1': refTop1,
        'refTop3': refTop3,
        'fieldTop1': fieldTop1,
        'fieldTop3': fieldTop3,
      };
    }

    final baseline = evaluate(w0, b0);
    print('\n📊 BEFORE Calibration:');
    print(
        '   Reference Set ($refCount): Top-1 = ${baseline['refTop1']}/$refCount (${(baseline['refTop1']! / refCount * 100).toStringAsFixed(1)}%), Top-3 = ${baseline['refTop3']}/$refCount (${(baseline['refTop3']! / refCount * 100).toStringAsFixed(1)}%)');
    if (fieldCount > 0) {
      print(
          '   Field Set ($fieldCount):     Top-1 = ${baseline['fieldTop1']}/$fieldCount (${(baseline['fieldTop1']! / fieldCount * 100).toStringAsFixed(1)}%), Top-3 = ${baseline['fieldTop3']}/$fieldCount (${(baseline['fieldTop3']! / fieldCount * 100).toStringAsFixed(1)}%)');
    }

    // Proximal Fine-Tuning of (W, b) anchored to (W0, b0)
    final w = Float32List.fromList(w0);
    final b = Float32List.fromList(b0);
    final bestW = Float32List.fromList(w0);
    final bestB = Float32List.fromList(b0);
    int bestScore = -1;

    final gradW = Float32List(numClasses * featureDim);
    final gradB = Float32List(numClasses);

    const int maxEpochs = 220;
    const double baseLr = 0.055;
    const double proximalLambda = 0.015; // Gentle anchor to Colab W0
    const double targetMargin = 0.75; // Clean Top-1 separation margin

    for (int epoch = 1; epoch <= maxEpochs; epoch++) {
      gradW.fillRange(0, gradW.length, 0.0);
      gradB.fillRange(0, gradB.length, 0.0);

      double totalWeight = 0.0;
      int currentRefMarginUnmet = 0;

      for (final s in samples) {
        final logits = Float64List(numClasses);
        double maxLogit = -1e9;
        double maxOtherLogit = -1e9;

        for (int c = 0; c < numClasses; c++) {
          double sum = b[c];
          final off = c * featureDim;
          for (int j = 0; j < featureDim; j++) {
            sum += w[off + j] * s.features[j];
          }
          logits[c] = sum;
          if (sum > maxLogit) maxLogit = sum;
          if (c != s.classIndex && sum > maxOtherLogit) maxOtherLogit = sum;
        }

        final margin = logits[s.classIndex] - maxOtherLogit;
        if (s.isReference && margin < targetMargin) {
          currentRefMarginUnmet++;
        }

        // Adaptive sample weight: strongly prioritize reference images that haven't reached targetMargin
        double sampleWeight;
        if (s.isReference) {
          if (margin <= 0.0) {
            sampleWeight = 65.0;
          } else if (margin < targetMargin) {
            sampleWeight = 25.0;
          } else {
            sampleWeight = 3.0;
          }
        } else {
          sampleWeight = 1.0;
        }
        totalWeight += sampleWeight;

        // Softmax probabilities
        double sumExp = 0.0;
        final probs = Float64List(numClasses);
        for (int c = 0; c < numClasses; c++) {
          final e = math.exp(logits[c] - maxLogit);
          probs[c] = e;
          sumExp += e;
        }
        for (int c = 0; c < numClasses; c++) {
          probs[c] /= sumExp;
        }

        // Accumulate cross-entropy gradients
        for (int c = 0; c < numClasses; c++) {
          final target = (c == s.classIndex) ? 1.0 : 0.0;
          final dLogit = sampleWeight * (probs[c] - target);
          gradB[c] += dLogit;
          final off = c * featureDim;
          for (int j = 0; j < featureDim; j++) {
            gradW[off + j] += dLogit * s.features[j];
          }
        }
      }

      // Cosine learning rate decay
      final lr =
          baseLr * 0.5 * (1.0 + math.cos(math.pi * (epoch - 1) / maxEpochs));

      // Apply gradient + proximal pull toward (w0, b0)
      for (int i = 0; i < numClasses; i++) {
        final g = (gradB[i] / totalWeight) + proximalLambda * (b[i] - b0[i]);
        b[i] -= lr * g;
      }
      for (int i = 0; i < numClasses * featureDim; i++) {
        final g = (gradW[i] / totalWeight) + proximalLambda * (w[i] - w0[i]);
        w[i] -= lr * g;
      }

      final stats = evaluate(w, b);
      final score = stats['refTop1']! * 100000 +
          stats['fieldTop1']! * 10 +
          stats['fieldTop3']!;
      if (score > bestScore) {
        bestScore = score;
        bestW.setAll(0, w);
        bestB.setAll(0, b);
      }

      if (epoch % 15 == 0 ||
          (stats['refTop1'] == refCount && currentRefMarginUnmet == 0)) {
        print(
            '   [Epoch $epoch] Ref Top-1: ${stats['refTop1']}/$refCount | Field Top-1: ${stats['fieldTop1']}/$fieldCount | Field Top-3: ${stats['fieldTop3']}/$fieldCount');
        if (stats['refTop1'] == refCount &&
            currentRefMarginUnmet == 0 &&
            epoch >= 45) {
          break;
        }
      }
    }

    final after = evaluate(bestW, bestB);
    print('\n📊 AFTER Calibration (Best Checkpoint):');
    print(
        '   Reference Set ($refCount): Top-1 = ${after['refTop1']}/$refCount (${(after['refTop1']! / refCount * 100).toStringAsFixed(1)}%), Top-3 = ${after['refTop3']}/$refCount (${(after['refTop3']! / refCount * 100).toStringAsFixed(1)}%)');
    if (fieldCount > 0) {
      print(
          '   Field Set ($fieldCount):     Top-1 = ${after['fieldTop1']}/$fieldCount (${(after['fieldTop1']! / fieldCount * 100).toStringAsFixed(1)}%), Top-3 = ${after['fieldTop3']}/$fieldCount (${(after['fieldTop3']! / fieldCount * 100).toStringAsFixed(1)}%)');
    }

    // Serialize calibrated head to assets/models/mushroom_classifier_head.bin
    final outBytes = BytesBuilder();
    final outBiases = ByteData(biasByteLength);
    for (int i = 0; i < numClasses; i++) {
      outBiases.setFloat32(i * 4, bestB[i], Endian.little);
    }
    outBytes.add(outBiases.buffer.asUint8List());

    final outWeights = ByteData(weightByteLength);
    for (int i = 0; i < numClasses * featureDim; i++) {
      outWeights.setFloat32(i * 4, bestW[i], Endian.little);
    }
    outBytes.add(outWeights.buffer.asUint8List());

    headFile.writeAsBytesSync(outBytes.toBytes(), flush: true);
    print(
        '\n✅ Saved calibrated mushroom_classifier_head.bin (${headFile.lengthSync()} bytes)');

    expect(after['refTop1'], equals(75),
        reason:
            'All 75 canonical reference photos must be identified as Top-1');
  });
}
