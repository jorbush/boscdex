import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/classifier_service.dart';
import '../domain/services/safety_gate_service.dart';
import '../domain/services/visual_feature_classifier_service.dart';

/// Provider for the [ClassifierService] used for mushroom/tree identification.
///
/// Uses [VisualFeatureClassifierService] to analyze real camera frames
/// using on-device botanical color and morphology profiles.
final classifierProvider = Provider<ClassifierService>((ref) {
  final classifier = VisualFeatureClassifierService();
  ref.onDispose(() => classifier.dispose());
  return classifier;
});

/// Default [SafetyGateService] provider with standard safety thresholds.
final safetyGateServiceProvider = Provider<SafetyGateService>((ref) {
  return SafetyGateService(toxicLookalikesData: const {});
});
