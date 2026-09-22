import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/classifier_service.dart';
import '../domain/services/safety_gate_service.dart';
import '../domain/services/tflite_classifier_service.dart';

/// Provider for the [ClassifierService] used for mushroom/tree identification.
///
/// Uses [TfliteClassifierService] for on-device deep learning neural inference
/// with graceful fallback to botanical visual feature analysis.
final classifierProvider = Provider<ClassifierService>((ref) {
  final classifier = TfliteClassifierService();
  ref.onDispose(() => classifier.dispose());
  return classifier;
});

/// Default [SafetyGateService] provider with standard safety thresholds.
final safetyGateServiceProvider = Provider<SafetyGateService>((ref) {
  return SafetyGateService(toxicLookalikesData: const {});
});
