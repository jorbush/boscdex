import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/classifier_service.dart';
import '../domain/services/safety_gate_service.dart';

/// Provider for the [ClassifierService] used for mushroom/tree identification.
///
/// Returns a [MockClassifierService] for local development and testing.
final classifierProvider = Provider<ClassifierService>((ref) {
  final classifier = MockClassifierService();
  ref.onDispose(() => classifier.dispose());
  return classifier;
});

/// Default [SafetyGateService] provider with standard safety thresholds.
final safetyGateServiceProvider = Provider<SafetyGateService>((ref) {
  return SafetyGateService(toxicLookalikesData: const {});
});
