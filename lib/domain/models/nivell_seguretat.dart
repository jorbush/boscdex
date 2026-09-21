/// Represents the safety assessment level for an identified mushroom specimen.
enum NivellSeguretat {
  /// Confident classification of a safe/edible species with no toxic lookalikes.
  segur,

  /// Species has known toxic lookalikes requiring careful morphological cross-checking.
  confusioPossible,

  /// Classification confidence is below the safety threshold (< 0.70).
  incert,

  /// The identified specimen itself is toxic or lethal. Extreme danger.
  perill,
}
