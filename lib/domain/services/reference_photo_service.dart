import 'dart:convert';
import 'package:flutter/services.dart';

/// Metadata for a Creative Commons licensed botanical reference photo.
class ReferencePhotoAttribution {
  final String speciesId;
  final String scientificName;
  final String catalanName;
  final int? photoId;
  final String author;
  final String licenseCode;
  final String licenseName;
  final String attributionText;
  final String sourceUrl;
  final String assetPath;

  const ReferencePhotoAttribution({
    required this.speciesId,
    required this.scientificName,
    required this.catalanName,
    this.photoId,
    required this.author,
    required this.licenseCode,
    required this.licenseName,
    required this.attributionText,
    required this.sourceUrl,
    required this.assetPath,
  });

  factory ReferencePhotoAttribution.fromJson(Map<String, dynamic> json) {
    return ReferencePhotoAttribution(
      speciesId: json['species_id'] as String? ?? '',
      scientificName: json['scientific_name'] as String? ?? '',
      catalanName: json['catalan_name'] as String? ?? '',
      photoId: json['photo_id'] is int
          ? json['photo_id'] as int
          : int.tryParse(json['photo_id']?.toString() ?? ''),
      author: json['author'] as String? ?? 'Comunitat iNaturalist',
      licenseCode: json['license_code'] as String? ?? 'cc-by-sa',
      licenseName: json['license_name'] as String? ?? 'CC BY-SA 4.0',
      attributionText: json['attribution_text'] as String? ?? '',
      sourceUrl: json['source_url'] as String? ?? '',
      assetPath: json['asset_path'] as String? ??
          'assets/images/reference/${json['species_id']}.jpg',
    );
  }

  Map<String, dynamic> toJson() => {
        'species_id': speciesId,
        'scientific_name': scientificName,
        'catalan_name': catalanName,
        'photo_id': photoId,
        'author': author,
        'license_code': licenseCode,
        'license_name': licenseName,
        'attribution_text': attributionText,
        'source_url': sourceUrl,
        'asset_path': assetPath,
      };

  /// Whether the license is completely open and free (CC0, CC-BY, CC-BY-SA).
  bool get isOpenLicense {
    final code = licenseCode.toLowerCase();
    return code == 'cc0' || code == 'cc-by' || code == 'cc-by-sa';
  }
}

/// Service that manages botanical reference photos and their legal CC attributions.
class ReferencePhotoService {
  static const String attributionsAssetPath =
      'assets/images/reference/attributions.json';
  static const String referenceImagesDir = 'assets/images/reference';

  Map<String, ReferencePhotoAttribution>? _attributions;
  bool _isLoading = false;

  /// Loads attributions from bundled JSON.
  Future<void> initialize([AssetBundle? bundle]) async {
    if (_attributions != null) return;
    if (_isLoading) return;

    _isLoading = true;
    try {
      final actualBundle = bundle ?? rootBundle;
      final jsonString = await actualBundle.loadString(attributionsAssetPath);
      final dynamic decoded = jsonDecode(jsonString);

      final map = <String, ReferencePhotoAttribution>{};
      if (decoded is List) {
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            final attr = ReferencePhotoAttribution.fromJson(item);
            if (attr.speciesId.isNotEmpty) {
              map[attr.speciesId] = attr;
            }
          }
        }
      } else if (decoded is Map<String, dynamic>) {
        decoded.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            map[key] = ReferencePhotoAttribution.fromJson(value);
          }
        });
      }

      _attributions = map;
    } catch (_) {
      // Fallback: empty map if not yet generated or asset loading fails
      _attributions ??= {};
    } finally {
      _isLoading = false;
    }
  }

  /// Synchronously returns the attribution for a species, or null if not yet loaded.
  ReferencePhotoAttribution? getAttribution(String speciesId) {
    return _attributions?[speciesId];
  }

  /// Returns the asset path for the botanical reference photo of [speciesId].
  String getReferenceAssetPath(String speciesId) {
    final attr = _attributions?[speciesId];
    if (attr != null && attr.assetPath.isNotEmpty) {
      return attr.assetPath;
    }
    return '$referenceImagesDir/$speciesId.jpg';
  }

  /// Returns all registered attributions.
  List<ReferencePhotoAttribution> getAllAttributions() {
    return _attributions?.values.toList() ?? const [];
  }

  /// Sets attributions directly (useful for unit testing).
  void setAttributionsForTesting(Map<String, ReferencePhotoAttribution> map) {
    _attributions = map;
  }
}
