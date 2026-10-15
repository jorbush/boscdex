import '../models/insignia.dart';

class BadgeService {
  Future<List<Insignia>> evaluateBadges({
    required int discoveryCount,
    bool hasRovello = false,
    bool hasPinetell = false,
    required int toxicComparisonViewCount,
    required bool hasTreeAlliance,
    required List<Insignia> currentBadges,
    Set<String> discoveredBoletIds = const {},
    int visitedTreeCount = 0,
    int sightingCount = 0,
    int gpsSightingCount = 0,
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
          final r =
              hasRovello || discoveredBoletIds.contains('lactarius_deliciosus');
          final p = hasPinetell ||
              discoveredBoletIds.contains('lactarius_sanguifluus');
          newProgress = (r ? 1 : 0) + (p ? 1 : 0);
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
        case 'senyor_dels_ceps':
          newProgress = [
            'boletus_edulis',
            'boletus_aereus',
          ].where((id) => discoveredBoletIds.contains(id)).length;
          break;
        case 'gourmet_del_bosc':
          newProgress = [
            'boletus_edulis',
            'amanita_caesarea',
            'cantharellus_cibarius',
            'craterellus_cornucopioides',
          ].where((id) => discoveredBoletIds.contains(id)).length;
          break;
        case 'amic_dels_arbres':
          newProgress = visitedTreeCount;
          break;
        case 'esperit_de_primavera':
          newProgress = [
            'morchella_esculenta',
            'calocybe_gambosa',
            'marasmius_oreades',
          ].where((id) => discoveredBoletIds.contains(id)).length;
          break;
        case 'sentinella_toxic':
          newProgress = toxicComparisonViewCount;
          break;
        case 'quadern_de_camp':
          newProgress = sightingCount;
          break;
        case 'cartograf_del_bosc':
          newProgress = gpsSightingCount;
          break;
        case 'gran_enciclopedia':
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
