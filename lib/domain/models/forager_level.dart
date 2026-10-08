/// Represents a rank tier definition in the Boscdex forager leveling system.
class ForagerLevelDefinition {
  final int level;
  final int xpThreshold;
  final String titleCa;
  final String titleEs;
  final String titleEn;

  const ForagerLevelDefinition({
    required this.level,
    required this.xpThreshold,
    required this.titleCa,
    required this.titleEs,
    required this.titleEn,
  });

  String title(String languageCode) {
    switch (languageCode) {
      case 'es':
        return titleEs;
      case 'en':
        return titleEn;
      case 'ca':
      default:
        return titleCa;
    }
  }
}

/// Represents the player's dynamic forager research level, XP progress,
/// and activity breakdown in the forest.
class ForagerLevel {
  final int level;
  final int totalXp;
  final int currentLevelBaseXp;
  final int? nextLevelThresholdXp;
  final int currentLevelXp;
  final int nextLevelXpRequired;
  final double progress;
  final bool isMaxLevel;

  final String titleCa;
  final String titleEs;
  final String titleEn;

  final int discoveredBolets;
  final int identifiedArbres;
  final int awardedBadges;
  final int totalSightings;

  final int xpFromBolets;
  final int xpFromArbres;
  final int xpFromBadges;
  final int xpFromSightings;

  const ForagerLevel({
    required this.level,
    required this.totalXp,
    required this.currentLevelBaseXp,
    this.nextLevelThresholdXp,
    required this.currentLevelXp,
    required this.nextLevelXpRequired,
    required this.progress,
    required this.isMaxLevel,
    required this.titleCa,
    required this.titleEs,
    required this.titleEn,
    required this.discoveredBolets,
    required this.identifiedArbres,
    required this.awardedBadges,
    required this.totalSightings,
    required this.xpFromBolets,
    required this.xpFromArbres,
    required this.xpFromBadges,
    required this.xpFromSightings,
  });

  String title(String languageCode) {
    switch (languageCode) {
      case 'es':
        return titleEs;
      case 'en':
        return titleEn;
      case 'ca':
      default:
        return titleCa;
    }
  }

  /// XP awarded per unique mushroom discovered
  static const int xpPerBolet = 100;

  /// XP awarded per unique indicator tree identified
  static const int xpPerArbre = 75;

  /// XP awarded per achievement badge awarded
  static const int xpPerBadge = 150;

  /// XP awarded per journal field sighting recorded
  static const int xpPerSighting = 25;

  /// All 10 progression ranks in the Boscdex adventure
  static const List<ForagerLevelDefinition> allLevels = [
    ForagerLevelDefinition(
      level: 1,
      xpThreshold: 0,
      titleCa: 'Novell del Bosc',
      titleEs: 'Novato del Bosque',
      titleEn: 'Forest Rookie',
    ),
    ForagerLevelDefinition(
      level: 2,
      xpThreshold: 100,
      titleCa: 'Cercador Curiós',
      titleEs: 'Buscador Curioso',
      titleEn: 'Curious Seeker',
    ),
    ForagerLevelDefinition(
      level: 3,
      xpThreshold: 250,
      titleCa: 'Rastrejador Silvestre',
      titleEs: 'Rastreador Silvestre',
      titleEn: 'Wilderness Tracker',
    ),
    ForagerLevelDefinition(
      level: 4,
      xpThreshold: 500,
      titleCa: 'Explorador dels Pins',
      titleEs: 'Explorador de los Pinos',
      titleEn: 'Pine Explorer',
    ),
    ForagerLevelDefinition(
      level: 5,
      xpThreshold: 850,
      titleCa: 'Boletaire de Camp',
      titleEs: 'Recolector de Campo',
      titleEn: 'Field Forager',
    ),
    ForagerLevelDefinition(
      level: 6,
      xpThreshold: 1300,
      titleCa: 'Guia de la Fageda',
      titleEs: 'Guía del Hayedo',
      titleEn: 'Beechwood Guide',
    ),
    ForagerLevelDefinition(
      level: 7,
      xpThreshold: 1900,
      titleCa: 'Expert Micòleg',
      titleEs: 'Experto Micólogo',
      titleEn: 'Expert Mycologist',
    ),
    ForagerLevelDefinition(
      level: 8,
      xpThreshold: 2650,
      titleCa: 'Guardià del Sotabosc',
      titleEs: 'Guardián del Sotobosque',
      titleEn: 'Understory Guardian',
    ),
    ForagerLevelDefinition(
      level: 9,
      xpThreshold: 3550,
      titleCa: 'Cistell Daurat',
      titleEs: 'Cesta Dorada',
      titleEn: 'Golden Basket',
    ),
    ForagerLevelDefinition(
      level: 10,
      xpThreshold: 4600,
      titleCa: 'Mestre del Bosc',
      titleEs: 'Maestro del Bosque',
      titleEn: 'Master of the Forest',
    ),
  ];

  /// Default level state for a beginner user with 0 stats.
  factory ForagerLevel.initial() => ForagerLevel.calculate(
        discoveredBolets: 0,
        identifiedArbres: 0,
        awardedBadges: 0,
        totalSightings: 0,
      );

  /// Calculates dynamic level, XP progression, and statistics from player milestones.
  factory ForagerLevel.calculate({
    required int discoveredBolets,
    required int identifiedArbres,
    required int awardedBadges,
    required int totalSightings,
  }) {
    final safeBolets = discoveredBolets < 0 ? 0 : discoveredBolets;
    final safeArbres = identifiedArbres < 0 ? 0 : identifiedArbres;
    final safeBadges = awardedBadges < 0 ? 0 : awardedBadges;
    final safeSightings = totalSightings < 0 ? 0 : totalSightings;

    final xpFromBolets = safeBolets * xpPerBolet;
    final xpFromArbres = safeArbres * xpPerArbre;
    final xpFromBadges = safeBadges * xpPerBadge;
    final xpFromSightings = safeSightings * xpPerSighting;

    final totalXp =
        xpFromBolets + xpFromArbres + xpFromBadges + xpFromSightings;

    ForagerLevelDefinition currentDef = allLevels.first;
    ForagerLevelDefinition? nextDef;

    for (int i = 0; i < allLevels.length; i++) {
      if (totalXp >= allLevels[i].xpThreshold) {
        currentDef = allLevels[i];
        if (i + 1 < allLevels.length) {
          nextDef = allLevels[i + 1];
        } else {
          nextDef = null;
        }
      }
    }

    final isMax = nextDef == null;
    final base = currentDef.xpThreshold;
    final target = nextDef?.xpThreshold;
    final span = isMax ? 1 : (target! - base);
    final inLevel = isMax ? 0 : (totalXp - base);
    final prog = isMax ? 1.0 : (inLevel / span).clamp(0.0, 1.0);

    return ForagerLevel(
      level: currentDef.level,
      totalXp: totalXp,
      currentLevelBaseXp: base,
      nextLevelThresholdXp: target,
      currentLevelXp: inLevel,
      nextLevelXpRequired: isMax ? 0 : span,
      progress: prog,
      isMaxLevel: isMax,
      titleCa: currentDef.titleCa,
      titleEs: currentDef.titleEs,
      titleEn: currentDef.titleEn,
      discoveredBolets: safeBolets,
      identifiedArbres: safeArbres,
      awardedBadges: safeBadges,
      totalSightings: safeSightings,
      xpFromBolets: xpFromBolets,
      xpFromArbres: xpFromArbres,
      xpFromBadges: xpFromBadges,
      xpFromSightings: xpFromSightings,
    );
  }
}
