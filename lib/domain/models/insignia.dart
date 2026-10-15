import '../../core/constants/app_constants.dart';

class Insignia {
  final String id;
  final String nom;
  final String descripcio;
  final String iconPath;
  final DateTime? awardedAt;
  final int progressCount;
  final int targetCount;

  const Insignia({
    required this.id,
    required this.nom,
    required this.descripcio,
    required this.iconPath,
    this.awardedAt,
    required this.progressCount,
    required this.targetCount,
  });

  bool get isAwarded => awardedAt != null;

  static const List<Insignia> registry = [
    Insignia(
      id: 'primer_pas_al_bosc',
      nom: 'Primer pas al bosc',
      descripcio: 'Descobreix el teu primer bolet',
      iconPath: 'assets/badges/primer_pas.png',
      progressCount: 0,
      targetCount: 1,
    ),
    Insignia(
      id: 'cacador_de_rovellons',
      nom: 'Caçador de rovellons',
      descripcio: 'Troba tant el rovelló com el pinetell',
      iconPath: 'assets/badges/cacador_rovellons.png',
      progressCount: 0,
      targetCount: 2,
    ),
    Insignia(
      id: 'micoleg_prudent',
      nom: 'Micòleg prudent',
      descripcio: 'Consulta 5 vegades les comparacions amb bolets tòxics',
      iconPath: 'assets/badges/micoleg_prudent.png',
      progressCount: 0,
      targetCount: 5,
    ),
    Insignia(
      id: 'alianca_silvestre',
      nom: 'Aliança silvestre',
      descripcio: 'Troba un bolet i visita el seu arbre associat',
      iconPath: 'assets/badges/alianca_silvestre.png',
      progressCount: 0,
      targetCount: 1,
    ),
    Insignia(
      id: 'cistell_de_tardor',
      nom: 'Cistell de tardor',
      descripcio: 'Descobreix 15 bolets diferents',
      iconPath: 'assets/badges/cistell_tardor.png',
      progressCount: 0,
      targetCount: 15,
    ),
    Insignia(
      id: 'mestre_boletaire',
      nom: 'Mestre boletaire',
      descripcio: 'Descobreix 20 bolets diferents',
      iconPath: 'assets/badges/mestre_boletaire.png',
      progressCount: 0,
      targetCount: 20,
    ),
    Insignia(
      id: 'senyor_dels_ceps',
      nom: 'Senyor dels ceps',
      descripcio: 'Troba tant el cep com el cep negre',
      iconPath: 'assets/badges/senyor_dels_ceps.png',
      progressCount: 0,
      targetCount: 2,
    ),
    Insignia(
      id: 'gourmet_del_bosc',
      nom: 'Gourmet del bosc',
      descripcio:
          'Descobreix 4 joies gastronòmiques: cep, ou de reig, rossinyol i trompeta de la mort',
      iconPath: 'assets/badges/gourmet_del_bosc.png',
      progressCount: 0,
      targetCount: 4,
    ),
    Insignia(
      id: 'amic_dels_arbres',
      nom: 'Amic dels arbres',
      descripcio: 'Identifica els 5 arbres indicadors de Catalunya',
      iconPath: 'assets/badges/amic_dels_arbres.png',
      progressCount: 0,
      targetCount: 5,
    ),
    Insignia(
      id: 'esperit_de_primavera',
      nom: 'Esperit de primavera',
      descripcio:
          'Troba 3 bolets emblemàtics de primavera: múrgola, moixernó i carrereta',
      iconPath: 'assets/badges/esperit_primavera.png',
      progressCount: 0,
      targetCount: 3,
    ),
    Insignia(
      id: 'sentinella_toxic',
      nom: 'Sentinella del bosc',
      descripcio: 'Consulta 15 alertes de confusió perillosa',
      iconPath: 'assets/badges/sentinella_toxic.png',
      progressCount: 0,
      targetCount: 15,
    ),
    Insignia(
      id: 'quadern_de_camp',
      nom: 'Quadern de camp',
      descripcio: 'Registra 10 avistaments al teu diari de camp',
      iconPath: 'assets/badges/quadern_de_camp.png',
      progressCount: 0,
      targetCount: 10,
    ),
    Insignia(
      id: 'cartograf_del_bosc',
      nom: 'Cartògraf del bosc',
      descripcio: 'Registra 5 avistaments amb coordenades GPS',
      iconPath: 'assets/badges/cartograf_del_bosc.png',
      progressCount: 0,
      targetCount: 5,
    ),
    Insignia(
      id: 'gran_enciclopedia',
      nom: 'Gran enciclopèdia',
      descripcio:
          'Completa el catàleg descobrint tots els ${AppConstants.catalogSpeciesCount} bolets de la Boscdex',
      iconPath: 'assets/badges/gran_enciclopedia.png',
      progressCount: 0,
      targetCount: AppConstants.catalogSpeciesCount,
    ),
  ];
}
