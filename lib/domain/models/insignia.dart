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
  ];
}
