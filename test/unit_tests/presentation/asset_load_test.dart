import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All 75 mushroom and 5 tree pixel art assets load via rootBundle',
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
      'marasmius_oreades',
      'lactarius_chrysorrheus',
      'lepista_nuda',
      'rubroboletus_satanas',
      'russula_virescens',
      'hygrophorus_eburneus',
      'tricholoma_pardinum',
      'morchella_esculenta',
      'agaricus_campestris',
      'agaricus_xanthodermus',
      'psathyrella_candolleana',
      'suillus_granulatus',
      'hygrophorus_russula',
      'boletus_aereus',
      'coprinus_comatus',
      'lactarius_torminosus',
      'amanita_pantherina',
      'gyromitra_esculenta',
      'hygrophorus_personii',
      'pleurotus_eryngii',
      'lactarius_semisanguifluus',
      'suillus_bellinii',
      'tricholoma_equestre',
      'amanita_virosa',
      'galerina_marginata',
      'tuber_melanosporum',
      'scleroderma_citrinum',
      'infundibulicybe_geotropa',
      'clitocybe_nebularis',
      'boletus_pinophilus',
      'neoboletus_luridiformis',
      'suillellus_luridus',
      'tylopilus_felleus',
      'boletus_reticulatus',
      'hygrophorus_marzuolus',
      'russula_aurea',
      'russula_emetica',
      'craterellus_tubaeformis',
      'agaricus_arvensis',
      'hydnum_rufescens',
      'cyclocybe_aegerita',
      'tricholoma_portentosum',
      'tuber_aestivum',
      'amanita_rubescens',
      'imleria_badia',
      'lactarius_vinosus',
      'cantharellus_subpruinosus',
      'leccinum_aurantiacum',
      'hypholoma_fasciculare',
      'paxillus_involutus',
      'amanita_citrina',
      'tricholoma_saponaceum',
      'inocybe_erubescens',
    ];

    expect(mushrooms.length, equals(75));

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

    final pixelPinActive =
        await rootBundle.load('assets/icons/pixel_pin_active.png');
    expect(pixelPinActive.lengthInBytes, greaterThan(0),
        reason: 'Active pixel zone pin asset must load');

    final pixelPinInactive =
        await rootBundle.load('assets/icons/pixel_pin_inactive.png');
    expect(pixelPinInactive.lengthInBytes, greaterThan(0),
        reason: 'Inactive pixel zone pin asset must load');

    final pixelCompass =
        await rootBundle.load('assets/icons/pixel_compass.png');
    expect(pixelCompass.lengthInBytes, greaterThan(0),
        reason: 'Pixel compass asset must load');

    final cataloniaMap =
        await rootBundle.load('assets/images/map/catalonia_pixel_map.jpg');
    expect(cataloniaMap.lengthInBytes, greaterThan(0),
        reason: 'Catalonia pixel map image must load');
  });

  test('Trained mushroom TFLite model and labels load via rootBundle',
      () async {
    final modelData =
        await rootBundle.load('assets/models/mushroom_classifier.tflite');
    expect(modelData.lengthInBytes, greaterThan(2 * 1024 * 1024),
        reason: 'Model should be ~2.5 MB quantized INT8 network');

    final headData =
        await rootBundle.load('assets/models/mushroom_classifier_head.bin');
    expect(headData.lengthInBytes, greaterThan(100 * 1024),
        reason:
            'Classifier head should contain 75 biases + 75x1280 Float32 weights');

    final labelsString =
        await rootBundle.loadString('assets/models/mushroom_labels.txt');
    final labels = labelsString.trim().split('\n');
    expect(labels.length, equals(75));
    expect(labels, contains('lactarius_deliciosus'));
    expect(labels, contains('amanita_caesarea'));
    expect(labels, contains('boletus_edulis'));
    expect(labels, contains('chroogomphus_rutilus'));
  });

  test('Tree TFLite model and labels load via rootBundle', () async {
    final modelData =
        await rootBundle.load('assets/models/tree_classifier.tflite');
    expect(modelData.lengthInBytes, greaterThan(2 * 1024 * 1024),
        reason: 'Tree model should be ~2.5 MB quantized MobileNetV2');

    final headData =
        await rootBundle.load('assets/models/tree_classifier_head.bin');
    expect(headData.lengthInBytes, greaterThan(20 * 1024),
        reason:
            'Tree classifier head should contain 5 biases + 5x1280 Float32 weights (~25 KB)');

    final labelsString =
        await rootBundle.loadString('assets/models/tree_labels.txt');
    final labels = labelsString.trim().split('\n');
    expect(labels.length, equals(5));
    expect(labels, contains('pinus_sylvestris'));
    expect(labels, contains('pinus_halepensis'));
    expect(labels, contains('quercus_ilex'));
    expect(labels, contains('fagus_sylvatica'));
    expect(labels, contains('castanea_sativa'));
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

  test('All 4 retro 8-bit audio sound effects load via rootBundle', () async {
    const audioFiles = [
      'assets/audio/discovery.wav',
      'assets/audio/badge.wav',
      'assets/audio/shutter.wav',
      'assets/audio/blip.wav',
    ];

    for (final path in audioFiles) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0),
          reason: 'Expected $path to exist and have non-zero audio content');
    }
  });
}
