import '../models/insignia.dart';

class BadgeService {
  Future<List<Insignia>> evaluateBadges({
    required int discoveryCount,
    required bool hasRovello,
    required bool hasPinetell,
    required int toxicComparisonViewCount,
    required bool hasTreeAlliance,
    required List<Insignia> currentBadges,
  }) async {
    final updatedBadges = <Insignia>[];

    for (final badge in currentBadges) {
      if (badge.isAwarded) {
        updatedBadges.add(badge);
        continue;
      }

      int newProgress = 0;
      bool newlyAwarded = false;

      switch (badge.id) {
        case 'primer_pas':
        case 'primer_pas_al_bosc':
          newProgress = discoveryCount >= 1 ? 1 : 0;
          break;
        case 'cacador_rovellons':
        case 'cacador_de_rovellons':
          newProgress = (hasRovello ? 1 : 0) + (hasPinetell ? 1 : 0);
          break;
        case 'micoleg_prudent':
          newProgress = toxicComparisonViewCount;
          break;
        case 'alianca_silvestre':
          newProgress = hasTreeAlliance ? 1 : 0;
          break;
        case 'cistell_tardor':
        case 'cistell_de_tardor':
          newProgress = discoveryCount;
          break;
        case 'mestre_boletaire':
          newProgress = discoveryCount;
          break;
      }

      if (newProgress >= badge.targetCount) {
        newlyAwarded = true;
        newProgress = badge.targetCount;
      }

      updatedBadges.add(Insignia(
        id: badge.id,
        nom: badge.nom,
        descripcio: badge.descripcio,
        iconPath: badge.iconPath,
        targetCount: badge.targetCount,
        progressCount: newProgress,
        awardedAt: newlyAwarded ? DateTime.now() : badge.awardedAt,
      ));
    }

    return updatedBadges;
  }
}
