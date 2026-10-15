import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/models/safety_verification_checklist.dart';

void main() {
  group('BotanicalSafetyChecklist Unit Tests', () {
    test('Returns tailored checklist for Lactarius species', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('lactarius_deliciosus');
      expect(checklist.speciesId, equals('lactarius_deliciosus'));
      expect(checklist.items.length, greaterThanOrEqualTo(2));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('latex_orange'));
      expect(itemIds, contains('margin_smooth'));

      // Verify trilingual strings
      final milkItem =
          checklist.items.firstWhere((i) => i.id == 'latex_orange');
      expect(milkItem.getQuestion('ca'), contains('làtex'));
      expect(milkItem.getQuestion('es'), contains('látex'));
      expect(milkItem.getQuestion('en'), contains('latex'));

      expect(milkItem.getQuestion('ca'), contains('taronja'));
      expect(milkItem.getQuestion('es'), contains('naranja'));
      expect(milkItem.getQuestion('en'), contains('orange'));

      expect(milkItem.getDetail('ca'), contains('chrysorrheus'));
      expect(milkItem.getDetail('es'), contains('chrysorrheus'));
      expect(milkItem.getDetail('en'), contains('chrysorrheus'));
    });

    test('Returns tailored checklist for Agaricus species', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('agaricus_campestris');
      expect(checklist.speciesId, equals('agaricus_campestris'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('no_yellow_staining'));
      expect(itemIds, contains('gills_pink_not_white'));
      expect(itemIds, contains('no_volva'));

      final yellowItem =
          checklist.items.firstWhere((i) => i.id == 'no_yellow_staining');
      expect(yellowItem.getQuestion('ca'), contains('groc'));
      expect(yellowItem.getQuestion('es'), contains('amarillo'));
      expect(yellowItem.getQuestion('en'), contains('yellow'));
    });

    test('Returns tailored checklist for Calocybe gambosa', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('calocybe_gambosa');
      expect(checklist.speciesId, equals('calocybe_gambosa'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('gills_crowded_white'));
      expect(itemIds, contains('flour_scent'));
    });

    test('Returns tailored checklist for Macrolepiota procera', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('macrolepiota_procera');
      expect(checklist.speciesId, equals('macrolepiota_procera'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('movable_double_ring'));
      expect(itemIds, contains('large_size_snakeskin'));

      final ringItem =
          checklist.items.firstWhere((i) => i.id == 'movable_double_ring');
      expect(ringItem.getQuestion('ca'), contains('anell'));
      expect(ringItem.getQuestion('es'), contains('anillo'));
      expect(ringItem.getQuestion('en'), contains('ring'));
    });

    test('Returns tailored checklist for Tricholoma terreum', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('tricholoma_terreum');
      expect(checklist.speciesId, equals('tricholoma_terreum'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('stem_fragile_hollow'));
      expect(itemIds, contains('cap_fibrous_not_shingled'));
    });

    test('Returns tailored checklist for Boletus edulis', () {
      final checklist = BotanicalSafetyChecklist.getChecklist('boletus_edulis');
      expect(checklist.speciesId, equals('boletus_edulis'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('pores_white_yellow'));
      expect(itemIds, contains('flesh_immutable'));

      final poreItem =
          checklist.items.firstWhere((i) => i.id == 'pores_white_yellow');
      expect(poreItem.getDetail('ca'), contains('Mataparent'));
      expect(poreItem.getDetail('es'), contains('Satanás'));
      expect(poreItem.getDetail('en'), contains('Rubroboletus'));
    });

    test(
        'Returns tailored checklist for Morchella esculenta (ruling out Gyromitra)',
        () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('morchella_esculenta');
      expect(checklist.speciesId, equals('morchella_esculenta'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('morchella_cap_hollow'));
      expect(itemIds, contains('morchella_honeycomb_pits'));

      final hollowItem =
          checklist.items.firstWhere((i) => i.id == 'morchella_cap_hollow');
      expect(hollowItem.getQuestion('ca'), contains('buit'));
      expect(hollowItem.getDetail('ca'), contains('Gyromitra'));
      expect(hollowItem.getDetail('es'), contains('Gyromitra'));
      expect(hollowItem.getDetail('en'), contains('Gyromitra'));
    });

    test(
        'Returns tailored checklist for Cantharellus cibarius (ruling out Omphalotus)',
        () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('cantharellus_cibarius');
      expect(checklist.speciesId, equals('cantharellus_cibarius'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('cantharellus_false_gills'));
      expect(itemIds, contains('cantharellus_ground_habitat'));

      final gillItem =
          checklist.items.firstWhere((i) => i.id == 'cantharellus_false_gills');
      expect(gillItem.getDetail('ca'), contains('Omphalotus'));
    });

    test('Returns tailored checklist for Lepista nuda (ruling out Cortinarius)',
        () {
      final checklist = BotanicalSafetyChecklist.getChecklist('lepista_nuda');
      expect(checklist.speciesId, equals('lepista_nuda'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('lepista_no_cortina'));
      expect(itemIds, contains('lepista_spore_odor'));

      final cortinaItem =
          checklist.items.firstWhere((i) => i.id == 'lepista_no_cortina');
      expect(cortinaItem.getDetail('ca'), contains('Cortinaris'));
    });

    test('Returns tailored checklist for Marasmius oreades (stem elasticity)',
        () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('marasmius_oreades');
      expect(checklist.speciesId, equals('marasmius_oreades'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('marasmius_stem_elasticity'));
      expect(itemIds, contains('marasmius_pasture_gills'));
    });

    test(
        'Returns tailored checklist for Amanita caesarea (egg volva & yellow gills)',
        () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('amanita_caesarea');
      expect(checklist.speciesId, equals('amanita_caesarea'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('caesarea_cap_smooth_orange'));
      expect(itemIds, contains('caesarea_yellow_gills_stem'));
      expect(itemIds, contains('caesarea_saccate_volva'));

      final volvaItem =
          checklist.items.firstWhere((i) => i.id == 'caesarea_saccate_volva');
      expect(volvaItem.getQuestion('ca'), contains('volva'));
    });

    test('Returns tailored checklist for Boletus aereus', () {
      final checklist = BotanicalSafetyChecklist.getChecklist('boletus_aereus');
      expect(checklist.speciesId, equals('boletus_aereus'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('pores_white_yellow'));
      expect(itemIds, contains('flesh_immutable'));
    });

    test(
        'Returns tailored checklist for Tricholoma equestre (toxicity warning)',
        () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('tricholoma_equestre');
      expect(checklist.speciesId, equals('tricholoma_equestre'));

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('equestre_toxicity_caution'));
      expect(itemIds, contains('equestre_bright_yellow'));
    });

    test(
        'Returns deadly acknowledgement checklist for Amanita phalloides & Gyromitra',
        () {
      final phalloides =
          BotanicalSafetyChecklist.getChecklist('amanita_phalloides');
      expect(phalloides.items.map((i) => i.id),
          containsAll(['deadly_acknowledgement', 'study_only_confirmation']));

      final gyromitra =
          BotanicalSafetyChecklist.getChecklist('gyromitra_esculenta');
      expect(gyromitra.items.map((i) => i.id),
          containsAll(['deadly_acknowledgement', 'study_only_confirmation']));
    });

    test('Falls back to general safety checklist for unspecified species', () {
      final checklist =
          BotanicalSafetyChecklist.getChecklist('unknown_mushroom_xyz');
      expect(checklist.speciesId, equals('unknown_mushroom_xyz'));
      expect(checklist.items, isNotEmpty);

      final itemIds = checklist.items.map((i) => i.id).toList();
      expect(itemIds, contains('general_base_volva'));
      expect(itemIds, contains('general_comparison_reviewed'));

      final volvaItem =
          checklist.items.firstWhere((i) => i.id == 'general_base_volva');
      expect(volvaItem.getQuestion('ca'), contains('volva'));
      expect(volvaItem.getQuestion('es'), contains('volva'));
      expect(volvaItem.getQuestion('en'), contains('volva'));
    });
  });
}
