import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/services/reference_photo_service.dart';

void main() {
  group('ReferencePhotoService & Botanical Assets Tests', () {
    late ReferencePhotoService service;

    setUp(() {
      service = ReferencePhotoService();
    });

    test(
        'All 80 species (75 mushrooms + 5 indicator trees) have an attribution entry in attributions.json',
        () {
      final file = File('assets/images/reference/attributions.json');
      expect(file.existsSync(), isTrue,
          reason: 'attributions.json must exist in assets/images/reference/');

      final content = file.readAsStringSync();
      final List<dynamic> decoded = jsonDecode(content);

      expect(decoded.length, equals(80),
          reason: 'Must contain all 75 mushrooms + 5 indicator trees');

      final speciesIds = decoded
          .map((item) => (item as Map<String, dynamic>)['species_id'] as String)
          .toSet();

      expect(speciesIds.length, equals(80),
          reason: 'All 80 species IDs must be unique');

      final photoIds = decoded
          .map((item) =>
              (item as Map<String, dynamic>)['photo_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      expect(photoIds.length, equals(80),
          reason: 'All 80 reference photos must have unique photo_ids');

      // Verify all 5 indicator trees are present
      expect(speciesIds.contains('pinus_sylvestris'), isTrue);
      expect(speciesIds.contains('pinus_halepensis'), isTrue);
      expect(speciesIds.contains('quercus_ilex'), isTrue);
      expect(speciesIds.contains('fagus_sylvatica'), isTrue);
      expect(speciesIds.contains('castanea_sativa'), isTrue);

      // Verify each entry has valid fields and open license
      for (final item in decoded) {
        final attr =
            ReferencePhotoAttribution.fromJson(item as Map<String, dynamic>);
        expect(attr.speciesId.isNotEmpty, isTrue);
        expect(attr.scientificName.isNotEmpty, isTrue);
        expect(attr.author.isNotEmpty, isTrue);
        expect(attr.licenseCode.isNotEmpty, isTrue);
        expect(attr.sourceUrl.startsWith('http'), isTrue);
        expect(attr.isOpenLicense, isTrue,
            reason:
                'Species ${attr.speciesId} has non-open license: ${attr.licenseCode}');
      }
    });

    test(
        'All 80 reference photo JPEG files exist on disk with valid file size and unique byte contents',
        () {
      final file = File('assets/images/reference/attributions.json');
      final List<dynamic> decoded = jsonDecode(file.readAsStringSync());
      final seenByteSignatures = <String>{};

      for (final item in decoded) {
        final speciesId =
            (item as Map<String, dynamic>)['species_id'] as String;
        final photoFile = File('assets/images/reference/$speciesId.jpg');

        expect(photoFile.existsSync(), isTrue,
            reason: 'Photo $speciesId.jpg must exist on disk');
        final bytes = photoFile.readAsBytesSync();
        expect(bytes.length, greaterThan(5000),
            reason: 'Photo $speciesId.jpg must be at least 5 KB');

        final signature =
            '${bytes.length}:${base64Encode(bytes.sublist(0, 64))}:${base64Encode(bytes.sublist(bytes.length - 64))}';
        expect(seenByteSignatures.contains(signature), isFalse,
            reason: 'Duplicate image file content detected for $speciesId.jpg');
        seenByteSignatures.add(signature);
      }
    });

    test('ReferencePhotoService resolves paths and attributions correctly', () {
      const sampleAttr = ReferencePhotoAttribution(
        speciesId: 'lactarius_deliciosus',
        scientificName: 'Lactarius deliciosus',
        catalanName: 'Rovelló / Pinetell',
        author: 'Fabian Brambach',
        licenseCode: 'cc-by',
        licenseName: 'CC BY 4.0',
        attributionText: '(c) Fabian Brambach, CC BY',
        sourceUrl: 'https://www.inaturalist.org/observations/12345',
        assetPath: 'assets/images/reference/lactarius_deliciosus.jpg',
      );

      service.setAttributionsForTesting({
        'lactarius_deliciosus': sampleAttr,
      });

      expect(service.getReferenceAssetPath('lactarius_deliciosus'),
          equals('assets/images/reference/lactarius_deliciosus.jpg'));
      expect(
          service.getAttribution('lactarius_deliciosus'), equals(sampleAttr));
      expect(service.getAttribution('lactarius_deliciosus')!.isOpenLicense,
          isTrue);
      expect(service.getAllAttributions().length, equals(1));
    });

    test('ReferencePhotoAttribution serialization round-trip', () {
      const attr = ReferencePhotoAttribution(
        speciesId: 'boletus_edulis',
        scientificName: 'Boletus edulis',
        catalanName: 'Cep',
        photoId: 98765,
        author: 'Rafael Medina',
        licenseCode: 'cc-by',
        licenseName: 'CC BY 4.0',
        attributionText: '(c) Rafael Medina, CC BY',
        sourceUrl: 'https://www.inaturalist.org/observations/98765',
        assetPath: 'assets/images/reference/boletus_edulis.jpg',
      );

      final json = attr.toJson();
      final reconstructed = ReferencePhotoAttribution.fromJson(json);

      expect(reconstructed.speciesId, equals(attr.speciesId));
      expect(reconstructed.scientificName, equals(attr.scientificName));
      expect(reconstructed.catalanName, equals(attr.catalanName));
      expect(reconstructed.photoId, equals(attr.photoId));
      expect(reconstructed.author, equals(attr.author));
      expect(reconstructed.licenseCode, equals(attr.licenseCode));
      expect(reconstructed.isOpenLicense, isTrue);
    });

    test('ATTRIBUTIONS.md exists and credits communities', () {
      final md = File('assets/images/reference/ATTRIBUTIONS.md');
      expect(md.existsSync(), isTrue);
      final text = md.readAsStringSync();
      expect(text.contains('iNaturalist'), isTrue);
      expect(text.contains('Creative Commons'), isTrue);
      expect(text.contains('Lactarius deliciosus'), isTrue);
      expect(text.contains('Amanita phalloides'), isTrue);
      expect(text.contains('Pinus sylvestris'), isTrue);
      expect(text.contains('Arbres Indicadors'), isTrue);
    });
  });
}
