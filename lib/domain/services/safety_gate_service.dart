import '../models/classificacio_result.dart';
import '../models/edibilitat.dart';
import '../models/nivell_seguretat.dart';

/// Evaluates field safety protocols based on Edge-ML classification outputs,
/// confidence thresholds, known toxic lookalikes, and specimen toxicity.
class SafetyGateService {
  final Map<String, List<String>> _toxicLookalikesData;
  final double confidenceThreshold;

  SafetyGateService({
    required Map<String, List<String>> toxicLookalikesData,
    this.confidenceThreshold = 0.70,
  }) : _toxicLookalikesData = toxicLookalikesData;

  /// Evaluates safety level based on candidates, lookalikes, and specimen edibility.
  NivellSeguretat evaluateSafety(
    List<ClassificacioResult> results, {
    Edibilitat? edibility,
  }) {
    if (results.isEmpty) return NivellSeguretat.incert;

    final topResult = results.first;

    // Below certainty threshold -> uncertain
    if (topResult.confidence < confidenceThreshold) {
      return NivellSeguretat.incert;
    }

    // Specimen itself is toxic or mortal -> danger
    if (edibility == Edibilitat.toxic || edibility == Edibilitat.mortal) {
      return NivellSeguretat.perill;
    }

    // Has dangerous lookalikes -> possible confusion
    final lookalikes = _toxicLookalikesData[topResult.boletId] ?? [];
    if (lookalikes.isNotEmpty) {
      return NivellSeguretat.confusioPossible;
    }

    // Confident match with no dangerous lookalikes
    return NivellSeguretat.segur;
  }
}
