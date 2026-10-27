import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/models/culinary_recipe.dart';

void main() {
  group('CulinaryRecipe Domain Model', () {
    test('contains exactly 24 gourmet species in registry', () {
      expect(CulinaryRecipe.gourmetSpeciesIds.length, equals(24));
    });

    test('all 24 gourmet species resolve a valid CulinaryRecipe', () {
      for (final id in CulinaryRecipe.gourmetSpeciesIds) {
        final recipe = CulinaryRecipe.forSpecies(id);
        expect(recipe, isNotNull, reason: 'Expected recipe for $id');
        expect(recipe!.speciesId, equals(id));
      }
    });

    test('non-gourmet species return null', () {
      expect(CulinaryRecipe.forSpecies('amanita_phalloides'), isNull);
      expect(CulinaryRecipe.forSpecies('scleroderma_citrinum'), isNull);
      expect(CulinaryRecipe.forSpecies('non_existent_mushroom'), isNull);
    });

    test('all recipes have non-empty localized fields across CA, ES, and EN',
        () {
      const languages = ['ca', 'es', 'en'];

      for (final id in CulinaryRecipe.gourmetSpeciesIds) {
        final recipe = CulinaryRecipe.forSpecies(id)!;

        for (final lang in languages) {
          final dishName = recipe.getDishName(lang);
          expect(dishName, isNotEmpty,
              reason: 'Empty dish name for $id in $lang');

          final desc = recipe.getDescription(lang);
          expect(desc, isNotEmpty,
              reason: 'Empty description for $id in $lang');

          final method = recipe.getMethod(lang);
          expect(method, isNotEmpty, reason: 'Empty method for $id in $lang');

          final tip = recipe.getTip(lang);
          expect(tip, isNotEmpty, reason: 'Empty tip for $id in $lang');

          final wine = recipe.getWinePairing(lang);
          expect(wine, isNotEmpty,
              reason: 'Empty wine pairing for $id in $lang');
        }
      }
    });

    test('unknown language codes fall back safely to Catalan (ca)', () {
      final recipe = CulinaryRecipe.forSpecies('tuber_melanosporum')!;
      expect(recipe.getDishName('fr'), equals(recipe.dishNameCa));
      expect(recipe.getDescription('de'), equals(recipe.descriptionCa));
      expect(recipe.getMethod('it'), equals(recipe.methodCa));
      expect(recipe.getTip('ja'), equals(recipe.tipCa));
      expect(recipe.getWinePairing('pt'), equals(recipe.winePairingCa));
    });

    test('neoboletus_luridiformis contains mandatory cooking safety warning',
        () {
      final recipe = CulinaryRecipe.forSpecies('neoboletus_luridiformis')!;
      expect(recipe.getTip('ca'), contains('⚠️'));
      expect(recipe.getTip('ca'), contains('tòxic'));
      expect(recipe.getTip('es'), contains('⚠️'));
      expect(recipe.getTip('es'), contains('Tóxico'));
      expect(recipe.getTip('en'), contains('⚠️'));
      expect(recipe.getTip('en'), contains('Toxic'));
    });

    test('amanita_rubescens contains mandatory cooking safety warning', () {
      final recipe = CulinaryRecipe.forSpecies('amanita_rubescens')!;
      expect(recipe.getTip('ca'), contains('ALERTA DE SEGURETAT'));
      expect(recipe.getTip('es'), contains('ALERTA DE SEGURIDAD'));
      expect(recipe.getTip('en'), contains('CRITICAL SAFETY WARNING'));
    });
  });
}
