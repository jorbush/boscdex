import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/reference_photo_service.dart';

/// Provider for [ReferencePhotoService] managing botanical photos & CC attributions.
final referencePhotoServiceProvider = Provider<ReferencePhotoService>((ref) {
  final service = ReferencePhotoService();
  // Fire and forget initialization; getters handle null gracefully.
  service.initialize();
  return service;
});
