import 'nivell_seguretat.dart';

class ClassificacioResult {
  final String boletId;
  final String displayName;
  final double confidence;

  const ClassificacioResult({
    required this.boletId,
    required this.displayName,
    required this.confidence,
  });
}

class ClassificacioResponse {
  final List<ClassificacioResult> candidates;
  final NivellSeguretat safetyLevel;
  final List<String>? toxicLookalikeIds;

  const ClassificacioResponse({
    required this.candidates,
    required this.safetyLevel,
    this.toxicLookalikeIds,
  });
}

class ArbreClassificacioResult {
  final String arbreId;
  final String displayName;
  final double confidence;

  const ArbreClassificacioResult({
    required this.arbreId,
    required this.displayName,
    required this.confidence,
  });
}
