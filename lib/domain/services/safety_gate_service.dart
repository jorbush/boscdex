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
  final double lethalConfidenceThreshold;

  /// The 8 lethal Catalan taxa containing amatoxins, orellanine, gyromitrin, paxillus syndrome, or lethal muscarine.
  static const Set<String> lethalSpecies = {
    'amanita_phalloides',
    'amanita_verna',
    'amanita_virosa',
    'cortinarius_orellanus',
    'galerina_marginata',
    'gyromitra_esculenta',
    'paxillus_involutus',
    'inocybe_erubescens',
  };

  SafetyGateService({
    required Map<String, List<String>> toxicLookalikesData,
    this.confidenceThreshold = 0.70,
    this.secondaryToxicConfidenceThreshold = 0.15,
    this.overwhelmingConfidenceThreshold = 0.88,
    this.lethalConfidenceThreshold = 0.10,
  }) : _toxicLookalikesData = toxicLookalikesData;

  /// Detects whether any candidate in the top predictions is a lethal taxon
  /// with confidence >= [lethalConfidenceThreshold].
  ClassificacioResult? findLethalCandidate(
    List<ClassificacioResult> results, {
    Map<String, Edibilitat>? candidatesEdibility,
    int maxCandidates = 3,
  }) {
    for (final candidate in results.take(maxCandidates)) {
      final isLethalId = lethalSpecies.contains(candidate.boletId);
      final isLethalEd =
          candidatesEdibility?[candidate.boletId] == Edibilitat.mortal;
      if ((isLethalId || isLethalEd) &&
          candidate.confidence >= lethalConfidenceThreshold) {
        return candidate;
      }
    }
    return null;
  }

  /// Evaluates safety level based on candidates, lookalikes, specimen edibility,
  /// and runner-up candidate toxicities.
  ///
  /// CRITICAL SAFETY PROTOCOL:
  /// 1. Zero-Tolerance Lethal Gate: If ANY candidate in the top-3 predictions is a lethal
  ///    taxon with confidence >= [lethalConfidenceThreshold] (10%), or specimen itself is toxic/mortal,
  ///    it is ALWAYS escalated to danger ([NivellSeguretat.perill]). Low-confidence lethal predictions
  ///    must NEVER be suppressed or overshadowed by an edible match.
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

    // 0. Zero-Tolerance Lethal Gate: If ANY candidate in top-3 is mortal (>=10%),
    // immediately escalate to perill (danger).
    final lethalCandidate = findLethalCandidate(
      results,
      candidatesEdibility: candidatesEdibility,
    );
    if (lethalCandidate != null) {
      return NivellSeguretat.perill;
    }

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
