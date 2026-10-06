import '../models/classificacio_result.dart';
import '../models/edibilitat.dart';
import '../models/nivell_seguretat.dart';

/// Evaluates field safety protocols based on Edge-ML classification outputs,
/// confidence thresholds, known toxic lookalikes, and specimen toxicity.
class SafetyGateService {
  final Map<String, List<String>> _toxicLookalikesData;
  final double confidenceThreshold;
  final double secondaryToxicConfidenceThreshold;
  final double overwhelmingConfidenceThreshold;

  SafetyGateService({
    required Map<String, List<String>> toxicLookalikesData,
    this.confidenceThreshold = 0.70,
    this.secondaryToxicConfidenceThreshold = 0.15,
    this.overwhelmingConfidenceThreshold = 0.88,
  }) : _toxicLookalikesData = toxicLookalikesData;

  /// Evaluates safety level based on candidates, lookalikes, specimen edibility,
  /// and runner-up candidate toxicities.
  ///
  /// CRITICAL SAFETY PROTOCOL:
  /// 1. If specimen itself is toxic or mortal, it is ALWAYS a danger ([NivellSeguretat.perill]),
  ///    regardless of confidence score. Low-confidence mortal predictions must NEVER suppress warnings.
  /// 2. If confidence is below threshold, it returns [NivellSeguretat.incert].
  /// 3. If high confidence but has known toxic lookalikes, it returns [NivellSeguretat.confusioPossible].
  /// 4. Top-N Multi-Candidate Toxicity Gate:
  ///    If any runner-up candidate in top-3 has toxic/mortal edibility with meaningful confidence
  ///    (>= [secondaryToxicConfidenceThreshold]) and top candidate confidence is not overwhelming
  ///    (< [overwhelmingConfidenceThreshold]), escalate to [NivellSeguretat.confusioPossible].
  /// 5. If edibility is unverified/null, it fails closed to uncertain ([NivellSeguretat.incert]).
  /// 6. Only high-confidence matches with verified non-toxic edibility, no toxic lookalikes,
  ///    and no secondary lethal/toxic ambiguity return [NivellSeguretat.segur].
  NivellSeguretat evaluateSafety(
    List<ClassificacioResult> results, {
    Edibilitat? edibility,
    Map<String, Edibilitat>? candidatesEdibility,
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

    // 4. Top-N Multi-Candidate Toxicity Gate:
    // If any runner-up candidate in top-3 has toxic/mortal edibility with meaningful confidence
    // and top confidence is not overwhelming, escalate to possible confusion.
    if (candidatesEdibility != null &&
        topResult.confidence < overwhelmingConfidenceThreshold) {
      for (final candidate in results.skip(1).take(2)) {
        final candEdibility = candidatesEdibility[candidate.boletId];
        if ((candEdibility == Edibilitat.toxic ||
                candEdibility == Edibilitat.mortal) &&
            candidate.confidence >= secondaryToxicConfidenceThreshold) {
          return NivellSeguretat.confusioPossible;
        }
      }
    }

    // 5. Unknown edibility cannot be certified as safe
    if (edibility == null) {
      return NivellSeguretat.incert;
    }

    // 6. Confident match with verified edibility, no dangerous lookalikes,
    // and no runner-up toxicity ambiguity
    return NivellSeguretat.segur;
  }
}
