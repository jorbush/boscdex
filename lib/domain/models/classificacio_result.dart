import 'nivell_seguretat.dart';

/// Represents the classification result for a mushroom candidate.
class MushroomClassificationResult {
  final String boletId;
  final String displayName;
  final double confidence;

  String get mushroomId => boletId;

  const MushroomClassificationResult({
    required this.boletId,
    required this.displayName,
    required this.confidence,
  });
}

/// Backwards-compatible alias for [MushroomClassificationResult].
typedef ClassificacioResult = MushroomClassificationResult;

/// Comprehensive classification response including safety gate evaluation.
class ClassificacioResponse {
  final List<MushroomClassificationResult> candidates;
  final NivellSeguretat safetyLevel;
  final List<String>? toxicLookalikeIds;

  const ClassificacioResponse({
    required this.candidates,
    required this.safetyLevel,
    this.toxicLookalikeIds,
  });
}

/// Represents the classification result for an indicator tree candidate.
class TreeClassificationResult {
  final String arbreId;
  final String displayName;
  final double confidence;

  String get treeId => arbreId;

  const TreeClassificationResult({
    required this.arbreId,
    required this.displayName,
    required this.confidence,
  });
}

/// Backwards-compatible alias for [TreeClassificationResult].
typedef ArbreClassificacioResult = TreeClassificationResult;
