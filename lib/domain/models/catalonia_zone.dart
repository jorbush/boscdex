import 'package:flutter/material.dart';

/// Natural foraging zones and geographic regions of Catalonia.
enum CataloniaZone {
  altPirineu,
  prepirineuCentral,
  transversalMontseny,
  litoralPrelitoral,
  ponent,
  serraladaSudPrades,
  portsTerresEbre,
}

extension CataloniaZoneExtension on CataloniaZone {
  String get id {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'alt_pirineu';
      case CataloniaZone.prepirineuCentral:
        return 'prepirineu_central';
      case CataloniaZone.transversalMontseny:
        return 'transversal_montseny';
      case CataloniaZone.litoralPrelitoral:
        return 'litoral_prelitoral';
      case CataloniaZone.ponent:
        return 'ponent';
      case CataloniaZone.serraladaSudPrades:
        return 'serralada_sud_prades';
      case CataloniaZone.portsTerresEbre:
        return 'ports_terres_ebre';
    }
  }

  String get label {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'Alt Pirineu i Aran';
      case CataloniaZone.prepirineuCentral:
        return 'Prepirineu i Cat. Central';
      case CataloniaZone.transversalMontseny:
        return 'Serralada Transversal i Montseny';
      case CataloniaZone.litoralPrelitoral:
        return 'Litoral i Prelitoral';
      case CataloniaZone.ponent:
        return 'Plana de Ponent';
      case CataloniaZone.serraladaSudPrades:
        return 'Muntanyes de Prades i Tarragona';
      case CataloniaZone.portsTerresEbre:
        return 'Terres de l\'Ebre i Els Ports';
    }
  }

  String get shortLabel {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'Alt Pirineu';
      case CataloniaZone.prepirineuCentral:
        return 'Prepirineu / Central';
      case CataloniaZone.transversalMontseny:
        return 'Girona / Montseny';
      case CataloniaZone.litoralPrelitoral:
        return 'Litoral / Prelitoral';
      case CataloniaZone.ponent:
        return 'Ponent';
      case CataloniaZone.serraladaSudPrades:
        return 'Prades / Camp';
      case CataloniaZone.portsTerresEbre:
        return 'Els Ports / Ebre';
    }
  }

  String get comarques {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'Val d\'Aran, Pallars Sobirà, Alta Ribagorça, Alt Urgell, Cerdanya';
      case CataloniaZone.prepirineuCentral:
        return 'Berguedà, Solsonès, Ripollès, Osona, Moianès, Lluçanès';
      case CataloniaZone.transversalMontseny:
        return 'Garrotxa, Guilleries, Montseny, Selva, Gironès, Empordà';
      case CataloniaZone.litoralPrelitoral:
        return 'Maresme, Vallès, Garraf, Baix Llobregat, Penedès';
      case CataloniaZone.ponent:
        return 'Segrià, Noguera, Urgell, Pla d\'Urgell, Segarra, Garrigues';
      case CataloniaZone.serraladaSudPrades:
        return 'Priorat, Muntanyes de Prades, Conca de Barberà, Alt/Baix Camp';
      case CataloniaZone.portsTerresEbre:
        return 'Massís dels Ports, Terra Alta, Baix Ebre, Montsià, Ribera d\'Ebre';
    }
  }

  String get habitatDescription {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'Pinedes de pi negre i pi roig, fagedes alpines i prats subalpins (1000m - 2000m+).';
      case CataloniaZone.prepirineuCentral:
        return 'Bressol tradicional dels boletaires. Pinedes de pi roig, fagedes ombrívoles i rouredes (600m - 1600m).';
      case CataloniaZone.transversalMontseny:
        return 'Boscos humits i silícics de faig, castanyer, alzina i sureda (200m - 1400m).';
      case CataloniaZone.litoralPrelitoral:
        return 'Pinedes de pi blanc mediterrani, alzinars litorals i garrigues costaneres (0m - 800m).';
      case CataloniaZone.ponent:
        return 'Boscos de ribera (verdes i salzedes), conreus i pastures continentals (150m - 600m).';
      case CataloniaZone.serraladaSudPrades:
        return 'Serres litorals i prelitorals amb barreja de sòls calcaris i silícics (400m - 1200m).';
      case CataloniaZone.portsTerresEbre:
        return 'Fagedes relictes meridionals i pinedes calcàries dels Ports de Beseit (100m - 1400m).';
    }
  }

  /// Relative rectangle coordinates (0.0 to 1.0) on the 4:3 regional map of Catalonia.
  Rect get relativeBounds {
    switch (this) {
      case CataloniaZone.altPirineu:
        return const Rect.fromLTWH(0.06, 0.05, 0.44, 0.22);
      case CataloniaZone.prepirineuCentral:
        return const Rect.fromLTWH(0.28, 0.23, 0.34, 0.24);
      case CataloniaZone.transversalMontseny:
        return const Rect.fromLTWH(0.60, 0.18, 0.32, 0.30);
      case CataloniaZone.litoralPrelitoral:
        return const Rect.fromLTWH(0.38, 0.50, 0.32, 0.22);
      case CataloniaZone.ponent:
        return const Rect.fromLTWH(0.03, 0.28, 0.28, 0.38);
      case CataloniaZone.serraladaSudPrades:
        return const Rect.fromLTWH(0.18, 0.64, 0.28, 0.18);
      case CataloniaZone.portsTerresEbre:
        return const Rect.fromLTWH(0.04, 0.77, 0.26, 0.19);
    }
  }

  static CataloniaZone fromString(String str) {
    for (final zone in CataloniaZone.values) {
      if (zone.id == str || zone.name == str) {
        return zone;
      }
    }
    return CataloniaZone.prepirineuCentral;
  }
}
