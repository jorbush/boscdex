import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All 22 mushroom and 5 tree pixel art assets load via rootBundle',
      () async {
    const mushrooms = [
      'lactarius_deliciosus',
      'boletus_edulis',
      'cantharellus_cibarius',
      'amanita_caesarea',
      'craterellus_cornucopioides',
      'macrolepiota_procera',
      'tricholoma_terreum',
      'calocybe_gambosa',
      'pleurotus_ostreatus',
      'hydnum_repandum',
      'hygrophorus_latitabundus',
      'craterellus_lutescens',
      'suillus_luteus',
      'russula_cyanoxantha',
      'amanita_muscaria',
      'omphalotus_olearius',
      'entoloma_sinuatum',
      'amanita_phalloides',
      'amanita_verna',
      'cortinarius_orellanus',
      'lactarius_sanguifluus',
      'chroogomphus_rutilus',
    ];

    for (final id in mushrooms) {
      final path = 'assets/images/mushrooms/$id.png';
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0),
          reason: 'Expected $path to have content');
    }

    const trees = [
      'pinus_sylvestris',
      'pinus_halepensis',
      'quercus_ilex',
      'fagus_sylvatica',
      'castanea_sativa',
    ];

    for (final id in trees) {
      final path = 'assets/images/trees/$id.png';
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0),
          reason: 'Expected $path to have content');
    }

    final silhouetteData =
        await rootBundle.load('assets/images/silhouettes/generic_mushroom.png');
    expect(silhouetteData.lengthInBytes, greaterThan(0));

    final logoData = await rootBundle.load('assets/icons/boscdex_logo.png');
    expect(logoData.lengthInBytes, greaterThan(0),
        reason: 'Boscdex canonical logo asset must load');

    final mascotData = await rootBundle.load('assets/icons/boscdex_mascot.png');
    expect(mascotData.lengthInBytes, greaterThan(0),
        reason: 'Boscdex mascot logo asset must load');

    final pixelBoletData =
        await rootBundle.load('assets/icons/pixel_bolet.png');
    expect(pixelBoletData.lengthInBytes, greaterThan(0),
        reason: 'Pixel bolet tab icon must load');

    final pixelArbreData =
        await rootBundle.load('assets/icons/pixel_arbre.png');
    expect(pixelArbreData.lengthInBytes, greaterThan(0),
        reason: 'Pixel arbre tab icon must load');

    final pixelTrophyData =
        await rootBundle.load('assets/icons/pixel_trophy.png');
    expect(pixelTrophyData.lengthInBytes, greaterThan(0),
        reason: 'Pixel trophy icon must load');
  });

  test('Trained TFLite model and labels load via rootBundle', () async {
    final modelData =
        await rootBundle.load('assets/models/boscdex_classifier.tflite');
    expect(modelData.lengthInBytes, greaterThan(2 * 1024 * 1024),
        reason: 'Model should be ~2.5 MB quantized INT8 network');

    final headData = await rootBundle.load('assets/models/classifier_head.bin');
    expect(headData.lengthInBytes, greaterThan(100 * 1024),
        reason:
            'Classifier head should contain 20 biases + 20x1280 Float32 weights (~102 KB)');

    final labelsString =
        await rootBundle.loadString('assets/models/labels.txt');
    final labels = labelsString.trim().split('\n');
    expect(labels.length, equals(20));
    expect(labels, contains('lactarius_deliciosus'));
    expect(labels, contains('amanita_caesarea'));
    expect(labels, contains('boletus_edulis'));
  });

  testWidgets('Renders ColorFiltered silhouette properly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              RetroColors.ink,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/images/mushrooms/boletus_edulis.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
