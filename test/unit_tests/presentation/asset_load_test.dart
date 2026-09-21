import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/theme/retro_decorations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All 21 mushroom and 5 tree pixel art assets load via rootBundle',
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
