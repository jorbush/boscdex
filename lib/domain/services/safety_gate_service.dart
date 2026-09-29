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
  ///
  /// CRITICAL SAFETY PROTOCOL:
  /// 1. If specimen itself is toxic or mortal, it is ALWAYS a danger ([NivellSeguretat.perill]),
  ///    regardless of confidence score. Low-confidence mortal predictions must NEVER suppress warnings.
  /// 2. If edibility is unverified/null, it fails closed to uncertain ([NivellSeguretat.incert]).
  /// 3. If confidence is below threshold, it returns [NivellSeguretat.incert].
  /// 4. If high confidence but has known toxic lookalikes, it returns [NivellSeguretat.confusioPossible].
  /// 5. Only high-confidence matches with verified non-toxic edibility and no toxic lookalikes return [NivellSeguretat.segur].
  NivellSeguretat evaluateSafety(
    List<ClassificacioResult> results, {
    Edibilitat? edibility,
  }) {
    if (results.isEmpty) return NivellSeguretat.incert;

    final topResult = results.first;

    // 1. Highest priority: specimen itself is toxic or mortal -> danger.
    // This MUST evaluate before the confidence threshold so that low-confidence
    // predictions of lethal or toxic species never suppress the danger alert.
    if (edibility == Edibilitat.toxic || edibility == Edibilitat.mortal) {
      return NivellSeguretat.perill;
    }

    // 2. Below certainty threshold -> uncertain
    if (topResult.confidence < confidenceThreshold) {
      return NivellSeguretat.incert;
    }

    // 3. Has dangerous lookalikes -> possible confusion
    final lookalikes = _toxicLookalikesData[topResult.boletId] ?? [];
    if (lookalikes.isNotEmpty) {
      return NivellSeguretat.confusioPossible;
    }

    // 4. Unknown edibility cannot be certified as safe
    if (edibility == null) {
      return NivellSeguretat.incert;
    }

    // 5. Confident match with verified edibility and no dangerous lookalikes
    return NivellSeguretat.segur;
  }
}
